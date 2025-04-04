// File generated by FlutterFire CLI.
// ignore_for_file: type=lint

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDQHXMfFWktheUcZ4hzS5TGnkTMkv8_pLk',
    appId: '1:504912878580:web:ab27abbe4d01a9c4af77a1',
    messagingSenderId: '504912878580',
    projectId: 'chronos-29a6e',
    authDomain: 'chronos-29a6e.firebaseapp.com',
    storageBucket: 'chronos-29a6e.firebasestorage.app',
    measurementId: 'G-KVKSH8BE55',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgQCnc6OTrPQ8SH3ghndJ3C0zl-bBys5E',
    appId: '1:504912878580:android:d3cc7a3651272d05af77a1',
    messagingSenderId: '504912878580',
    projectId: 'chronos-29a6e',
    storageBucket: 'chronos-29a6e.appspot.com',
  );
}
