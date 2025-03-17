importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyDQHXMfFWktheUcZ4hzS5TGnkTMkv8_pLk",
  authDomain: "chronos-29a6e.firebaseapp.com",
  databaseURL: "...",
  projectId: "chronos-29a6e",
  storageBucket: "chronos-29a6e.firebasestorage.app",
  messagingSenderId: "504912878580",
  appId: "1:504912878580:web:ab27abbe4d01a9c4af77a1",
  measurementId: "G-KVKSH8BE55"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((message) => {
  const notificationTitle = message.data?.title ?? "Замены уксивтика";
  const notificationOptions = {
    badge: "https://uksivt.xyz/icons/Icon-192.png",
    body: message.data?.body,
    image: message.data?.image,
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});