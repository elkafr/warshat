
import 'package:warshat/ui/account/pay_commission_screen.dart';
import 'package:warshat/ui/auth/code_activation_screen.dart';
import 'package:warshat/ui/auth/login_screen.dart';
import 'package:warshat/ui/auth/loginc_screen.dart';
import 'package:warshat/ui/auth/new_password_screen.dart';
import 'package:warshat/ui/auth/phone_password_recovery_screen.dart';
import 'package:warshat/ui/auth/register_screen.dart';
import 'package:warshat/ui/bottom_navigation.dart/bottom_navigation_bar.dart';
import 'package:warshat/ui/comment/comment_screen.dart';
import 'package:warshat/ui/countries/countries_screen.dart';
import 'package:warshat/ui/my_ads/my_ads_screen.dart';
import 'package:warshat/ui/notification/notification_screen.dart';
import 'package:warshat/ui/package/package_screen.dart';
import 'package:warshat/ui/search/search_screen.dart';
import 'package:warshat/ui/splash/splash_screen.dart';
import 'package:warshat/ui/categories/categories_screen.dart';
import 'package:warshat/ui/cities/cities_screen.dart';

import 'package:warshat/ui/home/home_map.dart';


final routes = {
  '/': (context) => SplashScreen(),
  '/login_screen':(context)=> LoginScreen(),
  '/loginc_screen':(context)=> LoginCScreen(),
  '/phone_password_reccovery_screen' :(context) => PhonePasswordRecoveryScreen(),
  '/code_activation_screen':(context) => CodeActivationScreen(),
 '/new_password_screen' :(context) => NewPasswordScreen(),
 '/register_screen':(context) => RegisterScreen(),
  '/navigation': (context) =>  BottomNavigation(),
  '/my_ads_screen':(context) =>MyAdsScreen(),
 '/notification_screen':(context) => NotificationScreen(),

 '/cities_screen':(context) => CitiesScreen(),
 '/countries_screen':(context) => CountriesScreen(),
 '/package_screen':(context) => PackageScreen(),
 '/search_screen':(context) => SearchScreen(),
 '/comment_screen':(context) => CommentScreen(),
 '/pay_commission_screen':(context) => PayCommissionScreen(),
  '/map': (context) => HomeMap(),


};
