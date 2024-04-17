import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:koumi_app/main.dart';

class FirebaseApi {
  // création d'instance
  final _firebaseMessaging = FirebaseMessaging.instance;

  // fonction pour initialisation du messaging
  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();

    print('Token : $fCMToken');
  }

 
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState
        ?.pushNamed('/notificationPage', arguments: message);
  }

  Future initNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
