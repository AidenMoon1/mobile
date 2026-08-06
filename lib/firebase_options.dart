// =============================================================================
// FILE: lib/firebase_options.dart
// FUNGSI: Konfigurasi Kredensial Multi-Platform Firebase Cloud Firestore
// DIBANGUN DENGAN: FlutterFire CLI untuk Sukabumi One Access (Project: sukabumi-one-access-app-c7f15)
// LEVEL KODE: Level 2-3 (Sangat Rapi & Mudah Dipahami Mahasiswa)
// =============================================================================

// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Kelas Konfigurasi Kredensial Firebase Multi-Platform (Android, iOS, & Web)
class DefaultFirebaseOptions {
  // FUNGSI: Resolver Otomatis Opsi Firebase Sesuai Platform HP / Browser Web
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

  // KREDENSIAL PLATFORM BROWSER WEB
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAhiff2ve4UnqeUfG73CmP6V47lQHWloSA',
    appId: '1:709678945324:web:3352d09fb627cd0ab7ed89',
    messagingSenderId: '709678945324',
    projectId: 'sukabumi-one-access-app-c7f15',
    authDomain: 'sukabumi-one-access-app-c7f15.firebaseapp.com',
    storageBucket: 'sukabumi-one-access-app-c7f15.firebasestorage.app',
    measurementId: 'G-9BH8RDCLRX',
  );

  // KREDENSIAL PLATFORM ANDROID (Package: com.diskominfo.mobile)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1n-_fvGdfTJYLvCOp438rlEAfCVuloyU',
    appId: '1:709678945324:android:83857869c836e35db7ed89',
    messagingSenderId: '709678945324',
    projectId: 'sukabumi-one-access-app-c7f15',
    storageBucket: 'sukabumi-one-access-app-c7f15.firebasestorage.app',
  );

  // KREDENSIAL PLATFORM APPLE IOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADA0dl4WKlbcDueTN9ktnHV5ZjG1VvZoI',
    appId: '1:709678945324:ios:641afd317a3c4c38b7ed89',
    messagingSenderId: '709678945324',
    projectId: 'sukabumi-one-access-app-c7f15',
    storageBucket: 'sukabumi-one-access-app-c7f15.firebasestorage.app',
    iosBundleId: 'com.diskominfo.mobile',
  );
}
