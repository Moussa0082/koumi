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
    apiKey: 'AIzaSyDUtxX6Z0V5HNdVYTX1EY6X6W3Wyf-nrpE',
    appId: '1:592355641252:web:44853b91afbef10acb6331',
    messagingSenderId: '592355641252',
    projectId: 'koumipushnotification',
    authDomain: 'koumipushnotification.firebaseapp.com',
    storageBucket: 'koumipushnotification.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCxlWK2u_Wzp02c8ERX5R9d-GWZoLk10Qc',
    appId: '1:592355641252:android:be7dd4f25de5f727cb6331',
    messagingSenderId: '592355641252',
    projectId: 'koumipushnotification',
    storageBucket: 'koumipushnotification.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXNAZ_npfLRrcZSVPAsGEsXjBeo0MuqLw',
    appId: '1:592355641252:ios:ad59ec3b9a77ab83cb6331',
    messagingSenderId: '592355641252',
    projectId: 'koumipushnotification',
    storageBucket: 'koumipushnotification.appspot.com',
    iosBundleId: 'com.example.koumiApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAXNAZ_npfLRrcZSVPAsGEsXjBeo0MuqLw',
    appId: '1:592355641252:ios:ad59ec3b9a77ab83cb6331',
    messagingSenderId: '592355641252',
    projectId: 'koumipushnotification',
    storageBucket: 'koumipushnotification.appspot.com',
    iosBundleId: 'com.example.koumiApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDUtxX6Z0V5HNdVYTX1EY6X6W3Wyf-nrpE',
    appId: '1:592355641252:web:05123012c74a51ebcb6331',
    messagingSenderId: '592355641252',
    projectId: 'koumipushnotification',
    authDomain: 'koumipushnotification.firebaseapp.com',
    storageBucket: 'koumipushnotification.appspot.com',
  );
}