import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart'; // new
import 'package:flutter/material.dart';
import 'package:eztalk/page/user_profile_page.dart';
import 'package:eztalk/utilities/router.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              GoogleProvider(
                clientId:
                    "268678748232-tj5asg1un108sih4soebo1pv6lmncfc3.apps.googleusercontent.com",
              ),
            ],
          );
        }
        return Routes.homeRoute!(context);
        // return UserProfilePage();
      },
    );
  }
}

//   static const FirebaseOptions ios = FirebaseOptions(
//   apiKey: 'YOUR API KEY',
//   appId: 'YOUR APP ID',
//   messagingSenderId: '',
//   projectId: 'PROJECT_ID',
//   storageBucket: 'PROJECT_ID.firebasestorage.app',
//   iosClientId: 'IOS CLIENT ID', // Find your iOS client Id here.
//   iosBundleId: 'com.example.BUNDLE',
// );
