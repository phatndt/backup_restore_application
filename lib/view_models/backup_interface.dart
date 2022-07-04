import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class BackupInterface {
  backUpInformation(BuildContext context);
  getInformationFromDevice();
  convertInformationToFile(String json);
  pushInformationToFirestore(File file);
  getPermission();
  showPermission(PermissionStatus permissionStatus, BuildContext context);
}
