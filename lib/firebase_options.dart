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
    apiKey: 'AIzaSyBO_PuuZJ7qk45dO0icFKbn2NOXneGK4Gg',
    appId: '1:637210267986:web:b7f0e66d00285fca94aa8b',
    messagingSenderId: '637210267986',
    projectId: 'flexpoint-85d76',
    authDomain: 'flexpoint-85d76.firebaseapp.com',
    storageBucket: 'flexpoint-85d76.firebasestorage.app',
    measurementId: 'G-WKDYS603VV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCmh2noGFyXvruXqXMKqaibwb9X7rOkU6E',
    appId: '1:637210267986:android:d7f203c599398b4394aa8b',
    messagingSenderId: '637210267986',
    projectId: 'flexpoint-85d76',
    storageBucket: 'flexpoint-85d76.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCKFIrf-aqUGF1HihfiGykJLwVpFwHmB0o',
    appId: '1:637210267986:ios:fca556d06fadcb6b94aa8b',
    messagingSenderId: '637210267986',
    projectId: 'flexpoint-85d76',
    storageBucket: 'flexpoint-85d76.firebasestorage.app',
    iosBundleId: 'com.example.finalyearprojectFlutterApplication1',
  );
}
