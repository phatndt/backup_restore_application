import 'dart:developer';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

class MainNotifier extends StateNotifier {
  MainNotifier(this.ref) : super(ref);
  final Ref ref;

  getContact(context) async {
    final permission = await getContactPermission();
    if (permission == PermissionStatus.granted) {
      //Get all contacts on device
      List<Contact> contacts = await ContactsService.getContacts();
      // for (Contact contact in contacts) {
      //   log(contact.toMap().toString());
      // }
      String json = jsonEncode(contacts.map((e) => e.toMap()).toList());
      log(json);
      convertContactsToFile(json);
    } else {
      showPermission(permission, context);
    }
  }

  convertContactsToFile(String json) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/json.txt');
    //file.writeAsString(json);
    var time = DateTime.now().toString();
    final storageRef = FirebaseStorage.instance.ref().child(time);
    try {
      await storageRef.putString(json);
    } on FirebaseException catch (e) {
      log(e.code + e.toString());
    }
  }

  Future<PermissionStatus> getContactPermission() async {
    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.phone,
    //   Permission.contacts,
    //   Permission.sms,
    // ].request();
    var status = await Permission.contacts.status;
    if (status.isDenied) {
      final permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return status;
    }
  }

  void showPermission(PermissionStatus permissionStatus, BuildContext context) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

final mainNotifierProvider = StateNotifierProvider((ref) => MainNotifier(ref));
