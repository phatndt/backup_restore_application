import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:backup_restore_application/view_models/backup_interface.dart';
import 'package:backup_restore_application/view_models/main_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sms_advanced/sms_advanced.dart';

class SmsLogNotifier extends StateNotifier implements BackupInterface {
  SmsLogNotifier(this.ref) : super(ref);
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
    SmsQuery query = SmsQuery();
    List<SmsMessage>? messages = await query.getAllSms;
    String json = jsonEncode(messages.map((e) => e.toMap).toList());
    convertInformationToFile(json);
  }

  @override
  getPermission() async {
    var status = await Permission.sms.status;
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
    final storageRef = FirebaseStorage.instance.ref().child('$uid/sms/$name');
    try {
      await storageRef.putFile(file);
    } on FirebaseException catch (e) {
      log(e.code + e.toString());
    }
  }

  @override
  showPermission(PermissionStatus permissionStatus, BuildContext context) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to sms log data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
          SnackBar(content: Text('Sms log data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  restoreInformation(String pathFile, BuildContext context) async {
    final islandRef = FirebaseStorage.instance.ref().child(pathFile);
    final appDocDir = await getApplicationDocumentsDirectory();
    final path = appDocDir.path;
    final filePath = "$path/sms.json";
    final file = File(filePath);
    final downloadTask = islandRef.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          final parse = await file.readAsString();
          log(parse);
          // List<CallLogEntry> callLogs = parse.map<CallLogEntry>((e) {
          //   CallLogEntry callLogEntry = convertCallLogFromMap(e);
          // }).toList();
          const platform =
              MethodChannel('com.backup_restore_application/phoneLogs');
          try {
            final int result =
                await platform.invokeMethod('insertSmsLogs', parse);
          } on PlatformException catch (e) {
            log(e.toString());
          }
          break;
        case TaskState.canceled:
          break;
        case TaskState.error:
          break;
      }
    });
  }
}

final smsLogNotifierProvider =
    StateNotifierProvider((ref) => SmsLogNotifier(ref));
