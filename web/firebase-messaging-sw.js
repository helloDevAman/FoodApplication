importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyCeaw_gVN0iQwFHyuF8pQ6PbVDmSVQw8AY",
  authDomain: "stackfood-bd3ee.firebaseapp.com",
  projectId: "stackfood-bd3ee",
  storageBucket: "stackfood-bd3ee.appspot.com",
  messagingSenderId: "1049699819506",
  appId: "1:1049699819506:web:a4b5e3bedc729aab89956b",
  databaseURL: "...",
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});