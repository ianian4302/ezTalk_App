// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAn-QMEdnM0K6B778FFFcnqzWbeoUu3zEI',
    appId: '1:268678748232:web:1ed4d641b5f79c4223a07d',
    messagingSenderId: '268678748232',
    projectId: 'eztalk-app',
    authDomain: 'eztalk-app.firebaseapp.com',
    storageBucket: 'eztalk-app.firebasestorage.app',
    measurementId: 'G-GVCHT0C5TL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzSxDbmVXn5g4o5hD09ChrpSPC9gsnHQc',
    appId: '1:268678748232:android:39ea00b590f1eb6c23a07d',
    messagingSenderId: '268678748232',
    projectId: 'eztalk-app',
    storageBucket: 'eztalk-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDft-ueRQUOawDC4HTGCGBT2knJmRg9hXQ',
    appId: '1:268678748232:ios:1fc2d4f7c4f2d2ca23a07d',
    messagingSenderId: '268678748232',
    projectId: 'eztalk-app',
    storageBucket: 'eztalk-app.firebasestorage.app',
    iosClientId:
        '268678748232-jqav4tubga2hnmju3okoh9snt257hmoq.apps.googleusercontent.com',
    iosBundleId: 'com.example.eztalk',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDft-ueRQUOawDC4HTGCGBT2knJmRg9hXQ',
    appId: '1:268678748232:ios:1fc2d4f7c4f2d2ca23a07d',
    messagingSenderId: '268678748232',
    projectId: 'eztalk-app',
    storageBucket: 'eztalk-app.firebasestorage.app',
    iosClientId:
        '268678748232-jqav4tubga2hnmju3okoh9snt257hmoq.apps.googleusercontent.com',
    iosBundleId: 'com.example.eztalk',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAn-QMEdnM0K6B778FFFcnqzWbeoUu3zEI',
    appId: '1:268678748232:web:dec455d9ee09d55b23a07d',
    messagingSenderId: '268678748232',
    projectId: 'eztalk-app',
    authDomain: 'eztalk-app.firebaseapp.com',
    storageBucket: 'eztalk-app.firebasestorage.app',
    measurementId: 'G-EE1K9BP55P',
  );
}
