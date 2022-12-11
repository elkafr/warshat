import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/custom_widgets/buttons/custom_button.dart';
import 'package:warshat/custom_widgets/custom_selector/custom_selector.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:warshat/custom_widgets/dialogs/confirmation_dialog.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/custom_widgets/dialogs/location_dialog.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/providers/location_state.dart';
import 'package:warshat/providers/progress_indicator_state.dart';
import 'package:warshat/providers/register_provider.dart';
import 'package:warshat/ui/auth/widgets/select_country_bottom_sheet.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/utils/commons.dart';
import 'package:warshat/utils/urls.dart';
import 'package:provider/provider.dart';
import 'package:warshat/ui/account/terms_and_rules_Screen.dart';
import 'package:warshat/models/category.dart';
import 'package:geolocator/geolocator.dart';
import 'package:warshat/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';

import 'package:location/location.dart';
import 'package:warshat/models/city.dart';
import 'package:warshat/providers/location_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:math' as math;
import 'dart:io';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
  RegisterProvider _registerProvider;
  bool _initalRun = true;
  bool _isLoading = false;
  ApiProvider _apiProvider = ApiProvider();
  HomeProvider _homeProvider = HomeProvider();
  String _userName = '', _userPhone = '', _userWhats = '', _userAbout = '', _userEmail = '', _userPassword = '', _userAdress= '';
  Future<List<CategoryModel>> _categoryList;
  CategoryModel _selectedCategory;
  File _imageFile;
  Future<List<City>> _cityList;
  City _selectedCity;
  dynamic _pickImageError;
  final _picker = ImagePicker();
  List<Asset> images = List<Asset>();
  List files = [];
  List<Asset> resultList;
  String _error;
  List<MultipartFile> listFile = List<MultipartFile>();
  ProgressIndicatorState _progressIndicatorState;

  LocationState _locationState;
  LocationData _locData;


  Map<String, dynamic> params = Map();

  Map<String, dynamic> headers = {
    HttpHeaders.contentTypeHeader: 'multipart/form-data',
  };
  List<MultipartFile> multipart = List<MultipartFile>();

  final imagesBytes = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initalRun) {
      _homeProvider = Provider.of<HomeProvider>(context);


      _categoryList = _homeProvider.getCategoryList(
          categoryModel: CategoryModel(
              isSelected: true,
              catId: '0',
              catName: AppLocalizations.of(context).translate('all'),
              catImage: 'assets/images/all.png'));
      _cityList = _homeProvider.getCityList(enableCountry: true,countryId:'1');
      _progressIndicatorState = Provider.of<ProgressIndicatorState>(context);
      _registerProvider = Provider.of<RegisterProvider>(context);
      _locationState = Provider.of<LocationState>(context);
      _locationState = Provider.of<LocationState>(context);
      _registerProvider.getCountryList();

      _initalRun = false;
    }
  }



  Future<void> _getCurrentUserLocation() async {
    _progressIndicatorState.setIsLoading(true);
    _locData = await Location().getLocation();
    print(_locData.latitude);
    print(_locData.longitude);


      _locationState.setLocationLatitude(double.parse(_homeProvider.latValue));
      _locationState.setLocationlongitude(double.parse(_homeProvider.longValue));
      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
          _locationState.locationLatitude, _locationState
          .locationlongitude);
      _locationState.setCurrentAddress(placemark[0].name + '  ' + placemark[0].administrativeArea + ' '
          + placemark[0].country);
      //  final coordinates = new Coordinates(_locationState.locationLatitude, _locationState
      //  .locationlongitude);
      // var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      // var first = addresses.first;
      _progressIndicatorState.setIsLoading(false);
      // _locationState.setCurrentAddress(first.addressLine);


      // print("${first.featureName} : ${first.addressLine}");
      showDialog(
          barrierDismissible: true,
          context: context,
          builder: (_) {
            return LocationDialog(

            );
          });


  }


  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }

  }


  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 3,

        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }


  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }




  Future<String> getImageFileFromAsset(String path) async {
    final file = File(path).path;
    return file;
  }




  void _settingModalBottomSheet(context){

    params['images']=null;

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


  Widget _buildBodyItem() {

    print(_locationState.locationLatitude.toString());
    final orientation = MediaQuery.of(context).orientation;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(_homeProvider.currentLang=="ar"?"تسجيل حساب ورشة":"Register a workshop account",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
            ),

            Container(
              alignment: Alignment.center,
              child: Text(_homeProvider.currentLang=="ar"?"لتسجيل حساب جديد لابد من ادخال البيانات التالية":"To register a new account, the following data must be entered",style: TextStyle(fontSize: 14,color:hintColor),),
            ),

            SizedBox(
              height: 20,
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
              margin: EdgeInsets.only(bottom: 17,top: 17),
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

            Container(
              margin: EdgeInsets.only(bottom: 17),
              child: CustomTextFormField(
                prefixIconIsImage: true,
                prefixIconImagePath: 'assets/images/whats.png',
                hintTxt: _homeProvider.currentLang=="ar"?"رقم الواتساب":"WhatsApp number",
                validationFunc: validateUserPhone,
                onChangedFunc: (text) {
                  _userWhats = text;
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

            FutureBuilder<List<City>>(
              future: _cityList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.hasData) {
                    var cityList = snapshot.data.map((item) {
                      return new DropdownMenuItem<City>(
                        child: new Text(item.cityName),
                        value: item,
                      );
                    }).toList();
                    return DropDownListSelector(
                      dropDownList: cityList,

                      hint:  AppLocalizations.of(context).translate('choose_city'),
                      onChangeFunc: (newValue) {
                        FocusScope.of(context).requestFocus( FocusNode());
                        setState(() {

                          _selectedCity = newValue;
                          _homeProvider.setSelectedCity(newValue);
                        });
                      },
                      value: _selectedCity,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                } else    if (snapshot.hasError) {
                  DioError error = snapshot.error;
                  String message = error.message;
                  if (error.type == DioErrorType.CONNECT_TIMEOUT)
                    message = 'Connection Timeout';
                  else if (error.type ==
                      DioErrorType.RECEIVE_TIMEOUT)
                    message = 'Receive Timeout';
                  else if (error.type == DioErrorType.RESPONSE)
                    message =
                    '404 server not found ${error.response.statusCode}';
                  print(message);
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),

            SizedBox(height: 18,),
            CustomTextFormField(
              prefixIconIsImage: true,
              prefixIconImagePath: 'assets/images/city.png',
              hintTxt: _homeProvider.currentLang=="ar"?"العنوان":"Adress",
              validationFunc: validateUserName,
              onChangedFunc: (text) {
                _userAdress = text;
              },
            ),


            Container(
              margin: EdgeInsets.only(top: 15,right: 30,left: 30),
              child: Text(_homeProvider.currentLang=="ar"?"اختيار أقسام الورشة":"Selection of workshop sections",style: TextStyle(fontSize: 16),),
            ),


            Container(
                height: _height * 0.18,
                color: Color(0xffF8F8F8),
                margin: EdgeInsets.only(left: 20,right: 20),
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: FutureBuilder<List<CategoryModel>>(
                    future: _categoryList,
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
                            return Text("حدث خطأ ما ");
                          } else {
                            if (snapshot.data.length > 0) {
                              return GridView.builder(
                                  shrinkWrap: false,
                                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: MediaQuery.of(context).size.width /
                                        (MediaQuery.of(context).size.height / 5),
                                  ),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Consumer<HomeProvider>(
                                        builder: (context, homeProvider, child) {
                                          return InkWell(


                                            onTap: () {
  

                                              if(_homeProvider.catt.contains(snapshot.data[index].catId.toString())){

                                                homeProvider
                                                    .setCatt(_homeProvider.catt.replaceAll(snapshot.data[index].catId.toString()+",",""));
                                              }else{
                                              homeProvider
                                                  .setCatt(_homeProvider.catt+snapshot.data[index].catId.toString()+",");
                                              }


                                                print(_homeProvider.catt);

                                            },

                                            child: Container(
                                              alignment: Alignment.center,

                                              margin: EdgeInsets.all(5),

                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                border: Border.all(
                                                  color: mainAppColor,
                                                ),
                                                color: (_homeProvider.catt.contains(snapshot.data[index].catId.toString()))?mainAppColor:Colors.white,

                                              ),


                                              child: Text(snapshot.data[index].catName,style: TextStyle(color: (_homeProvider.catt.contains(snapshot.data[index].catId.toString()))?Colors.white:mainAppColor),),
                                            ),
                                          );
                                        });
                                  });
                            } else {
                              return Text("لاتوجد نتائج");
                            }
                          }
                      }
                      return Center(
                        child: SpinKitFadingCircle(color: mainAppColor),
                      );
                    })),


            Container(
              margin: EdgeInsets.only(top: 15,right: 30,left: 30),
              child: Text(_homeProvider.currentLang=="ar"?"لوجو الورشة":"Logo workshop",style: TextStyle(fontSize: 16),),
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
              margin: EdgeInsets.only(top: 15,right: 30,left: 30),
              child: Text(_homeProvider.currentLang=="ar"?"صور الورشة":"Workshop photos",style: TextStyle(fontSize: 16),),
            ),



            Container(
              margin: EdgeInsets.only(right: 30,left: 30,top: 5,bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                  color: hintColor.withOpacity(0.4),
                ),
                color: Color(0xffF8F8F8),


              ),

             child: ListTile(
               leading: Image.asset('assets/images/camera1.png'),
               title: Text(_homeProvider.currentLang=="ar"?"يمكن التحميل أكثر من صورة":"You can upload more than one image",style: TextStyle(color: hintColor),),
               trailing: Icon(Icons.attachment),
               onTap: loadAssets,
             ),
              
            ),

              SizedBox(height: 10,),
            /* (images != null)?Container(
              margin: EdgeInsets.all(20),
              height: 150,
              child: buildGridView(),
            ):Container(),  */


            CustomTextFormField(
              prefixIconIsImage: true,
              maxLines: 4,
              prefixIconImagePath: 'assets/images/type.png',
              hintTxt: _homeProvider.currentLang=="ar"?"نبذة عن الورشة":"About the workshop",
              validationFunc: validateUserName,
              onChangedFunc: (text) {
                _userAbout = text;
              },
            ),


            SizedBox(height: 17,),


            GestureDetector(
              onTap: (){

                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (_) {
                      return LocationDialog(

                      );
                    });
              },
              child: Container(
                alignment: Alignment.center,

                width: _width * 0.60,
                margin: EdgeInsets.only(right: _width * 0.20),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: mainAppColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.00),
                    ),
                    border: Border.all(color: mainAppColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 5,right: 5),
                      child: Icon(Icons.map,color: Colors.white,),
                    ),
                    Text(
                      _homeProvider.currentLang=="ar"?"موقع الورشة على الخريطة":"The location of the workshop on the map",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    )
                  ],
                ),
              ),
            ),

            SizedBox(height: 17,),
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
                                        color: Color(0xffA8C21C))),
                              ],
                            ),
                          ),
                        )),
                  ],
                )),



           _isLoading
      ? Center(
      child:SpinKitFadingCircle(color: mainAppColor),
    ):CustomButton(
              btnLbl: AppLocalizations.of(context).translate('make_account'),
              btnColor: mainAppColor,
              onPressedFunction: () async {


           
                if (_formKey.currentState.validate()) {

                    if (_registerProvider.acceptTerms) {
                      setState(() {
                        _isLoading = true;
                      });






                      String fileName = (_imageFile!=null)?Path.basename(_imageFile.path):"";








                      for (Asset a in images) {
                        final bytes = await a.getByteData();
                        imagesBytes[a.identifier] = bytes.buffer.asUint8List();
                      }
                      final imagesData = images.map((a) => MultipartFile.fromBytes(imagesBytes[a.identifier], filename: a.name)).toList();



                      FormData formData = new FormData.fromMap({
                        "user_name":_userName,
                        "user_phone": _userPhone,
                        "user_whats": _userWhats,
                        "user_about": _userAbout,
                        "user_cat": _homeProvider.catt,
                        "user_type": "2",
                        "user_pass": _userPassword,
                        "user_pass_confirm":_userPassword,
                        "user_email":_userEmail,
                        "user_city": _selectedCity.cityId,
                        "user_adress":_userAdress,
                        "user_location":(_locationState.locationLatitude.toString()!=null?_locationState.locationLatitude.toString():_homeProvider.latValue)+","+(_locationState.locationlongitude.toString()!=null?_locationState.locationlongitude.toString():_homeProvider.longValue),
                        "imgURL":_imageFile!=null?await MultipartFile.fromFile(_imageFile.path, filename: fileName):"",
                        "imgURL1":imagesData
                      });

                      final results =
                          await _apiProvider.postWithDio(Urls.REGISTER_URL, body: formData);

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



            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: _height * 0.02),
                child: Text(
                  AppLocalizations.of(context).translate('has_account'),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                )),
            CustomButton(
              btnLbl: AppLocalizations.of(context).translate('login'),
              btnColor: Colors.white,
              btnStyle: TextStyle(color: mainAppColor),
              onPressedFunction: (){
                Navigator.pushNamed(
                    context, '/loginc_screen');
              },
            ),
          ],
        ),
      ),
    );
  }

  _register() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return ConfirmationDialog(
            title:  _homeProvider.currentLang=="ar"?"تم ارسال طلب التسجيل بنجاح للادارة":"Successful registration request has been sent to the administration",
            message:  _homeProvider.currentLang=="ar"?"سيتم مراجعة البيانات اولا من قبل الادارة ومن ثم تقوم بتفعيل الطلب ":"The data will be reviewed first by the administration, and then the application will be activated",
          );
        });

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/loginc_screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;




    final appBar = AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      leading:    GestureDetector(
        child: Icon(Icons.arrow_back,color: Colors.black,size: 35,),
        onTap: (){
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title:Image.asset(
        'assets/images/logo.png',
      ),



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
