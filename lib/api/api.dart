

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/chat_models.dart';
import '../models/message_model.dart';


class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;


  static User get user => auth.currentUser!;

  static ChatUser me = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),

      createdAt: '',
      isOnline: false,
      lastActive: '',
      pushToken: '');

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        id: user.uid,
        name: user.email.toString(),
        email: user.email.toString(),

        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore.collection("users").where('id',isNotEqualTo:user.uid).snapshots();
  }

  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);

        log('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }


  static getConversationID(String id)=>user.uid.hashCode <= id.hashCode? '${user.uid}_$id':
      '${id}_${user.uid}';


  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
   ChatUser user ) {
  return firestore
      .collection('chats/${getConversationID(user.id)}/messages/').snapshots();
}


//send message
static Future<void> sendMessage(ChatUser chatUser,String msg)async{
    final time = DateTime.now().microsecondsSinceEpoch.toString();

  final Message message = Message(toId: chatUser.id, msg: msg, read: "read", type: Type.text, fromId: user.uid, sent: time);

  final ref = firestore.collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser,msg ));
}


static  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

static Future<void> getFirebaseMessagingToken()async{
  await firebaseMessaging.requestPermission( );
  await firebaseMessaging.getToken().then((t) {
     if(t !=null){
       me.pushToken = t;
       log("push Token ${t}");
       updateFCMToken();
     }
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');

    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification}');
    }
  });
}

static Future<void>updateFCMToken()async{
  firestore.collection("users").doc(user.uid).update({
    'push_token':me.pushToken,
  });
}

  // for sending push notification
  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": me.email, //our name should be send
          "body": msg,
          "android_channel_id": "chats"
        },
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };

      var res = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
            'key=AAAAqqr3QNY:APA91bGsBRrLG9ptAB84pllTHJLzNBKdwUNtoeSsAxVRBKdfFVTELjch7eP17xSgLVa3Ol_L0C4KvQXsYZdITrJ98gNn9Rty1EREfgvL4LBUkLPY_5Iy9I4StAkj4k-sqf5G9_MY3y1K'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }


}

