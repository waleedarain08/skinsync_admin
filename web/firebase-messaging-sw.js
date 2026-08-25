// See this file for the latest firebase-js-sdk version:
// https://github.com/firebase/flutterfire/blob/main/packages/firebase_core/firebase_core_web/lib/src/firebase_sdk_version.dart
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
 apiKey: 'AIzaSyBEhsYAXbuXh0feNcZPOUSfBHWC2uVW3U4',
    appId: '1:55541632083:web:4eda17b719be759190caa6',
    messagingSenderId: '55541632083',
    projectId: 'skinsync-2aa8e',
    authDomain: 'skinsync-2aa8e.firebaseapp.com',
    storageBucket: 'skinsync-2aa8e.firebasestorage.app',
    measurementId: 'G-W87QHZ5YQB',
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});