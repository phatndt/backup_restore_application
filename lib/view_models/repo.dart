import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

final repoProvider = Provider<Repo>((ref) => Repo());

class Repo {
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<ListResult> getContactBackUpFile() async {
    late ListResult _listResult;
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final storageRef = FirebaseStorage.instance.ref().child('$uid/contacts/');
      _listResult = await storageRef.listAll();
    } catch (e) {
      log(e.toString());
    }
    return _listResult;
  }

  Future<ListResult> getPhoneLogBackUpFile() async {
    late ListResult _listResult;
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final storageRef = FirebaseStorage.instance.ref().child('$uid/phone/');
      _listResult = await storageRef.listAll();
    } catch (e) {
      log(e.toString());
    }
    return _listResult;
  }

  Future<ListResult> getSmsLogBackUpFile() async {
    late ListResult _listResult;
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final storageRef = FirebaseStorage.instance.ref().child('$uid/sms/');
      _listResult = await storageRef.listAll();
    } catch (e) {
      log(e.toString());
    }
    return _listResult;
  }
}
