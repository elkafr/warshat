import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/custom_widgets/buttons/custom_button.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/utils/commons.dart';
import 'package:warshat/utils/urls.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class NewPasswordScreen extends StatefulWidget {
  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen>
    with ValidationMixin {
  double _height = 0, _width = 0;
  String _password = '';
  ApiProvider _apiProvider = ApiProvider();
  AuthProvider _authProvider;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Widget _buildBodyItem() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: _height * 0.05),
              child: Image.asset(
                'assets/images/full_key.png',
                height: _height * 0.2,
              ),
            ),

            Text( AppLocalizations.of(context).translate('password_recovery'),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.only(bottom: _height * 0.02),
              child: Text(
                AppLocalizations.of(context).translate('enter_new_password'),
                style: TextStyle(color: Color(0xffC5C5C5), fontSize: 14),
              ),
            ),
            CustomTextFormField(
                isPassword: true,
                prefixIconIsImage: true,
                onChangedFunc: (String text) {
                  _password = text;
                },
                prefixIconImagePath: 'assets/images/key.png',
                hintTxt:  AppLocalizations.of(context).translate('new_password'),
                validationFunc: validatePassword),
            SizedBox(
              height: _height * 0.02,
            ),
            CustomTextFormField(
                isPassword: true,
                prefixIconIsImage: true,
                prefixIconImagePath: 'assets/images/key.png',
                hintTxt : AppLocalizations.of(context).translate('confirm_new_password'),
                validationFunc: validateConfirmPassword),
            SizedBox(
              height: _height * 0.02,
            ),
            _buildConfirmBtn()
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmBtn() {
    return _isLoading
        ? Center(
            child: SpinKitFadingCircle(color: mainAppColor),
          )
        : CustomButton(
            btnLbl: AppLocalizations.of(context).translate('confirm'),
      btnColor: mainAppColor,
            onPressedFunction: () async {
              if (_formKey.currentState.validate()) {
                setState(() {
                  _isLoading = true;
                });
                final results = await _apiProvider
                    .post(Urls.UPDATE_PASSWORD_URL +"?api_lang=${_authProvider.currentLang}", body: {
                  "code": _authProvider.activationCode,
                  "password": _password
                });

                setState(() => _isLoading = false);
                if (results['response'] == "1") {
                  Commons.showToast(context,
                      message: results["message"], color: mainAppColor);
                  Navigator.pushNamed(context, '/login_screen');
                } else {
                  Commons.showError(context, results["message"]);
                }
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);



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
      title: Text(AppLocalizations.of(context).translate('password_recovery'),style: TextStyle(fontSize: 18,color: Colors.black),),



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
