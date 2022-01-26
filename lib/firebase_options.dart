// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUhJX67i-Fx8JmR81bOAfOR6aYXVvWMwM',
    appId: '1:819715101224:android:6bada21960810da8f29b1d',
    messagingSenderId: '819715101224',
    projectId: 'mind-13700',
    storageBucket: 'mind-13700.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAj_EIg4BOBSDoqjP1m6BYZzLb4IlMPpSk',
    appId: '1:819715101224:ios:6effbcae4a47e7b5f29b1d',
    messagingSenderId: '819715101224',
    projectId: 'mind-13700',
    storageBucket: 'mind-13700.appspot.com',
    iosClientId: '819715101224-05b8hduadc5cr5moanmvonpp59splu1e.apps.googleusercontent.com',
    iosBundleId: 'com.royalapps.mind',
  );
}