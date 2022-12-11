import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/custom_widgets/buttons/custom_button.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/models/user.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/shared_preferences/shared_preferences_helper.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/utils/commons.dart';
import 'package:warshat/utils/urls.dart';
import 'package:provider/provider.dart';
import 'package:warshat/ui/home/home_screen.dart';
import 'package:warshat/shared_preferences/shared_preferences_helper.dart';
import 'package:warshat/shared_preferences/shared_preferences_helper.dart';
import 'package:warshat/providers/register_provider.dart';
import 'package:warshat/ui/package/package_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/custom_widgets/buttons/custom_button.dart';
import 'package:warshat/custom_widgets/custom_selector/custom_selector.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:warshat/custom_widgets/dialogs/confirmation_dialog.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/register_provider.dart';
import 'package:warshat/ui/auth/widgets/select_country_bottom_sheet.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/utils/commons.dart';
import 'package:warshat/utils/urls.dart';
import 'package:provider/provider.dart';
import 'package:warshat/ui/account/terms_and_rules_Screen.dart';
import 'dart:math' as math;

import 'dart:math' as math;
class LoginCScreen extends StatefulWidget {
  @override
  _LoginCScreenState createState() => _LoginCScreenState();
}

class _LoginCScreenState extends State<LoginCScreen> with ValidationMixin{
  double _height = 0 , _width = 0;
  final _formKey = GlobalKey<FormState>();
  AuthProvider _authProvider;
  HomeProvider _homeProvider;
  ApiProvider _apiProvider = ApiProvider();
  bool _isLoading = false;
  String _userPhone ='' ,_userPassword ='';
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool checkedValue=false;




  RegisterProvider _registerProvider;
  bool _initalRun = true;
  String _userName = '', _userEmail = '';


  Widget _buildBodyItem(){
    return SingleChildScrollView(
      child:    Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,

            child:  Image.asset('assets/images/logo.png',height:100 ,),
          ),
          DefaultTabController(
              length: 2, // length of tabs
              initialIndex: int.parse(_homeProvider.loginValue),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                Container(
                  child: TabBar(
                    labelColor: mainAppColor,

                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(text: _homeProvider.currentLang=="ar"?'تسجيل الدخول':'Sign in'),
                      Tab(text: _homeProvider.currentLang=="ar"?'حساب جديد':'New account'),
                    ],
                  ),
                ),
                Container(
                    height: _height, //height of TabBarView
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: mainAppColor, width: 0.5))
                    ),
                    child: TabBarView(children: <Widget>[
                      Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              AnimatedContainer(
                              padding: EdgeInsets.only(top: 40),
                              alignment: Alignment.center,

                                duration: const Duration(seconds: 10),
                                curve: Curves.fastOutSlowIn,

                              child:  Text(_homeProvider.currentLang=="ar"?"مرحباً بك":"Welcome",style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold,color: Colors.black),),
                            ),

                              Container(
                                padding: EdgeInsets.only(top: 5),
                                alignment: Alignment.center,
                                child:  Text(_homeProvider.currentLang=="ar"?"سجل دخولك للاستفادة من خدمات التطبيق":"Sign in to take advantage of the application's services",style: TextStyle(fontSize: 14,color: hintColor),),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: _height *0.02
                                ),
                                child: CustomTextFormField(
                                  onChangedFunc: (text){
                                    _userPhone = text;
                                  },

                                  prefixIconIsImage: true,
                                  prefixIconImagePath: 'assets/images/user.png',

                                  hintTxt:  AppLocalizations.of(context).translate('phone_no'),
                                  validationFunc: validateUserPhone,
                                ),
                              ),



                              CustomTextFormField(
                                isPassword: true,
                                prefixIconIsImage: true,
                                onChangedFunc: (text){
                                  _userPassword =text;
                                },
                                prefixIconImagePath: 'assets/images/key.png',
                                hintTxt: AppLocalizations.of(context).translate('password'),
                                validationFunc: validatePassword,
                              ),

                              Container(
                                alignment: Alignment.centerRight,

                                child: CheckboxListTile(

                                  checkColor: Colors.white,
                                  activeColor: mainAppColor,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  title: Text(_homeProvider.currentLang=="ar"?"تذكرنى ؟":"Remember me ?",style: TextStyle(fontSize: 15),),
                                  value: checkedValue,
                                  onChanged: (newValue) {
                                    SharedPreferencesHelper.save(
                                        "checkUser", newValue);
                                    setState(() {
                                      checkedValue = newValue;
                                      _homeProvider.setCheckedValue(newValue.toString());
                                      print(_homeProvider.checkedValue);

                                    });
                                  },

                                ),
                              ),


                              SizedBox(height: 10,),
                              _buildLoginBtn(),

                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: _width * 0.07,vertical: _height * 0.01),
                                child: GestureDetector(
                                  onTap: ()=> Navigator.pushNamed(context,  '/phone_password_reccovery_screen' ),
                                  child: RichText(

                                    text: TextSpan(
                                      style: TextStyle(
                                        color:Colors.black , fontSize: 14, fontFamily: 'Cairo',),
                                      children: <TextSpan>[
                                        TextSpan(text:  AppLocalizations.of(context).translate('forget_password')),
                                        TextSpan(
                                          text:  AppLocalizations.of(context).translate('click_her'),
                                          style: TextStyle(
                                              color: Color(0xffA8C21C),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              decoration: TextDecoration.underline,
                                              fontFamily: 'Cairo'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              ,








                              CustomButton(
                                btnLbl: _homeProvider.currentLang=="ar"?"تخطي كزائر":"Skip as a visitor",
                                btnColor: Colors.white,
                                btnStyle: TextStyle(
                                    color: Colors.black
                                ),
                                onPressedFunction: (){
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeScreen()));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 30,bottom: 30),
                                alignment: Alignment.center,
                                child:  Text(_homeProvider.currentLang=="ar"?"لتسجيل حساب جديد لابد من ادخال البيانات التالية":"To register a new account, the following data must be entered",style: TextStyle(fontSize: 14,color: hintColor),),
                              ),

                              CustomTextFormField(
                                prefixIconIsImage: true,
                                prefixIconImagePath: 'assets/images/user.png',
                                hintTxt: AppLocalizations.of(context).translate('user_name'),
                                validationFunc: validateUserName,
                                onChangedFunc: (text) {
                                  _userName = text;
                                },
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: _height * 0.02),
                                child: CustomTextFormField(
                                  prefixIconIsImage: true,
                                  prefixIconImagePath: 'assets/images/fullcall.png',
                                  hintTxt: AppLocalizations.of(context).translate('phone_no'),
                                  validationFunc: validateUserPhone,
                                  onChangedFunc: (text) {
                                    _userPhone = text;
                                  },
                                ),
                              ),
                              CustomTextFormField(
                                prefixIconIsImage: true,
                                prefixIconImagePath: 'assets/images/mail.png',
                                hintTxt:AppLocalizations.of(context).translate('email'),


                                onChangedFunc: (text) {
                                  _userEmail = text;
                                },
                              ),


                              SizedBox(height: 18,),
                              Container(
                                margin: EdgeInsets.only(bottom: _height * 0.02),
                                child: CustomTextFormField(
                                  isPassword: true,
                                  prefixIconIsImage: true,
                                  prefixIconImagePath: 'assets/images/key.png',
                                  hintTxt: AppLocalizations.of(context).translate('password'),
                                  validationFunc: validatePassword,
                                  onChangedFunc: (text) {
                                    _userPassword = text;
                                  },
                                ),
                              ),
                              CustomTextFormField(
                                isPassword: true,
                                prefixIconIsImage: true,
                                prefixIconImagePath: 'assets/images/key.png',
                                hintTxt:  AppLocalizations.of(context).translate('confirm_password'),
                                validationFunc: validateConfirmPassword,
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: _height * 0.01, horizontal: _width * 0.07),
                                  child: Row(
                                    children: <Widget>[
                                      Consumer<RegisterProvider>(
                                          builder: (context, registerProvider, child) {
                                            return GestureDetector(
                                              onTap: () => registerProvider
                                                  .setAcceptTerms(!registerProvider.acceptTerms),
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                child: registerProvider.acceptTerms
                                                    ? Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 17,
                                                )
                                                    : Container(),
                                                decoration: BoxDecoration(
                                                  color: registerProvider.acceptTerms
                                                      ? Color(0xffA8C21C)
                                                      : Colors.white,
                                                  border: Border.all(
                                                    color: registerProvider.acceptTerms
                                                        ? Color(0xffA8C21C)
                                                        : hintColor,
                                                  ),
                                                  borderRadius: BorderRadius.circular(25.0),
                                                ),
                                              ),
                                            );
                                          }),
                                      Container(
                                          margin: EdgeInsets.symmetric(horizontal: _width * 0.02),
                                          child: GestureDetector(
                                            onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => TermsAndRulesScreen()));
                                            },
                                            child: RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Cairo',
                                                    color: Colors.black),
                                                children: <TextSpan>[
                                                  TextSpan(text:  AppLocalizations.of(context).translate('accept_to_all')),
                                                  TextSpan(text: ' '),
                                                  TextSpan(
                                                      text: AppLocalizations.of(context).translate('rules_and_terms'),
                                                      style:  TextStyle(
                                                          decoration: TextDecoration.underline,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14,
                                                          fontFamily: 'Cairo',
                                                          color: mainAppColor)),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ],
                                  )),
                              CustomButton(
                                btnLbl: AppLocalizations.of(context).translate('make_account'),
                                btnColor: mainAppColor,
                                onPressedFunction: () async {

                                  if (_formKey.currentState.validate()) {

                                      if (_registerProvider.acceptTerms!=null) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        final results =
                                        await _apiProvider.post(Urls.REGISTER_URL, body: {
                                          "user_name":_userName,
                                          "user_phone": _userPhone,
                                          "user_pass": _userPassword,
                                          "user_pass_confirm":_userPassword,
                                          "user_type": "1",
                                          "user_email":_userEmail
                                        });

                                        setState(() => _isLoading = false);
                                        if (results['response'] == "1") {
                                          _register();
                                        } else {
                                          Commons.showError(context, results["message"]);
                                        }
                                      } else {
                                        Commons.showToast(context,
                                            message:  AppLocalizations.of(context).translate('accept_rules_and_terms'),color: Colors.red);
                                      }


                                  }
                                },
                              ),


                              CustomButton(
                                btnLbl: _homeProvider.currentLang=="ar"?"تسجيل حساب ورشة":"Register a workshop account",
                                btnColor: Colors.white,
                                btnStyle: TextStyle(color: Colors.black),
                                onPressedFunction: (){
                                  Navigator.pushNamed(
                                      context, '/register_screen');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),



                    ])
                )
              ])
          )
        ],
      ),
    );
  }


  _register() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return ConfirmationDialog(
            title:  AppLocalizations.of(context).translate('account_has created_successfully'),
            message:  AppLocalizations.of(context).translate('account_has created_successfully_use_app_now'),
          );
        });

    Future.delayed(const Duration(seconds: 2), () {

      Navigator.pop(context);
      Navigator.pushNamed(context, '/loginc_screen');
    });
  }

  Widget _buildLoginBtn() {
    return _isLoading
        ? Center(
      child:SpinKitFadingCircle(color: mainAppColor),
    )
        : CustomButton(
      btnLbl:  AppLocalizations.of(context).translate('login'),
      btnColor: mainAppColor,
      onPressedFunction: () async {

        if (_formKey.currentState.validate()) {
          _firebaseMessaging.getToken().then((token) async {
            print('token: $token');

            setState(() {
              _isLoading = true;
            });
            final results = await _apiProvider
                .post(Urls.LOGIN_URL +"?api_lang=${_authProvider.currentLang}", body: {
              "user_phone":  _userPhone,
              "user_pass": _userPassword,
              "token":token

            });

            setState(() => _isLoading = false);
            if (results['response'] == "1") {
              _login(results);

            } else {
              Commons.showError(context, results["message"]);

            }
          });

        }
      },
    );
  }

  _login(Map<String,dynamic> results) {
    _authProvider.setCurrentUser(User.fromJson(results["user_details"]));
    SharedPreferencesHelper.save("user", _authProvider.currentUser);
    _authProvider.currentUser.userActive=="4"?Commons.showToast(context,
      message:"عفوا لقد انتهت مدة اشتراككم وتم خفاء ظهور الورشة للمستخدمين لحين تجديد الاشتراك واختيار باقة من هذه الصفحة", color: Colors.red,):Commons.showToast( context,message:results["message"] ,color:  mainAppColor);
    _authProvider.currentUser.userActive=="4"?Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PackageScreen())):Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen()));
  }


  @override
  Widget build(BuildContext context) {
    _height =  MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    _homeProvider = Provider.of<HomeProvider>(context);
    _registerProvider = Provider.of<RegisterProvider>(context);
    return PageContainer(
      child: Scaffold(
          body: Stack(
            children: <Widget>[

              _buildBodyItem(),





            ],
          )
      ),
    );
  }
}