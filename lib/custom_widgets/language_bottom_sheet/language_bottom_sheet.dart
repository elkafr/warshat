import 'package:flutter/material.dart';
import 'package:warshat/locale/locale_helper.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/shared_preferences/shared_preferences_helper.dart';
import 'package:provider/provider.dart';


class LanguageBottomSheet extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
 AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Container(
        height: 130,
        child:  Column(
              children: <Widget>[
                SizedBox(
                  height:40,
                ),
                GestureDetector(
                    onTap: () {
                      
                     if(authProvider.currentLang != 'ar'){
               SharedPreferencesHelper.setUserLang('ar');
            helper.onLocaleChanged(new Locale('ar'));
            authProvider.setCurrentLanguage('ar');
            print(authProvider.currentLang);
           }
            Navigator.pushReplacementNamed(context, '/');
        
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Image.asset('assets/images/arabic.png')),
                        Text('العربية' ,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Cairo'),
                        ),
                      ],
                    )),
                Divider(),
                GestureDetector(
                  onTap: () {
                    
                       if(authProvider.currentLang != 'en'){
   SharedPreferencesHelper.setUserLang('en');
            helper.onLocaleChanged( Locale('en'));
            authProvider.setCurrentLanguage('en');
         
            
           }
             Navigator.pushReplacementNamed(context, '/');
                  },
                  child:  Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Image.asset('assets/images/english.png')),
                        Text('English' ,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                )
              ],
            ),
           

           
        );
  }
}
