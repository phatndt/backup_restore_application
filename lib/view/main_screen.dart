import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/resources.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              FirebaseAuth.instance.signOut();
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
          onPressed: () {},
          foregroundColor: R.colors.secondaryColor,
          backgroundColor: R.colors.primaryColor,
          child: const Icon(Icons.backup),
        ),
      ),
    );
  }
}
