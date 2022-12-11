import 'package:warshat/providers/comment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/providers/ad_details_provider.dart';
import 'package:warshat/providers/add_ad_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/chat_provider.dart';
import 'package:warshat/providers/commission_app_provider.dart';
import 'package:warshat/providers/favourite_provider.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/providers/my_ads_provider.dart';
import 'package:warshat/providers/navigation_provider.dart';
import 'package:warshat/providers/notification_provider.dart';
import 'package:warshat/providers/received_msgs_provider.dart';
import 'package:warshat/providers/register_provider.dart';
import 'package:warshat/providers/section_ads_provider.dart';
import 'package:warshat/providers/progress_indicator_state.dart';
import 'package:warshat/providers/location_state.dart';
import 'package:warshat/shared_preferences/shared_preferences_helper.dart';
import 'package:warshat/theme/style.dart';
import 'package:warshat/utils/routes.dart';
import 'package:provider/provider.dart';
import 'locale/locale_helper.dart';
import 'providers/about_app_provider.dart';
import 'package:warshat/providers/recently_added_products_provider.dart';
import 'providers/terms_provider.dart';


void main() async {
   WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ])
      .then((_) {
    run();
  });
}

void run() async {
 
  runApp(MyApp(
  ));
}



class MyApp extends StatefulWidget {



  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
Locale _locale;
 onLocaleChange(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  Future<void> _getLanguage() async {
    String language = await SharedPreferencesHelper.getUserLang();
    onLocaleChange(Locale(language));
  }

  @override
  void initState() {
    super.initState();

    helper.onLocaleChanged = onLocaleChange;
    _locale= new Locale('en');
    _getLanguage();
  }
  @override
  Widget build(BuildContext context) {
    return   MultiProvider(
            providers: [

          ChangeNotifierProvider(
            create: (_) => AuthProvider(),
          ),


              ChangeNotifierProvider(
                create: (_) => ProgressIndicatorState(),
              ),

              ChangeNotifierProxyProvider<AuthProvider,RecentlyAddedProductsProvider >(
                create: (_) => RecentlyAddedProductsProvider(),
                update: (_, auth, recentlyAddedProductsProvider) => recentlyAddedProductsProvider..update(auth),
              ),


              ChangeNotifierProvider(
                create: (_) => LocationState(),
              ),
            ChangeNotifierProxyProvider<AuthProvider,RegisterProvider >(
            create: (_) => RegisterProvider(),
            update: (_, auth, registerProvider) => registerProvider..update(auth),
           
          ),
             ChangeNotifierProxyProvider<AuthProvider,AddAdProvider >(
            create: (_) => AddAdProvider(),
            update: (_, auth, addAdProvider) => addAdProvider..update(auth),
           
          ),
          ChangeNotifierProvider(
            create: (_) => NavigationProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider,AdDetailsProvider >(
            create: (_) => AdDetailsProvider(),
            update: (_, auth, adDetailsProvider) => adDetailsProvider..update(auth),
           
          ),
           ChangeNotifierProxyProvider<AuthProvider,AboutAppProvider >(
            create: (_) => AboutAppProvider(),
            update: (_, auth, aboutAppProvider) => aboutAppProvider..update(auth),
           
          ),
          ChangeNotifierProxyProvider<AuthProvider,CommisssionAppProvider >(
            create: (_) => CommisssionAppProvider(),
            update: (_, auth, commissionAppProvider) => commissionAppProvider..update(auth),
           
          ),
             ChangeNotifierProxyProvider<AuthProvider,TermsProvider >(
            create: (_) => TermsProvider(),
            update: (_, auth, termsProvider) => termsProvider..update(auth),
           
          ),
          ChangeNotifierProxyProvider<AuthProvider,NotificationProvider >(
            create: (_) => NotificationProvider(),
            update: (_, auth, notificationProvider) => notificationProvider..update(auth),
           
          ),
             ChangeNotifierProxyProvider<AuthProvider,ReceivedMsgsProvider >(
            create: (_) => ReceivedMsgsProvider(),
            update: (_, auth, receivedMsgsProvider) => receivedMsgsProvider..update(auth),
           
          ),
           ChangeNotifierProxyProvider<AuthProvider,ChatProvider >(
            create: (_) => ChatProvider(),
            update: (_, auth, chatProvider) => chatProvider..update(auth),
           
          ),
            ChangeNotifierProxyProvider<AuthProvider,SectionAdsProvider >(
            create: (_) => SectionAdsProvider(),
            update: (_, auth, sectionAdsProvider) => sectionAdsProvider..update(auth),
           
          ),
              ChangeNotifierProxyProvider<AuthProvider,CommentProvider >(
                create: (_) => CommentProvider(),
                update: (_, auth, commentProvider) => commentProvider..update(auth),

              ),
  ChangeNotifierProxyProvider<AuthProvider, HomeProvider>(
            create: (_) => HomeProvider(),
            update: (_, auth, homeProvider) => homeProvider..update(auth),
           
          ),
           ChangeNotifierProxyProvider<AuthProvider,  MyAdsProvider>(
            create: (_) =>  MyAdsProvider(),
            update: (_, auth, myAdsProvider) => myAdsProvider..update(auth),
           
          ),
         
           ChangeNotifierProxyProvider<AuthProvider, FavouriteProvider>(
            create: (_) => FavouriteProvider(),
            update: (_, auth, favouriteProvider) => favouriteProvider..update(auth),
          ),





        ],
          
   
        child: MaterialApp(
          locale: _locale,
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ar', ''),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
                  debugShowCheckedModeBanner: false,
              title: 'ورش',
              theme: themeData(),
               routes: routes,
        ));
      
  }
}
