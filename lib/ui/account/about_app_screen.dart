import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/utils/error.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:warshat/providers/about_app_provider.dart';
import 'dart:math' as math;

import 'package:flutter_html/flutter_html.dart';

class AboutAppScreen extends StatefulWidget {
  @override
  _AboutAppScreenState createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
double _height = 0 , _width = 0;




Widget _buildBodyItem(){
  return SingleChildScrollView(
    child: Container(
      height: _height,
      width: _width,
      child: Column(
     
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
            Container(
             alignment: Alignment.center,
             margin: EdgeInsets.only(bottom: _height *0.02),
             child:  Image.asset('assets/images/logo.png',height:_height *0.2 ,),
           ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: _width *0.04),
                child: Divider(),
             ),
               Expanded(
                 child: FutureBuilder<String>(
                    future: Provider.of<AboutAppProvider>(context,
                            listen: false)
                        .getAboutApp() ,
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
                       return    Container(
             margin: EdgeInsets.symmetric(horizontal: _width *0.04),
             child: Html(data: snapshot.data));
                          }
                      }
                      return Center(
                        child: SpinKitFadingCircle(color: mainAppColor),
                      );
                    }),
               )
 
          
            
   

            
        ],
      ),
    ),
  );
}

@override
  Widget build(BuildContext context) {




    final appBar = AppBar(
      elevation: 1,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      leading:    GestureDetector(
        child: Icon(Icons.arrow_back,color: Colors.black,size: 35,),
        onTap: (){
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(AppLocalizations.of(context).translate('about_app'),style: TextStyle(fontSize: 18,color: Colors.black),),

    );

    _height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;

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