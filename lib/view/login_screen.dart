import 'package:backup_restore_application/view_models/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../constants/resources.dart';
import '../constants/texts.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: R.colors.backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                height: 400.h,
                child: LottieBuilder.asset('assets/welcome.json')),
            // LottieBuilder.network(
            //   'https://assets6.lottiefiles.com/packages/lf20_1pxqjqps.json',
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ElevatedButton(
                onPressed: () async {
                  ref
                      .watch(loginNotifierProvider.notifier)
                      .signInWithGoogle(context);
                },
                style: ElevatedButton.styleFrom(primary: R.colors.primaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/google.png',
                      width: 48.h,
                      height: 48.h,
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
