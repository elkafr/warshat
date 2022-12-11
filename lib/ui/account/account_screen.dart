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
import 'package:warshat/ui/my_ads/my_ads_screen.dart';
import 'package:warshat/ui/my_chats/my_chats_screen.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:provider/provider.dart';
class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
 double _height = 0 , _width = 0;

 NavigationProvider _navigationProvider;
 AuthProvider _authProvider ;
 
Widget _buildBodyItem(){
  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        SizedBox(
          height: 80,
        ),
    
      
        Consumer<AuthProvider>(
          builder: (context,authProvider,child){
            return CircleAvatar(
                  backgroundColor: accentColor,
                    radius: _height *0.09,
                  backgroundImage: NetworkImage(authProvider.currentUser.userPhoto),
                  );
          }
        ),
                  SizedBox(
                    height: _height*0.02,
                  ),
ListTile(
  onTap: ()=>    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PersonalInformationScreen()))
           ,
    
                    dense:true,
    leading: Image.asset('assets/images/edit.png',color: accentColor,),
    title: Text(AppLocalizations.of(context).translate("personal_info"),style: TextStyle(
      color: Colors.black,fontSize: 15
    ),),
    ),
    ListTile(
              onTap: ()=>    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyAdsScreen())),
         dense:true,
    leading: Image.asset('assets/images/adds.png',color: accentColor,),
    title: Text( AppLocalizations.of(context).translate("my_ads"),style: TextStyle(
      color: Colors.black,fontSize: 15
    ),),
    ),
    ListTile(
        onTap: ()=>    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyChatsScreen())),
         dense:true,
    leading: Image.asset('assets/images/chat.png',color: accentColor,),
    title: Text( AppLocalizations.of(context).translate("my_chats"),style: TextStyle(
      color: Colors.black,fontSize: 15
    ),),
    ),
     ListTile(
        onTap: ()=>    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppCommissionScreen())),
         dense:true,
    leading: Icon(FontAwesomeIcons.solidHandshake,color: accentColor,),
    title: Text( AppLocalizations.of(context).translate("app_commission"),style: TextStyle(
      color: Colors.black,fontSize: 15
    ),),
    ),
      ListTile(
        onTap: ()=>    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LanguageScreen())),
         dense:true,
    leading: Icon(FontAwesomeIcons.language,color: accentColor,),
    title: Text( AppLocalizations.of(context).translate("language"),style: TextStyle(
      color: Colors.black,fontSize: 15
    ),),
    ),
     ListTile(
           onTap: ()=>    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutAppScreen())),
          dense:true,
    leading: Image.asset('assets/images/about.png',color: accentColor,),
    title: Text( AppLocalizations.of(context).translate("about_app"),style: TextStyle(
      color: Colors.black,fontSize: 15
    ),),
    ),
     ListTile(
            onTap: ()=>    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsAndRulesScreen())),
          dense:true,
    leading: Image.asset('assets/images/conditions.png',color: accentColor,),
    title: Text( AppLocalizations.of(context).translate("rules_and_terms"),style: TextStyle(
      color: Colors.black,fontSize: 15
    ),),
    ),
    ListTile(
       onTap: ()=>    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactWithUsScreen())),
         dense:true,
    leading: Image.asset('assets/images/call.png',color: accentColor,),
    title: Text( AppLocalizations.of(context).translate("contact_us"),style: TextStyle(
      color: Colors.black,fontSize: 15
    ),),
    ),

      ListTile(
           dense:true,
    leading: Image.asset('assets/images/logout.png',color: accentColor,),
    title: Text( AppLocalizations.of(context).translate('logout'),style: TextStyle(
      color: Colors.black,fontSize: 15
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
                             _navigationProvider.upadateNavigationIndex(0);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/navigation', (Route<dynamic> route) => false);
                                _authProvider.setCurrentUser(null);
                          },
                        );
                      });
    },
    ),
       
      ],
    ),
  );
}


@override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _navigationProvider = Provider.of<NavigationProvider>(context);
  _authProvider = Provider.of<AuthProvider>(context);

    final appBar = AppBar(
      backgroundColor: mainAppColor,
      centerTitle: true,
      title: _authProvider.currentLang == 'ar' ? Text("اختر القسم",style: TextStyle(fontSize: 20),) :Text("Select category",style: TextStyle(fontSize: 20)),
      actions: <Widget>[
        GestureDetector(
          child: Icon(Icons.arrow_forward,color: Colors.white,size: 35,),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        Padding(padding: EdgeInsets.all(5)),

      ],

    );
    return PageContainer(
      child: Scaffold(
          appBar: appBar,
          body: Stack(
        children: <Widget>[
          _buildBodyItem(),


        ],
      )),
    );
  }
}