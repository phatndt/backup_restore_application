import 'package:flutter/material.dart';

import '../constants/resources.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
