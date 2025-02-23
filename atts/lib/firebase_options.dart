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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCgl5l3knuPg_trZzs4LGzGJAbIzln1Xgg',
    appId: '1:1095961130552:android:e37aa9022b08019dba18cd',
    messagingSenderId: '1095961130552',
    projectId: 'backend-atts',
    storageBucket: 'backend-atts.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBwygJNxMcWAMZCViAUUAvvfu2W6ZLkS74',
    appId: '1:1095961130552:ios:666b93f7d84fb9d7ba18cd',
    messagingSenderId: '1095961130552',
    projectId: 'backend-atts',
    storageBucket: 'backend-atts.firebasestorage.app',
    iosBundleId: 'com.example.atts',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBWcFqYAodmdyF3lQodZbg39-S6CluzW9k',
    appId: '1:1095961130552:web:91c238e34dc021d1ba18cd',
    messagingSenderId: '1095961130552',
    projectId: 'backend-atts',
    authDomain: 'backend-atts.firebaseapp.com',
    storageBucket: 'backend-atts.firebasestorage.app',
    measurementId: 'G-FCYDFFYPQT',
  );
}
