import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/services.dart';

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
    apiKey: 'AIzaSyA10hJncT0QfLfoCAXS8PFFQf7hRag7Ogw',
    appId: '1:972650655088:web:ee8665d3478d2f86f133b5',
    messagingSenderId: '972650655088',
    projectId: 'thesocial-62d49',
    authDomain: 'thesocial-62d49.firebaseapp.com',
    storageBucket: 'thesocial-62d49.appspot.com',
    measurementId: 'G-D3YW8RC43P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCy-TsNY1Wj27YrUGYxxTU8dkWFiCepWxc',
    appId: '1:972650655088:android:1d9a5dd8ad5f2317f133b5',
    messagingSenderId: '972650655088',
    projectId: 'thesocial-62d49',
    storageBucket: 'thesocial-62d49.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOia3oT-iQQj1TdfuJC8Qsy-jNFUDs63g',
    appId: '1:972650655088:ios:d8cc6c1290bec2e7f133b5',
    messagingSenderId: '972650655088',
    projectId: 'thesocial-62d49',
    storageBucket: 'thesocial-62d49.appspot.com',
    iosBundleId: 'com.example.smesterproject',
  );
}


