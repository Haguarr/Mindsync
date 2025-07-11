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
    apiKey: 'AIzaSyBZTAtnircirgTL1xEQ11sVtIIIgdA3TMQ',
    appId: '1:618942015131:web:4a7c2aa6b9194769a3083e',
    messagingSenderId: '618942015131',
    projectId: 'mindsync-9ba05',
    authDomain: 'mindsync-9ba05.firebaseapp.com',
    storageBucket: 'mindsync-9ba05.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8TZFNH2nzPTrn_iuWlNn0blzBlJo1slA',
    appId: '1:618942015131:android:e8e57da3104c99c8a3083e',
    messagingSenderId: '618942015131',
    projectId: 'mindsync-9ba05',
    storageBucket: 'mindsync-9ba05.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBkKYhOY3373mMcJMmAprpGySCok1WQDVM',
    appId: '1:618942015131:ios:8bf2c03128167284a3083e',
    messagingSenderId: '618942015131',
    projectId: 'mindsync-9ba05',
    storageBucket: 'mindsync-9ba05.firebasestorage.app',
    iosClientId: '618942015131-jmuocofra00227cki3b6cbhsf2f3aid6.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBkKYhOY3373mMcJMmAprpGySCok1WQDVM',
    appId: '1:618942015131:ios:8bf2c03128167284a3083e',
    messagingSenderId: '618942015131',
    projectId: 'mindsync-9ba05',
    storageBucket: 'mindsync-9ba05.firebasestorage.app',
    iosClientId: '618942015131-jmuocofra00227cki3b6cbhsf2f3aid6.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBZTAtnircirgTL1xEQ11sVtIIIgdA3TMQ',
    appId: '1:618942015131:web:d3262b474ad42110a3083e',
    messagingSenderId: '618942015131',
    projectId: 'mindsync-9ba05',
    authDomain: 'mindsync-9ba05.firebaseapp.com',
    storageBucket: 'mindsync-9ba05.firebasestorage.app',
  );
}
