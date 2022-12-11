import 'package:warshat/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/shared_preferences/shared_preferences_helper.dart';
import 'package:provider/provider.dart';
import 'package:warshat/ui/auth/loginc_screen.dart';
import 'package:warshat/ui/home/home_screen.dart';
import 'package:warshat/shared_preferences/shared_preferences_helper.dart';
import 'package:location/location.dart';
import 'package:warshat/shared_preferences/shared_preferences_helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  double _height = 0, _width = 0;
  AuthProvider _authProvider;
  HomeProvider _homeProvider;
  LocationData _locData;


  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  
    Future initData() async {
    await Future.delayed(Duration(seconds: 4));
  }


   Future<void> _getLanguage() async {
    String currentLang = await SharedPreferencesHelper.getUserLang();
    _authProvider.setCurrentLanguage(currentLang);

  }


  Future<void> _getCurrentUserLocation() async {
    _locData = await Location().getLocation();
    if(_locData != null){
      print('lat' + _locData.latitude.toString());
      print('longitude' + _locData.longitude.toString());

      setState(() {
        _homeProvider.setLatValue(_locData.latitude.toString());
        _homeProvider.setLongValue(_locData.longitude.toString());
        _homeProvider.setLoginValue("0");
      });
    }
  }



  Future<Null> _checkIsLoginUser() async {
    var userData = await SharedPreferencesHelper.read("checkUser");
    if (userData != null) {
      _homeProvider.setCheckedValue(userData.toString());
    }else{
      _homeProvider.setCheckedValue("false");
    }

  }

  @override
  void initState() {
    super.initState();
      _getLanguage();
    _getCurrentUserLocation();
    _checkIsLoginUser();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2300),
      vsync: this,
    )..repeat(reverse: false);
    _offsetAnimation = Tween<Offset>(
      begin: Offset.fromDirection(0.2, 0.1),
      end: Offset(-1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));

    initData().then((value) {
print(_homeProvider.checkedValue);

_homeProvider.setLoginValue("0");

      (_homeProvider.checkedValue=="false")?Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LoginCScreen())):Navigator.pushReplacement(
      context,
      MaterialPageRoute(
      builder: (context) =>
      HomeScreen()));


    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    _homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      body: Stack(
          children: [
            Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.fill,
              height: _height,
              width: _width,
            ),
            SlideTransition(
              position: _offsetAnimation,
              child: Container(
                width: _width,
                margin: EdgeInsets.only(top: _height * 0.428),
                padding: EdgeInsets.only(right: _width * 0.18),
                child: Image.asset(
                  'assets/images/toplogo.png',
                  height: _height * 0.12,
                  width: _width * 0.13,
                ),
              ),
            ),
          ] ),
    );
  }
}
