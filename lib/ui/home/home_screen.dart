

import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:warshat/shared_preferences/shared_preferences_helper.dart';
import 'package:warshat/ui/drower/drower_screen.dart';
import 'package:warshat/ui/home/home_map.dart';
import 'package:flutter/services.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'dart:math' as math;
import 'package:warshat/custom_widgets/custom_text_form_field/custom_text_form_field1.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/ui/search/search_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:warshat/ui/package/package_screen.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/utils/commons.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

AuthProvider _authProvider;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double _height = 0, _width = 0;
  bool isDrawerOpen = false;
String _searchKey = '';
HomeProvider _homeProvider;
bool _initialRun = true;
  String _lang;
bool _isLoading = false;


Future<Null> _checkEnd() async {



  if(_authProvider.currentUser!=null){
    if(_authProvider.currentUser.userActive=="4"){

      Commons.showToast(context,
          message:"عفوا لقد انتهت مدة اشتراككم وتم خفاء ظهور الورشة للمستخدمين لحين تجديد الاشتراك واختيار باقة من هذه الصفحة", color: Colors.red,);


      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PackageScreen()));
    }}

}






@override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (_initialRun) {
    _homeProvider = Provider.of<HomeProvider>(context);
    _authProvider = Provider.of<AuthProvider>(context);
    _initialRun = false;

  }
}


  Future<void> _getLanguage() async {
    String language = await SharedPreferencesHelper.getUserLang();
    setState(() {
      _lang = language;
    });
  }
  Widget _customAppBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: isDrawerOpen
            ? Text("")
            : GestureDetector(
            child:
            _lang == 'ar' ?
            Image.asset( 'assets/images/drawer.png', fit: BoxFit.contain,)

                : Transform.rotate(
              angle: -180 * math.pi / 180,
              child:  Image.asset(
                'assets/images/drawer.png',
                fit: BoxFit.contain,
              ),
            ),
            onTap: () {
              setState(() {
                xOffset = (_lang == 'ar')? -200 : 290 ;
                yOffset = 80;
                scaleFactor = 0.8;
                isDrawerOpen = true;
              });
            }),
        title:  Container(
          alignment: Alignment.center,
          child: Text(_authProvider.currentLang=="ar"?"اختر الورشة المناسبة":"Choose the right workshop",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily:'Cairo',
                fontSize: (_lang == 'ar')? 18 : 14,
              )),
        ),
        trailing:       GestureDetector(
            onTap: () {
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
            child: Text(
              _authProvider.currentLang=="ar"?"تصفية الورش":"Workshop filtering",
              style: TextStyle(
                fontFamily:'Cairo',
              ),
            )),
      ),
    );
  }
  




  @override
  void initState() {
    super.initState();


    _getLanguage();



  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              (isDrawerOpen == false) ? Brightness.dark : Brightness.light),
      child: Scaffold(
        body: Stack(
          children: [
            AppDrawer(),
           
            AnimatedContainer(
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor)
                ..rotateY(isDrawerOpen ? -0.5 : 0),
              duration: Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: Colors.white,
                //borderRadius: BorderRadius.circular(isDrawerOpen?20:0.0)
              ),
              child: Container(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    SizedBox(
                      height: 25,
                    ),
                   _customAppBar(),
                    Container(
                      height: _height * 0.90,
                      width: _width,
                      child: Stack(children: [


                        HomeMap(),
                        Positioned(
                          top: 50,
                            child: Container(
                              width: _width,
                              child: CustomTextFormField1(
                                hintTxt: _authProvider.currentLang=="ar"?"ابحث باسم الورشة...":"Search by workshop name ...",
                                prefixIconIsImage: true,
                                prefixIconImagePath: 'assets/images/search.png',

                                onSubmit: (text) async{
                                  _searchKey = text;
                                  _homeProvider.setEnableSearch(true);
                                  _homeProvider.setSearchKey(text);

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeScreen()));


                                },


                                maxLines: 1,

                              ),
                            ),

                        ),

                        isDrawerOpen
                            ? Container(
                          margin: EdgeInsets.all(0),
                          color: mainAppColor,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios,size: 40,color: Colors.white,),
                            onPressed: () {
                              setState(() {
                                xOffset = 0;
                                yOffset = 0;
                                scaleFactor = 1;
                                isDrawerOpen = false;
                              });
                            },
                          ),
                        ):Text(""),



                        isDrawerOpen
                            ? Positioned(child: Container(
                          margin: EdgeInsets.all(0),
                          color: mainAppColor,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios,size: 40,color: Colors.white,),
                            onPressed: () {
                              setState(() {
                                xOffset = 0;
                                yOffset = 0;
                                scaleFactor = 1;
                                isDrawerOpen = false;
                              });
                            },
                          ),
                        ),
                          bottom: 70,
                        ):Text(""),


                      ]),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
}