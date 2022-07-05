import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:backup_restore_application/view_models/backup_interface.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactNotifier extends StateNotifier implements BackupInterface {
  ContactNotifier(this.ref) : super(ref);
  final Ref ref;

  @override
  backUpInformation(BuildContext context) async {
    //Get permission status
    final permission = await getPermission();
    if (permission == PermissionStatus.granted) {
      //Get all contacts on device
      getInformationFromDevice();
    } else {
      showPermission(permission, context);
    }
  }

  @override
  convertInformationToFile(String json) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/json.json');
    file.writeAsString(json);
    pushInformationToFirestore(file);
  }

  @override
  getInformationFromDevice() async {
    //Get contact
    List<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    //Convert contacts list to json
    String json = jsonEncode(contacts.map((e) => e.toMap()).toList());
    convertInformationToFile(json);
  }

  @override
  pushInformationToFirestore(File file) async {
    String name = DateTime.now().toString();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final storageRef =
        FirebaseStorage.instance.ref().child('$uid/contacts/$name');
    try {
      await storageRef.putFile(file);
    } on FirebaseException catch (e) {
      log(e.code + e.toString());
    }
  }

  @override
  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isDenied) {
      final permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return status;
    }
  }

  @override
  showPermission(PermissionStatus permissionStatus, BuildContext context) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  restoreInformation(String pathFile, BuildContext context) async {
    final islandRef = FirebaseStorage.instance.ref().child(pathFile);
    final appDocDir = await getApplicationDocumentsDirectory();
    final path = appDocDir.path;
    final filePath = "$path/backup.json";
    final file = File(filePath);
    final downloadTask = islandRef.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          final parse = jsonDecode(await file.readAsString());
          List<Contact> contacts = parse.map<Contact>((e) {
            Contact contact = convertContactFromMap(e);
            contact.identifier = e['identifier'];
            return contact;
          }).toList();
          ContactsService.addContact(contacts.last).then((value) {
            const snackBar = SnackBar(content: Text('Restore successfully'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }).onError((error, stackTrace) {
            log(error.toString());
          });
          // for (var element in contacts) {
          //   ContactsService.addContact(element);
          // }
          break;
        case TaskState.canceled:
          break;
        case TaskState.error:
          break;
      }
    });
    //ContactsService.addContact(contact);
  }

  Contact convertContactFromMap(Map<String, dynamic> m) {
    return Contact(
      displayName: m["displayName"],
      givenName: m["givenName"],
      middleName: m["middleName"],
      familyName: m["familyName"],
      prefix: m["prefix"],
      suffix: m["suffix"],
      company: m["company"],
      jobTitle: m["jobTitle"],
      androidAccountTypeRaw: m["androidAccountType"],
      androidAccountType: accountTypeFromString(m["androidAccountType"]),
      androidAccountName: m["androidAccountName"],
      emails: (m["emails"] as List?)?.map((m) => Item.fromMap(m)).toList(),
      phones: (m["phones"] as List?)?.map((m) => Item.fromMap(m)).toList(),
      postalAddresses: (m["postalAddresses"] as List?)
          ?.map((m) => PostalAddress.fromMap(m))
          .toList(),
      avatar: List.from(m["avatar"]).isNotEmpty ? m["avatar"] : null,
      birthday: m["birthday"] != null ? DateTime.parse(m["birthday"]) : null,
    );
  }

  AndroidAccountType? accountTypeFromString(String? androidAccountType) {
    if (androidAccountType == null) {
      return null;
    }
    if (androidAccountType.startsWith("com.google")) {
      return AndroidAccountType.google;
    } else if (androidAccountType.startsWith("com.whatsapp")) {
      return AndroidAccountType.whatsapp;
    } else if (androidAccountType.startsWith("com.facebook")) {
      return AndroidAccountType.facebook;
    }

    /// Other account types are not supported on Android
    /// such as Samsung, htc etc...
    return AndroidAccountType.other;
  }
}

final contactNotifierProvider =
    StateNotifierProvider((ref) => ContactNotifier(ref));
