import 'package:backup_restore_application/view/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/resources.dart';
import '../constants/texts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: R.colors.backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            LottieBuilder.network(
              'https://assets6.lottiefiles.com/packages/lf20_1pxqjqps.json',
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final user = await signInWithGoogle();
                    if (user.user != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => const MainScreen()));
                    }
                  } catch (e) {
                    print(e.toString());
                  }
                },
                style: ElevatedButton.styleFrom(primary: R.colors.primaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'http://pngimg.com/uploads/google/google_PNG19635.png',
                      scale: MediaQuery.of(context).size.width / 16,
                    ),
                    Text(
                      T.buttonText,
                      style: R.textStyles.loginStype,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
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
}
