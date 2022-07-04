import 'package:backup_restore_application/view/main_screen.dart';
import 'package:backup_restore_application/view_models/repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginNotifier extends StateNotifier {
  LoginNotifier(this.ref) : super(ref) {
    _repo = ref.watch(repoProvider);
  }
  final Ref ref;
  late Repo _repo;

  signInWithGoogle(BuildContext context) {
    _repo.signInWithGoogle().then(
      (userCredential) {
        if (userCredential != null && userCredential.user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => const MainScreen(),
            ),
          );
        }
      },
    );
  }
}

final loginNotifierProvider =
    StateNotifierProvider((ref) => LoginNotifier(ref));


// Future<UserCredential> signInWithGoogle() async {
//   // Trigger the authentication flow
//   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//   // Obtain the auth details from the request
//   final GoogleSignInAuthentication? googleAuth =
//       await googleUser?.authentication;

//   // Create a new credential
//   final credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth?.accessToken,
//     idToken: googleAuth?.idToken,
//   );

//   // Once signed in, return the UserCredential
//   return await FirebaseAuth.instance.signInWithCredential(credential);
// }