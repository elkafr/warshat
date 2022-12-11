import 'package:flutter/cupertino.dart';
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
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/providers/commission_app_provider.dart';
import 'package:warshat/models/commission_app.dart';
import 'package:warshat/utils/error.dart';
import 'dart:math' as math;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:math' as math;
import 'dart:io';
import 'package:image_picker/image_picker.dart';












import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class PayCommissionScreen extends StatefulWidget {
  @override
  _PayCommissionScreenState createState() => _PayCommissionScreenState();
}

class _PayCommissionScreenState extends State<PayCommissionScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
  ApiProvider _apiProvider = ApiProvider();
  bool _isLoading = false;
  bool _initialRun = true;
  AuthProvider _authProvider;
  String _commitionV1 ='' ,_commitionV2 ='' , _commitionV3 ='', _commitionV4 ='', _commitionV5 ='', _commitionV6 ='', _commitionV7 ='';
  HomeProvider _homeProvider;
  CommisssionAppProvider _commisssionAppProvider;
  Future<CommissionApp> _commissionApp;
  File _imageFile;
  dynamic _pickImageError;
  final _picker = ImagePicker();


  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }

  }


  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.subject),
                    title: new Text('Gallery'),
                    onTap: (){
                      _onImageButtonPressed(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: (){
                      _onImageButtonPressed(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          );
        }
    );
  }



  Widget _buildRow(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Color(0xffABABAB), fontSize: 15, fontWeight: FontWeight.w400),
          ),
          Container(
            width:  _width *0.55,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,fontSize: 18, fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBodyItem() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 0,
            ),

Container(
  height: 200,
  child: FutureBuilder<CommissionApp>(
      future: _commissionApp,
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
                errorMessage:AppLocalizations.of(context).translate('error'),
              );
            } else {
              return  Container(
                child: ListView.builder(
                    itemCount: snapshot.data.banks.length,
                    itemBuilder: (context, index) {
                      return Container(
                        
                        margin: EdgeInsets.only(top: 0, left: 0, right: 0),
                        decoration: BoxDecoration(


                            color: Color(0xffEBEBEB),
                          ),
                        height: 175,
                        child: Column(
                          children: <Widget>[

                              Padding(padding: EdgeInsets.all(5)),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 0),
                              child: _buildRow(
                                  _homeProvider.currentLang=="ar"?'اسم البنك   :   ':' Bank Name :   ',
                                  snapshot.data.banks[index].bankTitle),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: _buildRow(
                                  '${AppLocalizations.of(context).translate('account_owner')}   :   ',
                                  snapshot.data.banks[index].bankName),
                            ),
                            _buildRow(
                                '${AppLocalizations.of(context).translate('account_number')} :   ',
                                snapshot.data.banks[index].bankAcount),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: _buildRow(
                                  '${AppLocalizations.of(context).translate('iban_number')}  :   ',
                                  snapshot.data.banks[index].bankIban),
                            )
                          ],
                        ),
                      );
                    }),
              );
            }
        }
        return Center(
          child: SpinKitFadingCircle(color: mainAppColor),
        );
      }),
),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _homeProvider.currentLang=="ar"?Padding(padding: EdgeInsets.only(right: 30,bottom: 5),child: Text(_homeProvider.currentLang=="ar"?"أسم البنك المحول منه":"name bank transferred"),):Padding(padding: EdgeInsets.only(left: 30,bottom: 5),child: Text(_homeProvider.currentLang=="ar"?"أسم البنك المحول منه":"name bank transferred"),),
                CustomTextFormField(

                    prefixIconIsImage: false,
                    onChangedFunc: (text){
                      _commitionV1 = text;
                    },
                    validationFunc: validateUserName

                )
              ],
            ),


            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _homeProvider.currentLang=="ar"?Padding(padding: EdgeInsets.only(right: 30,bottom: 5,top: 10),child: Text(_homeProvider.currentLang=="ar"?"رقم الحساب":"account number"),):Padding(padding: EdgeInsets.only(left: 30,bottom: 5,top: 10),child: Text(_homeProvider.currentLang=="ar"?"رقم الحساب":"account number"),),
                Container(

                    child: CustomTextFormField(

                        prefixIconIsImage: false,
                        onChangedFunc: (text){
                          _commitionV2 = text;
                        },
                        validationFunc: validateUserName

                    ))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _homeProvider.currentLang=="ar"?Padding(padding: EdgeInsets.only(right: 30,bottom: 5,top: 10),child: Text(_homeProvider.currentLang=="ar"?"اسم صاحب الحوالة":"Transfer name"),):Padding(padding: EdgeInsets.only(left: 30,bottom: 5,top: 10),child: Text(_homeProvider.currentLang=="ar"?"اسم صاحب الحوالة":"Transfer name"),),
                Container(


                    child: CustomTextFormField(

                        prefixIconIsImage: false,
                        onChangedFunc: (text){
                          _commitionV3 = text;
                        },
                        validationFunc: validateUserName

                    ))
              ],
            ),




            Container(
              margin: EdgeInsets.only(top: 15,right: 30,left: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                border: Border.all(
                  color: hintColor.withOpacity(0.4),
                ),
                color: Colors.white,

              ),

              child:    GestureDetector(


                  onTap: (){
                    _settingModalBottomSheet(context);
                  },
                  child: Container(
                    height: _height * 0.1,
                    width: _width*.22,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      border: Border.all(
                        color: hintColor.withOpacity(0.4),
                      ),
                      color: Colors.grey[100],

                    ),
                    child: _imageFile != null
                        ?ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child:  Image.file(
                          _imageFile,
                          // fit: BoxFit.fill,
                        ))
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/images/add.png'),

                      ],
                    ),
                  )),

            ),

            Container(
                margin: EdgeInsets.only(top: _height *0.02,bottom: _height *0.02),
                child: _buildSendBtn()
            ),

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
      btnLbl: _homeProvider.currentLang=="ar"?"التاكيد والدفع":"Confirmation",
      onPressedFunction: () async {
        if (_formKey.currentState.validate()) {

          setState(() {
            _isLoading = true;
          });

          String fileName = (_imageFile!=null)?Path.basename(_imageFile.path):"";


          FormData formData = new FormData.fromMap({
            "commition_v1":  _commitionV1,
            "commition_v2":  _commitionV2,
            "commition_v3":  _commitionV3,
            "commition_v5":  _homeProvider.currentPackageId,
            "commition_v6":  _authProvider.currentUser.userId,
            "imgURL": await MultipartFile.fromFile(_imageFile.path, filename: fileName),
          });




          final results = await _apiProvider
              .postWithDio(Urls.PAY_COMMISSION_URL + "?api_lang=${_authProvider.currentLang}", body: formData);



          setState(() => _isLoading = false);
          if (results['response'] == "1") {
            Commons.showToast(context, message:results["message"]);
            Navigator.pop(context);


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
      _commisssionAppProvider = Provider.of<CommisssionAppProvider>(context);
      _commissionApp = _commisssionAppProvider.getCommissionApp();
      _initialRun = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _homeProvider = Provider.of<HomeProvider>(context);

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
      title: Text(_homeProvider.currentLang=="ar"?"اشتراك الباقة":"Package Subscribe",style: TextStyle(fontSize: 18,color: Colors.black),),

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
