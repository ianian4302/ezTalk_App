import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('User Profile'),
        ),
        body: Center(
          child: Text('No user is currently signed in.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('UID: ${user.uid}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Email: ${user.email}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Display Name: ${user.displayName}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Phone Number: ${user.phoneNumber}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Photo URL: ${user.photoURL}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
