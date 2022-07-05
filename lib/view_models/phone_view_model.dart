import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:backup_restore_application/view_models/backup_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:call_log/call_log.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PhoneLogNotifier extends StateNotifier implements BackupInterface {
  PhoneLogNotifier(this.ref) : super(ref);
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
    final file = File('$path/json.txt');
    file.writeAsString(json);
    pushInformationToFirestore(file);
  }

  @override
  getInformationFromDevice() async {
    // get all call logs
    Iterable<CallLogEntry> entries = await CallLog.get();
    //Convert phone log list to json
    String json =
        jsonEncode(entries.map((e) => convertCallLogEntryToMap(e)).toList());
    convertInformationToFile(json);
  }

  @override
  getPermission() async {
    var status = await Permission.phone.status;
    if (status.isDenied) {
      final permissionStatus = await Permission.phone.request();
      return permissionStatus;
    } else {
      return status;
    }
  }

  @override
  pushInformationToFirestore(File file) async {
    String name = DateTime.now().toString();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final storageRef = FirebaseStorage.instance.ref().child('$uid/phone/$name');
    try {
      await storageRef.putFile(file);
    } on FirebaseException catch (e) {
      log(e.code + e.toString());
    }
  }

  @override
  showPermission(PermissionStatus permissionStatus, BuildContext context) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar =
          SnackBar(content: Text('Access to phone log data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
          SnackBar(content: Text('Phone log data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  convertCallLogEntryToMap(CallLogEntry callLogEntry) {
    return {
      'name': callLogEntry.name,
      'number': callLogEntry.number,
      'formattedNumber': callLogEntry.formattedNumber,
      'callType': callLogEntry.callType.toString(),
      'duration': callLogEntry.duration,
      'timestamp': callLogEntry.timestamp,
      'cachedNumberType': callLogEntry.cachedNumberType,
      'cachedNumberLabel': callLogEntry.cachedNumberLabel,
      'cachedMatchedNumber': callLogEntry.cachedMatchedNumber,
      'simDisplayName': callLogEntry.simDisplayName,
      'phoneAccountId': callLogEntry.phoneAccountId,
    };
  }

  @override
  restoreInformation() {
    // TODO: implement restoreInformation
    throw UnimplementedError();
  }
}

final phoneNotifierProvider =
    StateNotifierProvider((ref) => PhoneLogNotifier(ref));
