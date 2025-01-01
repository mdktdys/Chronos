importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts(
  "https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js"
);

const firebaseApp = firebase.initializeApp({
  apiKey: "AIzaSyATPTeDPIpSg9KA1kpOs1rt60eKXZuSBXo",
  authDomain: "chronos-29a6e.firebaseapp.com",
  projectId: "chronos-29a6e",
  storageBucket: "chronos-29a6e.appspot.com",
  messagingSenderId: "504912878580",
  appId: "1:504912878580:web:0bcb045c42293824af77a1",
  measurementId: "G-FCND0JX3N6",
});

const messagingApp = firebaseApp.messaging();

messagingApp.onBackgroundMessage((payload) => {
  // Customize notification here
  console.log("onBackgroundMeasdssage", payload.data);
  const notificationTitle = payload.data?.title ?? "Замены уксивтика";
  const notificationOptions = {
    badge: "https://uksivt.xyz/icons/Icon-192.png",
    body: payload.data?.body,
    image: payload.data?.image,
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});

self.addEventListener("notificationclick", (event) => {
  event.notification.close();

  // This looks to see if the current is already open and
  // focuses if it is
  event.waitUntil(
    self.clients.matchAll().then((clientList) => {
      if (clientList.length > 0) {
        return clientList[0].focus();
      }

      return self.clients.openWindow("/");
    })
  );
});
