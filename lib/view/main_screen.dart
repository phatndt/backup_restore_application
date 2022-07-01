import 'package:backup_restore_application/view_models/main_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../constants/resources.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          centerTitle: true,
          title: const Text('Backup history'),
          backgroundColor: R.colors.primaryColor,
          foregroundColor: R.colors.secondaryColor,
        ),
        body: Column(
          children: [],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            ref.watch(mainNotifierProvider.notifier).getContact(context);
            // Get all contacts on device
            //List<Contact> contacts = await ContactsService.getContacts();
          },
          foregroundColor: R.colors.secondaryColor,
          backgroundColor: R.colors.primaryColor,
          child: const Icon(Icons.settings),
        ),
      ),
    );
  }
}
