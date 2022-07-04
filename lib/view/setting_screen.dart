import 'package:backup_restore_application/view_models/contact_view_model.dart';
import 'package:backup_restore_application/view_models/phone_view_model.dart';
import 'package:backup_restore_application/view_models/sms_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/resources.dart';
import '../constants/texts.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(T.setting),
          backgroundColor: R.colors.primaryColor,
          foregroundColor: R.colors.secondaryColor,
        ),
        body: Column(
          children: [
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (builder) {
                    return CustomAlerDiaLog(
                      title: T.backupContacts,
                      content: T.backupContactsContent,
                      onPressed: () {
                        ref
                            .watch(contactNotifierProvider.notifier)
                            .backUpInformation(context)
                            .then(
                              (value) => Navigator.pop(context),
                            );
                      },
                      context: context,
                    );
                  },
                );
              },
              leading: const Icon(Icons.contact_phone),
              title: const Text(T.backupContacts),
              tileColor: Colors.transparent,
            ),
            const Divider(),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (builder) {
                    return CustomAlerDiaLog(
                      title: T.backupCallLogs,
                      content: T.backupCallLogsContent,
                      onPressed: () {
                        ref
                            .watch(phoneNotifierProvider.notifier)
                            .backUpInformation(context)
                            .then(
                              (value) => Navigator.pop(context),
                            );
                      },
                      context: context,
                    );
                  },
                );
              },
              leading: const Icon(Icons.call),
              title: const Text(T.backupCallLogs),
              tileColor: Colors.transparent,
            ),
            const Divider(),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (builder) {
                    return CustomAlerDiaLog(
                      title: T.backupSmsLogs,
                      content: T.backupSmsLogsContent,
                      onPressed: () {
                        ref
                            .watch(smsLogNotifierProvider.notifier)
                            .backUpInformation(context)
                            .then(
                              (value) => Navigator.pop(context),
                            );
                      },
                      context: context,
                    );
                  },
                );
              },
              leading: const Icon(Icons.sms),
              title: const Text(T.backupSmsLogs),
              tileColor: Colors.transparent,
            ),
            const Divider(),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.shield),
              title: const Text(T.requestPermission),
              tileColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAlerDiaLog extends StatelessWidget {
  const CustomAlerDiaLog({
    Key? key,
    required this.title,
    required this.content,
    required this.onPressed,
    required this.context,
  }) : super(key: key);
  final String title;
  final String content;
  final VoidCallback onPressed;
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(this.context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text('OK'),
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }
}
