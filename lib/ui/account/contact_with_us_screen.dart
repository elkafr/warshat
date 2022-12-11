import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/custom_widgets/buttons/custom_button.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/ui/home/home_screen.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/utils/commons.dart';
import 'package:warshat/utils/urls.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class ContactWithUsScreen extends StatefulWidget {
  @override
  _ContactWithUsScreenState createState() => _ContactWithUsScreenState();
}

class _ContactWithUsScreenState extends State<ContactWithUsScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
   ApiProvider _apiProvider = ApiProvider();
 bool _isLoading = false;
bool _initialRun = true;
AuthProvider _authProvider;
 String _userName ='' ,_userEmail ='',_userPhone ='' , _message ='';

  Widget _buildBodyItem() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Container(
              alignment: Alignment.center,
              child:  Image.asset('assets/images/logo.png'),
            ),

            SizedBox(
              height: 30,
            ),
            Container(
                margin: EdgeInsets.only(top: _height * 0.02),
                child: CustomTextFormField(

                  prefixIconIsImage: true,
                  onChangedFunc: (text){
                    _userName = text;
                  },
                  prefixIconImagePath: 'assets/images/user.png',
                  hintTxt: AppLocalizations.of(context).translate('user_name'),
                  validationFunc: validateUserName
                
                )),


            Container(
                margin: EdgeInsets.only(top: _height * 0.02),
                child: CustomTextFormField(

                    prefixIconIsImage: true,
                    onChangedFunc: (text){
                      _userPhone = text;
                    },
                    prefixIconImagePath: 'assets/images/fullcall.png',
                    hintTxt: _authProvider.currentLang=="ar"?"رقم الهاتف":"phone number",
                    validationFunc: validateUserPhone

                )),


            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(

                prefixIconIsImage: true,
                onChangedFunc: (text){
                  _userEmail = text;
                },
                prefixIconImagePath: 'assets/images/mail.png',
                hintTxt: AppLocalizations.of(context).translate('email'),

              ),
            ),
            CustomTextFormField(
              maxLines: 3,
              onChangedFunc: (text){
                _message = text;
              },
              hintTxt: AppLocalizations.of(context).translate('message'),
              validationFunc:  validateMsg,
            ),
            Container(
              margin: EdgeInsets.only(top: _height *0.02,bottom: _height *0.02),
              child: _buildSendBtn()
            ),
 /* Container(
              margin: EdgeInsets.symmetric(
                  horizontal: _width * 0.1, vertical: _height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        // _launchURL(_twitterUrl);
                      },
                      child: Image.asset(
                        'assets/images/twitter.png',
                        height: 40,
                        width: 40,
                      )),
                  GestureDetector(
                      onTap: () {
                        // _launchURL(_linkedinUrl);
                      },
                      child: Image.asset(
                        'assets/images/linkedin.png',
                        height: 40,
                        width: 40,
                      )),
                  GestureDetector(
                      onTap: () {
                        // _launchURL(_instragramUrl);
                      },
                      child: Image.asset(
                        'assets/images/instagram.png',
                        height: 40,
                        width: 40,
                      )),
                  GestureDetector(
                      onTap: () {
                        // _launchURL(_facebookUrl);
                      },
                      child: Image.asset(
                        'assets/images/facebook.png',
                        height: 40,
                        width: 40,
                      )),
                ],
              ),
            ),

            */

















          ],
        ),
      ),
    );
  }

Widget _buildSendBtn() {
    return _isLoading
        ? Center(
            child:SpinKitFadingCircle(color: mainAppColor),
          )
        : CustomButton(
              btnLbl: AppLocalizations.of(context).translate('send'),
             btnColor: mainAppColor,
              onPressedFunction: () async {
                if (_formKey.currentState.validate()) {

                  setState(() {
                    _isLoading = true;
                  });
                 final results = await _apiProvider
                      .post(Urls.CONTACT_URL + "?api_lang=${_authProvider.currentLang}", body: {
                    "msg_name":  _userName,
                    "msg_email": _userEmail,
                    "msg_phone": _userPhone,
                    "msg_details":_message

                  });
               
            setState(() => _isLoading = false);
                  if (results['response'] == "1") {
                    Commons.showToast(context, message:results["message"]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen()));

                      
                  } else {
                    Commons.showError(context, results["message"]);

                  }
                   
                }
              },
            );
  }

 



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _authProvider = Provider.of<AuthProvider>(context);

     _initialRun = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
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
      title: Text(AppLocalizations.of(context).translate('contact_us'),style: TextStyle(fontSize: 18,color: Colors.black),),



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
