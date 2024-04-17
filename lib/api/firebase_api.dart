import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class FirebaseApi {
  // création d'instance
  final _firebaseMessaging = FirebaseMessaging.instance;
  var fCMToken;
  // fonction pour initialisation du messaging
  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);


    fCMToken = await _firebaseMessaging.getToken();

    print('Token : $fCMToken');
    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // navigatorKey.currentState
    //     ?.pushNamed('/notificationPage', arguments: message);
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  // Méthode pour envoyer une notification push
  // Future<void> sendPushNotification() async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization':
  //             fCMToken,
  //       },
  //       body: jsonEncode(<String, dynamic>{
  //         'notification': <String, dynamic>{
  //           'title': 'Nouveau message',
  //           'body': 'body',
  //         },
  //         'priority': 'high',
  //         // 'data': data,
  //         'to': fCMToken,
  //       }),
  //     );

  //     print('Réponse FCM : ${response.body}');
  //      print('Token FCM : ${fCMToken}');
  //   } catch (e) {
  //     print('Erreur lors de l\'envoi de la notification : $e');
  //   }
  // }
  // Future<void> sendNotification(String message) async {
  //   // Construire le message de notification
  //   var notification = {
  //     'notification': {
  //       'title': 'Nouveau message',
  //       'body': message,
  //     },
  //     'priority': 'high',
  //     'data': {
  //       'click_action':
  //           'FLUTTER_NOTIFICATION_CLICK', // Action à effectuer lorsque l'utilisateur clique sur la notification
  //        // ID unique pour la notification
  //       'status': 'done',
  //     },
  //     'to': await _firebaseMessaging.getToken(), // Envoyer à tous les appareils
  //   };

  //   // Envoyer la notification via Firebase Cloud Messaging
  //   await _firebaseMessaging.sendMessage();
  // }
}
