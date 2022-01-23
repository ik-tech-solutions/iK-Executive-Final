import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:http/http.dart' as http;

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging();

  Timer _timer;
  /* Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message,context) async {
    fetchRideInfo(getRideID(message),context);
  }*/
  Future initialize(context) async {
    if (Platform.isIOS) {
      fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    // fcm.configure(
    //   onBackgroundMessage: (Map<String, dynamic> message) async {
    //     print("backgroundNotification $message");
    //   },
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     print("Messagem");
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onRes:ume $message");
    //   },
    // );
  }

  Future<String> getToken() async {
    String token = await fcm.getToken();
    DatabaseReference tokenRef = FirebaseDatabase.instance
        .reference()
        .child('motorista/${user.uid}/perfil/device_token');
    tokenRef.set(token);

    fcm.subscribeToTopic('todosmotoristas');
    fcm.subscribeToTopic('todosusuarios');
    print(token);
    return token;
  }

  static Future<Map<String, dynamic>> sendNotification(
      String tokenDestin, String body, String title, String userId) async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            "rider": "$userId"
          },
          'to': '$tokenDestin'
        },
      ),
    );
    print('FUNCIONOU___________......');
  }

  // static sendNotificationAll(String body, String title) {
  //   FirebaseDatabase.instance
  //       .reference()
  //       .child('cliente')
  //       .once()
  //       .then((DataSnapshot snapshot) => {
  //             snapshot.value.forEach(
  //               (key, values) {
  //                 values.forEach((key, values) {
  //                   sendNotification(
  //                       values['device_token'], body, title, values['uid']);
  //                 });
  //               },
  //             )
  //           });
  // }
}
