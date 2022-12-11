import 'package:warshat/ui/auth/login_screen.dart';
import 'package:warshat/ui/notification/notification_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/models/ad.dart';
import 'package:warshat/ui/home/widgets/category_item1.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/utils/urls.dart';
import 'package:warshat/custom_widgets/ad_item/ad_item.dart';
import 'package:warshat/custom_widgets/no_data/no_data.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/ui/categories/categories_screen.dart';
import 'package:warshat/models/ad.dart';
import 'package:warshat/models/category.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/providers/navigation_provider.dart';
import 'package:warshat/ui/ad_details/ad_details_screen.dart';
import 'package:warshat/ui/home/widgets/category_item.dart';
import 'package:warshat/ui/home/widgets/map_widget.dart';
import 'package:warshat/ui/search/search_bottom_sheet.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:warshat/utils/error.dart';
import 'package:warshat/providers/navigation_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/ui/home/widgets/slider_images.dart';
import 'package:warshat/ui/home/cats_screen.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/utils/urls.dart';
import 'package:warshat/ui/add_ad/widgets/add_ad_bottom_sheet.dart';
import 'package:warshat/custom_widgets/MainDrawer.dart';
import 'package:warshat/utils/commons.dart';



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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  double _height = 0, _width = 0;
  NavigationProvider _navigationProvider;
 Future<List<CategoryModel>> _categoryList;
  bool _initialRun = true;
  HomeProvider _homeProvider;
  AnimationController _animationController;
  AuthProvider _authProvider;
  Future<List<Ad>> _sacrificesList;
  ApiProvider _apiProvider = ApiProvider();
  String xx='';




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
    var platform = new InitializationSettings(android, ios);
    _flutterLocalNotificationsPlugin.initialize(platform,onSelectNotification: onSelectNotification);

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


  Future onSelectNotification(String payload) async {

    if (payload != null) {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return NotificationScreen();
        }),
      );

    }
    print("notificationClicked");


  }

  _showNotification(Map<String, dynamic> message) async {
    var android = new AndroidNotificationDetails(
      'channel id',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
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
  void initState() {

    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }
    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);
      _categoryList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:false));
      _initialRun = false;
      _checkIsLogin();
    }
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  Future<List<Ad>> _getSearchResults(String title) async {
    Map<String, dynamic> results =
    await _apiProvider.get(Urls.SEARCH_URL +'title=$title');
    List<Ad> adList = List<Ad>();
    if (results['response'] == '1') {
      Iterable iterable = results['results'];
      adList = iterable.map((model) => Ad.fromJson(model)).toList();
    } else {
      print('error');
    }
    return adList;
  }

  Widget _buildBodyItem() {

    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    return ListView(
      children: <Widget>[


        Container(
          color: Color(0xffFBFBFB),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[


              Container(

                child: SingleChildScrollView(

                  child: Column(

                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(0,0,0,0),
                          height: _height,
                          width: _width,
                          child:
                          Consumer<HomeProvider>(builder: (context, homeProvider, child) {
                            return FutureBuilder<List<Ad>>(
                                future:  Provider.of<HomeProvider>(context, listen: true)
                                    .getAdsList(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                      return Center(
                                        child: SpinKitFadingCircle(color: mainAppColor),
                                      );
                                    case ConnectionState.active:
                                      return Text('');
                                    case ConnectionState.waiting:
                                      return Center(
                                        child: SpinKitFadingCircle(color: mainAppColor),
                                      );
                                    case ConnectionState.done:
                                      if (snapshot.hasError) {
                                        return Error(
                                          //  errorMessage: snapshot.error.toString(),
                                          errorMessage: "حدث خطأ ما ",
                                        );
                                      } else {
                                        if (snapshot.data.length > 0) {

                                          return MapWidget(adList: snapshot.data);

                                        } else {
                                          return NoData(message: 'لاتوجد نتائج');
                                        }
                                      }
                                  }
                                  return Center(
                                    child: SpinKitFadingCircle(color: mainAppColor),
                                  );
                                });
                          }))

                    ],
                  ),
                ),
              ),


            ],
          ),
        )



      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);
    _authProvider = Provider.of<AuthProvider>(context);

    final appBar = AppBar(
      elevation: 1,
      backgroundColor: Colors.white,
      centerTitle: true,

        leading: Builder(
            builder: (context) => IconButton(
              icon: Image.asset("assets/images/drawer.png"),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
        ),
      title:Text("اختر الورشة المناسبة",style: TextStyle(fontSize: 18,color: Colors.black),),
      actions: <Widget>[
        GestureDetector(
          onTap: (){
            showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                context: context,
                builder: (builder) {
                  return Container(
                      width: _width,
                      height: _height * 0.6,
                      child: SearchBottomSheet());
                });
          },
          child: Column(
            children: <Widget>[


              Padding(
                  padding: const EdgeInsets.only(top: 15 ),
                  child: Text(
                    "تصفية الورش",
                    style: TextStyle(fontSize: 16.0,color: Colors.black),
                  ))
            ],
          ),
        ),

        Padding(padding: EdgeInsets.all(5))
      ],
    );
    _height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _navigationProvider = Provider.of<NavigationProvider>(context);

    return PageContainer(
      child: RefreshIndicator(child: Scaffold(
        appBar: appBar,
        drawer: MainDrawer(),
        body: Stack(
          children: <Widget>[
            _buildBodyItem(),


          ],
        ),

      ),    onRefresh: () async {
        setState(() {});
      },),
    );
  }
}
