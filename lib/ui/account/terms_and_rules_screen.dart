import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:warshat/providers/terms_provider.dart';
import 'package:warshat/utils/error.dart';
import 'dart:math' as math;

import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class TermsAndRulesScreen extends StatefulWidget {
  @override
  _TermsAndRulesScreenState createState() => _TermsAndRulesScreenState();
}

class _TermsAndRulesScreenState extends State<TermsAndRulesScreen> {
  double _height = 0 , _width = 0;
  bool _isLoading = false;



  Widget _buildBodyItem(){
    return ListView(
      shrinkWrap: true,
      children: <Widget>[

        Container(

          padding: EdgeInsets.all(40),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                const Radius.circular(17.00),
              ),
              border: Border.all(color: Color(0xff7070702B))),
          alignment: Alignment.center,
          child: Image.asset('assets/images/logo.png'),
        ),

       Container(

         padding: EdgeInsets.all(30),
         margin: EdgeInsets.only(left: 20,right: 20),
         decoration: BoxDecoration(
             color: mainAppColor,
             borderRadius: BorderRadius.all(
               const Radius.circular(17.00),
             ),
             border: Border.all(color: Color(0xff7070702B))),

         child:  FutureBuilder<String>(
             future: Provider.of<TermsProvider>(context,
                 listen: false)
                 .getTerms() ,
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
                       errorMessage:  AppLocalizations.of(context).translate('error'),
                     );
                   } else {
                     return Container(


                         margin:
                         EdgeInsets.symmetric(horizontal: _width * 0.04),
                         child: Html(data: snapshot.data,));
                   }
               }
               return Center(
                 child: SpinKitFadingCircle(color: mainAppColor),
               );
             }),
       )






      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        _height =  MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;



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
      title: Text(AppLocalizations.of(context).translate('rules_and_terms'),style: TextStyle(fontSize: 18,color: Colors.black),),



    );


    return PageContainer(
      child: Scaffold(
        backgroundColor: Color(0xffFBFBFB),
          appBar: appBar,
          body: Stack(
            children: <Widget>[
              _buildBodyItem(),


              _isLoading
                  ? Center(
                child:SpinKitFadingCircle(color: mainAppColor),
              )
                  :Container()
            ],
          )),
    );
  }
}