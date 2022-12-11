import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:warshat/custom_widgets/connectivity/network_indicator.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/models/user.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/navigation_provider.dart';
import 'package:warshat/shared_preferences/shared_preferences_helper.dart';
import 'package:warshat/ui/add_ad/widgets/add_ad_bottom_sheet.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:provider/provider.dart';


class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
 bool _initialRun = true;
   AuthProvider _authProvider;
 NavigationProvider _navigationProvider;
 
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  void _iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void _firebaseCloudMessagingListeners() {
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android: android, iOS: ios);
    _flutterLocalNotificationsPlugin.initialize(platform);
 
    if (Platform.isIOS) _iOSPermission();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        _showNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');

        Navigator.pushNamed(context, '/notification_screen');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');

        Navigator.pushNamed(context, '/notification_screen');
      },
    );
  }

  _showNotification(Map<String, dynamic> message) async {
    var android = new AndroidNotificationDetails(
      'channel id',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await _flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'],
        message['notification']['body'],
        platform);
  }



  Future<Null> _checkIsLogin() async {
    var userData = await SharedPreferencesHelper.read("user");
    if (userData != null) {
      _authProvider.setCurrentUser(User.fromJson(userData));
  _firebaseCloudMessagingListeners();
    }
   
  }
  


 

 @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) { 
      _authProvider = Provider.of<AuthProvider>(context);
       _checkIsLogin();
       _initialRun = false;
      
    }
  }



  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);
    return NetworkIndicator(
        child: Scaffold(
      body: _navigationProvider.selectedContent,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[


          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/pin.png',
              color: mainAppColor,
            ),
             activeIcon: Image.asset(
               'assets/images/pin.png',
               color: mainAppColor,
             ),
            title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  "بحث بالمدينة",
                  style: TextStyle(fontSize: 18.0,color: mainAppColor),
                )),
          ),

           BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/addads.png',
              color: mainAppColor,
            ),
             activeIcon: Image.asset(
               'assets/images/addads.png',
               color: mainAppColor,
             ),
            title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                 "بحث بالاعلان",
                  style: TextStyle(fontSize: 18.0,color: mainAppColor),
                )),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/catt.png',
               color: mainAppColor,
            ),
             activeIcon: Image.asset(
              'assets/images/catt.png',
              color: mainAppColor,
            ),
            title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                       "بحث بالقسم",
                  style: TextStyle(fontSize: 18.0,color: mainAppColor),
                )),
          ),
        
        ],
        currentIndex: _navigationProvider.navigationIndex,
        selectedItemColor: mainAppColor,
        unselectedItemColor: Color(0xFFC4C4C4),
        onTap: (int index) {
          _navigationProvider.upadateNavigationIndex(index);
          
        },
        elevation: 3,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    ));
  }
}
