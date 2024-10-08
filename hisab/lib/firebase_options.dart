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
    apiKey: 'AIzaSyB7H1HMAdZudhnSoGj3U5L2sSQoWAU6QWo',
    appId: '1:35197378133:web:e68841ef4063670241bedc',
    messagingSenderId: '35197378133',
    projectId: 'hisab-b34fb',
    authDomain: 'hisab-b34fb.firebaseapp.com',
    storageBucket: 'hisab-b34fb.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyASX8E7QftmASXonz9L52U3ubeJxdphAjE',
    appId: '1:35197378133:android:17da2346729c36b441bedc',
    messagingSenderId: '35197378133',
    projectId: 'hisab-b34fb',
    storageBucket: 'hisab-b34fb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBiCPfk_WGfQbf38Vx_hVxOHNhJ7av98jw',
    appId: '1:35197378133:ios:81d54fe1cd218cc141bedc',
    messagingSenderId: '35197378133',
    projectId: 'hisab-b34fb',
    storageBucket: 'hisab-b34fb.appspot.com',
    iosBundleId: 'com.example.hisab',
  );
}
