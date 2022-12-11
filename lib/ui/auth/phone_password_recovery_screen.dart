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
class PhonePasswordRecoveryScreen extends StatefulWidget {
  @override
  _PhonePasswordRecoveryScreenState createState() => _PhonePasswordRecoveryScreenState();
}

class _PhonePasswordRecoveryScreenState extends 
State<PhonePasswordRecoveryScreen>  with ValidationMixin{
 double _height = 0 , _width = 0;
 ApiProvider _apiProvider = ApiProvider();
 AuthProvider _authProvider;
 bool _isLoading = false;
 String _userPhone ='';
 final _formKey = GlobalKey<FormState>();

Widget _buildBodyItem(){
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
             margin: EdgeInsets.only(top: _height *0.05),
             child:  Image.asset('assets/images/logo.png',height:_height *0.2 ,),
           ),

         Container(
           margin: EdgeInsets.only(
             bottom: _height * 0.02
           ),
           
           child: Text(  AppLocalizations.of(context).translate('enter_phone_no_to_send_code_to_recovery_password'),style: TextStyle(
             color: Color(0xffC5C5C5),fontSize: 14
           ),),
         ),
          CustomTextFormField(
                prefixIconIsImage: true,
                prefixIconImagePath: 'assets/images/fullcall.png',
                hintTxt: AppLocalizations.of(context).translate('phone_no'),
                onChangedFunc: (text){
                  _userPhone = text;
                },
                   validationFunc: validateUserPhone
              ),
          
           SizedBox(
             height: _height *0.02,
           ),
          _buildRetrievalCodeBtn()
          
          
         
        
       
        ],
      ),
    ),
  );
}


 Widget _buildRetrievalCodeBtn() {
    return _isLoading
        ? Center(
            child:SpinKitFadingCircle(color: mainAppColor),
          )
        :  CustomButton(
           btnLbl: AppLocalizations.of(context).translate('send_recovery_code'),
           onPressedFunction: () async {
              
             if(_formKey.currentState.validate()){
                 setState(() {
                    _isLoading = true;
                  });
                 final results = await _apiProvider
                      .post(Urls.PASSSWORD_RECOVERY_URL +"?api_lang=${_authProvider.currentLang}", body: {
                    "user_phone":  _userPhone,
               
                   
                  });
               
            setState(() => _isLoading = false);
                  if (results['response'] == "1") {
   Commons.showToast(context, message: _authProvider.currentLang=="ar"?"تم ارسل كلمة مرور مؤقتة على ايميلك":"A temporary password has been sent to your email");
_authProvider.setUserPhone(_userPhone);
                      Navigator.pushNamed(context,   '/code_activation_screen');
                      
                  } else {
                    Commons.showError(context, results["message"]);
                
                  }
         
             } 
           },
         );
         }
  @override
  Widget build(BuildContext context) {
         _height =  MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
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