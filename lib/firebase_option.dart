import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlYcb2ezgi7Pgulnp-sKefzEZQwrZUpi0',
    appId: '1:132917430376:android:552b717146bb009ae513dd',
    messagingSenderId: '132917430376',
    projectId: 'financeapp-659fc',
    storageBucket: 'financeapp-659fc.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAlYcb2ezgi7Pgulnp-sKefzEZQwrZUpi0',
    appId: '1:132917430376:android:552b717146bb009ae513dd',
    messagingSenderId: '132917430376',
    projectId: 'financeapp-659fc',
    storageBucket: 'financeapp-659fc.firebasestorage.app',
    iosBundleId: 'com.azizafirdaus.financeapp',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAlYcb2ezgi7Pgulnp-sKefzEZQwrZUpi0',
    appId: '1:132917430376:android:552b717146bb009ae513dd',
    messagingSenderId: '132917430376',
    projectId: 'financeapp-659fc',
    authDomain: 'financeapp-659fc.firebaseapp.com',
    storageBucket: 'financeapp-659fc.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    iosBundleId: 'com.azizafirdaus.financeapp',
  );
}
