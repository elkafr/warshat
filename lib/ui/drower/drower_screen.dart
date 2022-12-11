import 'package:flutter/material.dart';
import 'package:warshat/custom_widgets/dialogs/log_out_dialog.dart';
import 'package:warshat/custom_widgets/language_bottom_sheet/language_bottom_sheet.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/shared_preferences/shared_preferences_helper.dart';
import 'package:warshat/ui/auth/loginc_screen.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;



import 'package:warshat/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/custom_widgets/dialogs/log_out_dialog.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/navigation_provider.dart';
import 'package:warshat/shared_preferences/shared_preferences_helper.dart';
import 'package:warshat/ui/account/about_app_screen.dart';
import 'package:warshat/ui/account/app_commission_screen.dart';
import 'package:warshat/ui/account/contact_with_us_screen.dart';
import 'package:warshat/ui/account/language_screen.dart';
import 'package:warshat/ui/account/personal_information_screen.dart';
import 'package:warshat/ui/account/terms_and_rules_Screen.dart';
import 'package:warshat/ui/package/package_screen.dart';
import 'package:warshat/ui/my_ads/my_ads_screen.dart';
import 'package:warshat/ui/notification/notification_screen.dart';
import 'package:warshat/ui/favourite/favourite_screen.dart';
import 'package:warshat/ui/my_chats/my_chats_screen.dart';
import 'package:warshat/ui/home/home_screen.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:provider/provider.dart';


import 'package:warshat/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/custom_widgets/dialogs/log_out_dialog.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/providers/navigation_provider.dart';
import 'package:warshat/shared_preferences/shared_preferences_helper.dart';
import 'package:warshat/ui/account/about_app_screen.dart';
import 'package:warshat/ui/account/app_commission_screen.dart';
import 'package:warshat/ui/account/contact_with_us_screen.dart';
import 'package:warshat/ui/account/language_screen.dart';
import 'package:warshat/ui/account/personal_information_screen.dart';
import 'package:warshat/ui/account/terms_and_rules_Screen.dart';
import 'package:warshat/ui/my_ads/my_ads_screen.dart';
import 'package:warshat/ui/notification/notification_screen.dart';
import 'package:warshat/ui/favourite/favourite_screen.dart';
import 'package:warshat/ui/my_chats/my_chats_screen.dart';
import 'package:warshat/ui/home/home_screen.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:warshat/providers/terms_provider.dart';
import 'package:warshat/utils/error.dart';


class AppDrawer extends StatelessWidget {
double _width, _height;

AuthProvider _authProvider ;
HomeProvider _homeProvider ;

  Widget _buildAppDrawer(BuildContext context) {
   _width = MediaQuery.of(context).size.width;
   _height = MediaQuery.of(context).size.height;
   _authProvider = Provider.of<AuthProvider>(context);
   _homeProvider = Provider.of<HomeProvider>(context);
    return Container(

        color: mainAppColor,
        padding: EdgeInsets.only(top: 70, bottom: 30, left: 10, right:10),
        width: _width,

  child:  ListView(

    padding: EdgeInsets.zero,

    children: <Widget>[


      (_authProvider.currentUser==null)?
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(
                  color: hintColor.withOpacity(0.4),
                ),
                color: Colors.white,


              ),
              child: Image.asset("assets/images/logo.png",width: 70,height:70 ,),
            ),
            Padding(padding: EdgeInsets.all(7)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(4)),
                Text("زائر",style: TextStyle(color: Colors.white,fontSize: 18)),
                Text("الحساب الشخصي",style: TextStyle(color: accentColor,fontSize: 16),),
              ],
            )
          ],
        ),
      )
          :Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Consumer<AuthProvider>(
                builder: (context,authProvider,child){
                  return CircleAvatar(
                    backgroundColor: accentColor,
                    backgroundImage: NetworkImage(authProvider.currentUser.userPhoto),
                    maxRadius: 40,
                  );
                }
            ),
            Padding(padding: EdgeInsets.all(7)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(4)),
                Text(_authProvider.currentUser.userName,style: TextStyle(color: Colors.white,fontSize: 18)),
                _authProvider.currentUser.userType=="1"?Text("الحساب الشخصي",style: TextStyle(color: accentColor,fontSize: 16),):Text(" انتهاء الاشتراك "+_authProvider.currentUser.userEndDate.toString(),style: TextStyle(color: accentColor,fontSize: 16),maxLines: 2,),
              ],
            )
          ],
        ),
      ),

      Container(
        color: hintColor,
        height: 1,
        margin: EdgeInsets.all(5),
        width: _width,
      ),

      (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
        onTap: ()=>    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PersonalInformationScreen()))
        ,

        dense:true,
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(
              color: Color(0xff43A4EC),
            ),
            color: mainAppColor,
          ),
          child: Image.asset('assets/images/personal.png',color: Colors.white,),
        ),
        title: Text(_authProvider.currentUser.userType=="1"?AppLocalizations.of(context).translate("personal_info"):AppLocalizations.of(context).translate("personal_info1"),style: TextStyle(
            color: Colors.white,fontSize: 16,fontFamily: "Cairo",fontWeight: FontWeight.normal
        ),),
      ),

      Padding(padding: EdgeInsets.all(10)),


     /* (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
        onTap: ()=>    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NotificationScreen())),
        dense:true,
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(
              color: Color(0xff43A4EC),
            ),
            color: mainAppColor,
          ),
          child:Icon(FontAwesomeIcons.solidBell,color: Colors.white,),
        ),
        title: Row(
          children: <Widget>[
            Text( AppLocalizations.of(context).translate("notifications"),style: TextStyle(
                color: Colors.white,fontSize: 16,fontFamily: "Cairo",fontWeight: FontWeight.normal
            ),),
            Padding(padding: EdgeInsets.all(3)),
            Container(
              alignment: Alignment.center,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red),

              child: FutureBuilder<String>(
                  future: Provider.of<HomeProvider>(context,
                      listen: false)
                      .getUnreadNotify() ,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Center(
                          child: SpinKitFadingCircle(color: Colors.white),
                        );
                      case ConnectionState.active:
                        return Text('');
                      case ConnectionState.waiting:
                        return Center(
                          child: SpinKitFadingCircle(color: Colors.white),
                        );
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Error(
                            //  errorMessage: snapshot.error.toString(),
                            errorMessage: AppLocalizations.of(context).translate('error'),
                          );
                        } else {
                          return    Container(
                              margin: EdgeInsets.symmetric(horizontal: _width *0.04),
                              child: Text( snapshot.data.toString(),style: TextStyle(
                                  color: Colors.white,fontSize: 16,fontFamily: "Cairo",fontWeight: FontWeight.normal
                              ),));
                        }
                    }
                    return Center(
                      child: SpinKitFadingCircle(color: Colors.white),
                    );
                  }),
            ),
          ],
        ),
      ), */










      Padding(padding: EdgeInsets.all(10)),

      (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
        onTap: ()=>    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FavouriteScreen())),
        dense:true,
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(
              color: Color(0xff43A4EC),
            ),
            color: mainAppColor,
          ),
          child:Image.asset('assets/images/fav.png',color: Colors.white,),
        ),
        title: Text(AppLocalizations.of(context).translate("favourite"),style: TextStyle(
            color: Colors.white,fontSize: 16,fontFamily: "Cairo",fontWeight: FontWeight.normal
        ),),
      ),

      Padding(padding: EdgeInsets.all(10)),
      /*   (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
                  onTap: ()=>    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyAdsScreen())),
                  dense:true,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      border: Border.all(
                        color: Color(0xff43A4EC),
                      ),
                      color: mainAppColor,
                    ),
                    child:Image.asset('assets/images/adds.png',color: Colors.white,),
                  ),
                  title: Text( AppLocalizations.of(context).translate("my_ads"),style: TextStyle(
                      color: Colors.white,fontSize: 16,fontFamily: "Cairo",fontWeight: FontWeight.normal
                  ),),
                ), */


      /* (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
                  onTap: ()=>    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyChatsScreen())),
                  dense:true,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      border: Border.all(
                        color: Color(0xff43A4EC),
                      ),
                      color: mainAppColor,
                    ),
                    child:Image.asset('assets/images/chat.png',color: Colors.white,),
                  ),
                  title: Text( AppLocalizations.of(context).translate("my_chats"),style: TextStyle(
                      color: Colors.white,fontSize: 16,fontFamily: "Cairo",fontWeight: FontWeight.normal
                  ),),
                ), */




      ListTile(
        onTap: ()=>    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LanguageScreen())),
        dense:true,
        leading:  Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(
              color: Color(0xff43A4EC),
            ),
            color: mainAppColor,
          ),
          child:Image.asset('assets/images/lang.png',color: Colors.white,),
        ),
        title: Text( AppLocalizations.of(context).translate("language"),style: TextStyle(
            color: Colors.white,fontSize: 16,fontFamily: "Cairo",fontWeight: FontWeight.normal
        ),),
      ),

      Padding(padding: EdgeInsets.all(10)),


      ListTile(
        onTap: ()=>    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AboutAppScreen())),
        dense:true,
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(
              color: Color(0xff43A4EC),
            ),
            color: mainAppColor,
          ),
          child:Image.asset('assets/images/about.png',color: Colors.white,),
        ),
        title: Text( AppLocalizations.of(context).translate("about_app"),style: TextStyle(
            color: Colors.white,fontSize: 16,fontFamily: "Cairo",fontWeight: FontWeight.normal
        ),),
      ),


      Padding(padding: EdgeInsets.all(10)),


      ListTile(
        onTap: ()=>    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TermsAndRulesScreen())),
        dense:true,
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(
              color: Color(0xff43A4EC),
            ),
            color: mainAppColor,
          ),
          child:Image.asset('assets/images/conditions.png',color: Colors.white,),
        ),
        title: Text( AppLocalizations.of(context).translate("rules_and_terms"),style: TextStyle(
            color: Colors.white,fontSize: 16,fontFamily: "Cairo",fontWeight: FontWeight.normal
        ),),
      ),

      Padding(padding: EdgeInsets.all(10)),


      ( _authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):  ( _authProvider.currentUser.userType=="2")?ListTile(
        onTap: ()=>    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PackageScreen())),
        dense:true,
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(
              color: Color(0xff43A4EC),
            ),
            color: mainAppColor,
          ),
          child:Image.asset('assets/images/3mola.png',color: Colors.white,),
        ),
        title: Text(_authProvider.currentLang=="ar"?"الباقات والاشتراكات":"Packages and subscriptions",style: TextStyle(
            color: Colors.white,fontSize: 16,fontFamily: "Cairo",fontWeight: FontWeight.normal
        ),),
      ):Container(height: 0,),


      Padding(padding: EdgeInsets.all(10)),


      ListTile(
        onTap: ()=>    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContactWithUsScreen())),
        dense:true,
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(
              color: Color(0xff43A4EC),
            ),
            color: mainAppColor,
          ),
          child:Image.asset('assets/images/call.png',color: Colors.white,),
        ),
        title: Text( AppLocalizations.of(context).translate("contact_us"),style: TextStyle(
            color: Colors.white,fontSize: 16,fontFamily: "Cairo",fontWeight: FontWeight.normal
        ),),
      ),

      Padding(padding: EdgeInsets.all(10)),

      (_authProvider.currentUser==null)?ListTile(
        onTap: (){
          _homeProvider.setLoginValue("0");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginCScreen()));
        },
        dense:true,
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(
              color: Color(0xff43A4EC),
            ),
            color: mainAppColor,
          ),
          child:Image.asset('assets/images/logout.png',color: Colors.white,),
        ),
        title: Text( AppLocalizations.of(context).translate("login"),style: TextStyle(
            color: Colors.white,fontSize: 16,fontFamily: "Cairo",fontWeight: FontWeight.normal
        ),),
      ):ListTile(
        dense:true,
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(
              color: Color(0xff43A4EC),
            ),
            color: mainAppColor,
          ),
          child:Image.asset('assets/images/logout.png',color: Colors.white,),
        ),
        title: Text( AppLocalizations.of(context).translate('logout'),style: TextStyle(
            color: Colors.white,fontSize: 16,fontFamily: "Cairo",fontWeight: FontWeight.normal
        ),),
        onTap: (){
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (_) {
                return LogoutDialog(
                  alertMessage:
                  AppLocalizations.of(context).translate('want_to_logout'),
                  onPressedConfirm: () {
                    Navigator.pop(context);
                    SharedPreferencesHelper.remove("user");
                    SharedPreferencesHelper.remove("checkUser");
                    _homeProvider.setCheckedValue("false");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen()));
                    _authProvider.setCurrentUser(null);
                  },
                );
              });
        },
      ),





      SizedBox(height: 25,),
      Container(
        margin: EdgeInsets.symmetric(
            horizontal: _width * 0.2, vertical: _height * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            FutureBuilder<String>(
                future: Provider.of<TermsProvider>(context,
                    listen: false)
                    .getTwitt() ,
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
                          errorMessage:  AppLocalizations.of(context).translate('error'),
                        );
                      } else {
                        return GestureDetector(
                            onTap: () {
                              launch(snapshot.data.toString());
                            },
                            child: Image.asset(
                              'assets/images/twitter.png',
                              height: 40,
                              width: 40,
                            ));
                      }
                  }
                  return Center(
                    child: SpinKitFadingCircle(color: mainAppColor),
                  );
                })
            ,

           Padding(padding: EdgeInsets.all(10)),
            FutureBuilder<String>(
                future: Provider.of<TermsProvider>(context,
                    listen: false)
                    .getInst() ,
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
                          errorMessage:  AppLocalizations.of(context).translate('error'),
                        );
                      } else {
                        return GestureDetector(
                            onTap: () {
                              launch(snapshot.data.toString());
                            },
                            child: Image.asset(
                              'assets/images/instagram.png',
                              height: 40,
                              width: 40,
                              color: Colors.white,
                            ));
                      }
                  }
                  return Center(
                    child: SpinKitFadingCircle(color: mainAppColor),
                  );
                }),


          ],
        ),
      ),



    ],
  ),
);
  }

  @override
  Widget build(BuildContext context) {

    return _buildAppDrawer(context);
  }
}
