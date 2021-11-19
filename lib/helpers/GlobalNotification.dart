import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nava_tech/helpers/providers/FcmTokenProvider.dart';
import 'package:nava_tech/layouts/auth/splash/Splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/LoadingDialog.dart';
import 'package:provider/provider.dart';


class GlobalNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  int _id = 0;
  bool show = true;
  static GlobalKey<NavigatorState> navigatorKey;
  static GlobalNotification instance = new GlobalNotification._();
  GlobalNotification._();
  GlobalNotification();
  Future flutterNotificationClick(payload) async {
    print("ttttttttttpayload $payload");
    var obj = payload;
    if (payload is String) {
      obj = json.decode(payload);
    }
    var _data;
    if (Platform.isIOS) {
      _data = obj["notification"];
    } else {
      _data = obj["data"];
    }
    // int _type = int.parse(_data["type"]);
    // if (_type != null) {
    //   onSelectCategory(int.parse(_data["category"]), int.parse(_data["orderId"]));
    //   // Navigator.of(navigatorKey.currentContext).push(MaterialPageRoute(builder: (c)=>OrderDetails(orderId: _data["orderId"],)));
    // }
  }

  setupNotification(GlobalKey<NavigatorState> navKey) async{
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    _firebaseMessaging.getToken().then((token) {
      FcmTokenProvider fcnTokenProvider = Provider.of<FcmTokenProvider>(navKey.currentContext,listen: false);
      fcnTokenProvider.fcmToken=token;
      print("------------");
      print(fcnTokenProvider.fcmToken);
      print("------------");

      // preferences.setString("fcmToken", token);
      // print("------------------fcm token-----------------");
      // print(preferences.getString("fcmToken"));
      // print("------------------fcm token-----------------");
      // preferences.setString("fcmToken", token);
      // preferences.setString("fcmToken", preferences.getString("fcmToken"));


    });
    navigatorKey = navKey;
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings("@mipmap/launcher_icon");
    var ios = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android: android, iOS: ios);
    _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: flutterNotificationClick,
    );

    Future blockedLogout() async {
      LoadingDialog.showLoadingDialog();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.remove("userId");
      preferences.remove("token");
      preferences.remove("fcmToken");
      navigatorKey.currentState.pushAndRemoveUntil(MaterialPageRoute(builder: (c) => Splash()), (route) => false);
      EasyLoading.dismiss();
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // RemoteNotification notification = message.notification;
      // AndroidNotification android = message.notification?.android;
      _showLocalNotification(message.data, _id);
      print(message.data);
      print(message.data);

      if(message.data["key"]=="newMessage"){
        print("------------ newMessage newMessage newMessage");
      }else{
        // navigatorKey.currentState.setState(() {
        //   notificationCountConst++;
        // });
        navigatorKey.currentState.setState(() {});
        print("-------------- test 01");
        print("------------ ${message.data}");
      }





      if(message.data["type"]=="delete"){
        print("------------ delete delete delete delete ${message.data["type"]}");
        blockedLogout();
      }else{
        // navigatorKey.currentState.setState(() {
        //   notificationCountConst++;
        // });
        // navigatorKey.currentState.setState(() {});
        // navigatorKey.currentState.setState(() {});
        print("-------------- test 01");
        print("------------ ${message.data}");
      }

    });

    // print("------------------name-----------------");
    // _firebaseMessaging.getToken().then((token) {
    //   print(token);
    // });
  }

  _showLocalNotification(message, id) async {
    var _notify = message;
    if (Platform.isAndroid) {
      _notify = message;
    }
    print(message);
    var android = AndroidNotificationDetails(
      "${DateTime.now()}",
      "${_notify["title"]}",
      "${_notify["body"]}",
      priority: Priority.high,
      importance: Importance.max,
      playSound: true,
      shortcutId: "$_id",
      // sound:AndroidNotificationSound,
      // "assets/sounds/notifun.mp3",
    );
    var ios = IOSNotificationDetails();
    var _platform = NotificationDetails(android: android, iOS: ios);
    _flutterLocalNotificationsPlugin.show(
      id,
      "${_notify["title"]}",
      // "${tr("ewsaly")} : ",
      "${_notify["body"]}",
      // "${tr("ewsaly")} : ",
      _platform,
      payload: json.encode(message),
    );
  }









// setupNotification({BuildContext context}) async{
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   _context = context;
//   _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//   var android = new AndroidInitializationSettings("@mipmap/launcher_icon");
//   var ios = new IOSInitializationSettings();
//   var initSettings = new InitializationSettings(android: android, iOS: ios);
//   _flutterLocalNotificationsPlugin.initialize(
//     initSettings,
//     onSelectNotification: FLUTTER_NOTIFICATION_CLICK,
//   );
//   _firebaseMessaging.configure(
//     onMessage: (Map<String, dynamic> message) {
//       _id++;
//       print("_____________________$message");
//       _showLocalNotification(message, _id);
//       // _onMessageStreamController.add(message);
//       String _key = Platform.isIOS ? "notification" : "data";
//       if (int.parse(message[_key]["type"]) == -1) {
//         Utils.clearSavedData();
//         ExtendedNavigator.of(context).push(Routes.login);
//       }
//       return;
//     },
//     onResume: (Map<String, dynamic> message) {
//       print("resssssssssssssssssume $message");
//       // onSelectNotification(message);
//       return;
//     },
//     onLaunch: (Map<String, dynamic> message) {
//       print("lunchiiiiiiiiiiiing $message");
//       // onSelectNotification(message);
//       return;
//     },
//   );
//   _firebaseMessaging.getToken().then((token) {
//     preferences.setString("fcmToken", token);
//     print("mooooooooooooo--------------------");
//     print(token);
//   });
// }

// StreamController<Map<String, dynamic>> get notificationSubject {
//   return _onMessageStreamController;
// }

// _showLocalNotification(message, id) async {
//   // var provider= navigatorKey.currentContext.read<NotifyProvider>();
//   // provider.setNotifyCount(provider.count+1);
//   print(message.toString());
//   print(message);
//   print(message.toString());
//   print(message);
//   var _notify = message.data;
//   if (Platform.isAndroid) {
//     _notify = message["body"];
//   }
//   var android = AndroidNotificationDetails(
//     "${DateTime.now()}",
//     "${_notify[0]}",
//     "${_notify[0]}",
//     priority: Priority.high,
//     importance: Importance.max,
//     playSound: true,
//     shortcutId: "$_id",
//   );
//   var ios = IOSNotificationDetails();
//   var _platform = NotificationDetails(android: android, iOS: ios);
//   _flutterLocalNotificationsPlugin.show(
//       id, "${_notify["title"]}", "${_notify["body"]}", _platform,
//       payload: json.encode(message));
// }


// Future FLUTTER_NOTIFICATION_CLICK(payload) async {
//   var obj = payload;
//   if (payload is String) {
//     obj = json.decode(payload);
//   }
//
//   var _data;
//   if (Platform.isIOS) {
//     _data = obj["notification"];
//   } else {
//     _data = obj["data"];
//   }
//   print("tttttttttt $_data");
//   int _type = int.parse(_data["type"]);
//
//
//   // if (_type >= 1 && _type <= 4) {
//   //   var adInfo= json.decode(_data["ads_info"]);
//   //   AdsModel model = new AdsModel.fromJson(adInfo);
//   //   ExtendedNavigator.root.push(Routes.productDetails,
//   //       arguments: ProductDetailsArguments(model: model));
//   // } else if(_type >4) {
//   //   ExtendedNavigator.root.push(Routes.home);
//   // }
//
//
// }
}














// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class GlobalNotification {
//   static StreamController<Map<String, dynamic>> _onMessageStreamController =
//   StreamController.broadcast();
//
//   final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//   FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
//   int _id = 0;
//   bool show = true;
//   BuildContext _context;
//   static GlobalNotification instance = new GlobalNotification._();
//
//   GlobalNotification._();
//
//   GlobalNotification();
//
//   // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
//   //   print("Handling a background message: ${message.messageId}");
//   // }
//
//
//   setupNotification({BuildContext context}) {
//     _context = context;
//     _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//     var android = new AndroidInitializationSettings("@mipmap/launcher_icon");
//     var ios = new IOSInitializationSettings();
//     var initSettings = new InitializationSettings(android: android, iOS: ios);
//     _flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//       onSelectNotification: flutterNotificationClick,
//     );
//
//
//     // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("-------------${message.data}");
//       RemoteNotification notification = message.notification;
//       AndroidNotification android = message.notification?.android;
//       _showLocalNotification(message.data, _id);
//     });
//
//     // firebaseMessaging.configure(
//     //   onMessage: (Map<String, dynamic> message) {
//     //     _id++;
//     //     print("_____________________$message");
//     //     _showLocalNotification(message, _id);
//     //     _onMessageStreamController.add(message);
//     //     var _notify = message["data"];
//     //     if (Platform.isIOS) {
//     //       _notify = message["notification"]??message["aps"]["alert"];
//     //     }
//     //     if (int.parse(_notify["type"]) == -1) {
//     //       Utils.clearSavedData();
//     //       ExtendedNavigator.of(context).push(Routes.login);
//     //     }
//     //     return;
//     //   },
//     //   onResume: (Map<String, dynamic> message) {
//     //     print("resssssssssssssssssume $message");
//     //     _showLocalNotification(message, _id);
//     //     return;
//     //   },
//     //   onLaunch: (Map<String, dynamic> message) {
//     //     print("lunchiiiiiiiiiiiing $message");
//     //     // _showLocalNotification(message, _id);
//     //     return;
//     //   },
//     // );
//     // _firebaseMessaging.getToken().then((token) {
//     //   print(token);
//     // });
//
//   }
//
//   StreamController<Map<String, dynamic>> get notificationSubject {
//     return _onMessageStreamController;
//   }
//
//   _showLocalNotification(message, id) async {
//     var _notify = message["data"];
//
//     // print("-------------${message}");
//     if (Platform.isIOS) {
//       _notify = message["notification"]??message["aps"]["alert"];
//     }
//     int _type = int.parse(_notify["type"]??"0");
//
//     // if(_type==9){
//     //   _context.read<ChatCountCubit>().onUpdateCount(_context.read<ChatCountCubit>().state.count+1);
//     // }else{
//     //   _context.read<NotifyCountCubit>().onUpdateCount(_context.read<NotifyCountCubit>().state.count+1);
//     // }
//
//     var android = AndroidNotificationDetails(
//       "${DateTime.now()}",
//       "Show ksa",
//       "${_notify["body"]}",
//       priority: Priority.high,
//       importance: Importance.max,
//       playSound: true,
//       shortcutId: "$_id",
//     );
//     var ios = IOSNotificationDetails(badgeNumber: _notify["badge"]);
//     var _platform = NotificationDetails(android: android, iOS: ios);
//     _flutterLocalNotificationsPlugin.show(
//         id, "Show ksa", "${_notify["body"]}", _platform,
//         payload: json.encode(message));
//   }
//
//   Future flutterNotificationClick(payload) async {
//     var obj = payload;
//     if (payload is String) {
//       obj = json.decode(payload);
//     }
//     var _data=obj["notification"];
//     if (Platform.isAndroid) {
//       _data = obj["data"];
//     }
//
//     // int _type = int.parse(_data["type"]??"4");
//     // if (_type >= 1 && _type <= 4) {
//     //   var adInfo= json.decode(_data["ads_info"]);
//     //   AdsModel model = new AdsModel.fromJson(adInfo);
//     //   ExtendedNavigator.root.push(Routes.productDetails,
//     //       arguments: ProductDetailsArguments(model: model));
//     // } else if(_type ==5||_type ==6||_type ==8) {
//     //   ExtendedNavigator.root.push(Routes.userProducts,
//     //       arguments: UserProductsArguments(userId: _data["user_id"],userName: _data["user_name"]));
//     // } else if(_type ==9) {
//     //   ExtendedNavigator.root.push(Routes.chat,
//     //       arguments: ChatArguments(userName: _data["userName"],receiverId: _data["receiverId"],senderId: _data["senderId"]));
//     // } else if(_type ==7) {
//     //   int parentCount=(await _context.read<MyDatabase>().selectParentCatsAsync()).length;
//     //   ExtendedNavigator.root.push(Routes.home,arguments: HomeArguments(parentCount: parentCount,tab: 2));
//     // }
//   }
// }
