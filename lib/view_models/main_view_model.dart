import 'dart:developer';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

class MainNotifier extends StateNotifier {
  MainNotifier(this.ref) : super(ref);
  final Ref ref;

  Future<void> backUpContact(context) async {
    //Get permission status
    final permission = await getContactPermission();
    if (permission == PermissionStatus.granted) {
      //Get all contacts on device
      getContactFromDevice();
    } else {
      showPermission(permission, context);
    }
  }

  getContactFromDevice() async {
    //Get contact
    List<Contact> contacts = await ContactsService.getContacts();
    //Convert contacts list to json
    String json = jsonEncode(contacts.map((e) => e.toMap()).toList());
    convertContactsToFile(json);
  }

  // Convert contacts list to file to push Firebase Firestore
  convertContactsToFile(String json) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/json.txt');
    file.writeAsString(json);
    pushInformationToFirestore(file);
  }

  pushInformationToFirestore(File file) async {
    String name = "phone_" + DateTime.now().toString();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final storageRef = FirebaseStorage.instance.ref().child('$uid/$name');
    try {
      await storageRef.putFile(file);
    } on FirebaseException catch (e) {
      log(e.code + e.toString());
    }
  }

  Future<PermissionStatus> getContactPermission() async {
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
      const snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

final mainNotifierProvider = StateNotifierProvider((ref) => MainNotifier(ref));
