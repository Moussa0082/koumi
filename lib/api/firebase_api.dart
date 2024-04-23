import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirebaseApi {
  // final navigatorKey = GlobalKey<NavigatorState>();
  // création d'instance
  final _firebaseMessaging = FirebaseMessaging.instance;
  var fCMToken;

  var server_key =
      "AAAAieslx6Q:APA91bHKA1r4-y4v6dKNWoW_rAFmvcomw2hhLb37fDu5Q6RiSCZwjMz-2zM_dCN2dTspPIn4hWQLj3lQy8OGPuXRE_tImrBdxjtfbQTPQ-_B6Mzt-celXB6gCN9WLaibLPYZTQ4K7f8I";
  // fonction pour initialisation du messaging
  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    fCMToken = await _firebaseMessaging.getToken();

    print('Token : $fCMToken');
    await subscribeToTopic('sendPush');
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


Future<void> subscribeToTopic(String topic) async {
  await FirebaseMessaging.instance.subscribeToTopic(topic);
  print('Successfully subscribed to topic: $topic');
}

Future<void> sendPushNotificationToTopic(String title, String body) async {
    String topic = "sendPush";
    try {
      var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      var header = {
        "Content-Type": "application/json",
        "Authorization": "key=$server_key"
      };
      var request = {
        "to": "/topics/$topic",
        "notification": {"title": title, "body": body}
      };

      var client = http.Client();
      var response =
          await client.post(url, headers: header, body: jsonEncode(request));
      print(response.body);
    } catch (e) {
      print(e);
    }
  }


  // Future<void> sendPushNotificationToTopic() async {
  //   String topic = "sendPush";
  //   try {
  //     var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  //     var header = {
  //       "Content-Type": "application/json",
  //       "Authorization": "key=$server_key"
  //     };
  //     var request = {
  //       "to": "/topics/$topic",
  //       // "notification": {"title": title, "body": body}
  //     };

  //     var client = http.Client();
  //     var response =
  //         await client.post(url, headers: header, body: jsonEncode(request));
  //     print(response.body);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
