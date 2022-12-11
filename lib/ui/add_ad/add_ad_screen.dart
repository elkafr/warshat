import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/custom_widgets/buttons/custom_button.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:warshat/custom_widgets/dialogs/confirmation_dialog.dart';
import 'package:warshat/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/models/category.dart';
import 'package:warshat/models/city.dart';
import 'package:warshat/models/country.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/providers/navigation_provider.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/utils/commons.dart';
import 'package:warshat/utils/urls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;
import 'dart:math' as math;

class AddAdScreen extends StatefulWidget {
  @override
  _AddAdScreenState createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
  Future<List<Country>> _countryList;
  Future<List<City>> _cityList;
  Future<List<CategoryModel>> _categoryList;
  Country _selectedCountry;
  City _selectedCity;
  CategoryModel _selectedCategory;
  bool _initialRun = true;
  HomeProvider _homeProvider;
  List<String> _genders ;
  File _imageFile;
  File _imageFile1;
  dynamic _pickImageError;
  final _picker = ImagePicker();
  AuthProvider _authProvider;
  ApiProvider _apiProvider =ApiProvider();
  bool _isLoading = false;
  String _adsTitle = '', _adsPrice = '', _adsDescription = '';
  NavigationProvider _navigationProvider;
  LocationData _locData;



  List<String> _adsState;
  String _selectedAdsState;
  String _xx1;

  Future<void> _getCurrentUserLocation() async {
    _locData = await Location().getLocation();
    if(_locData != null){
      print('lat' + _locData.latitude.toString());
      print('longitude' + _locData.longitude.toString());
      Commons.showToast(context, message:
      AppLocalizations.of(context).translate('detect_location'));
      setState(() {

      });
    }
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

  void _onImageButtonPressed1(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile1 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);
      _adsState = _homeProvider.currentLang=="ar"?["جديد", "شبه جديد","مستعمل"]:["new", "Almost new","used"];

      _genders = [AppLocalizations.of(context).translate('male'),
        AppLocalizations.of(context).translate('female'),
        AppLocalizations.of(context).translate('undefined')];

      _categoryList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:false ,catId: '0',catName:
      AppLocalizations.of(context).translate('total'),catImage: 'assets/images/all.png'));
      _countryList = _homeProvider.getCountryList();
      _cityList = _homeProvider.getCityList(enableCountry: true,countryId:'500');
      _initialRun = false;
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


  void _settingModalBottomSheet1(context){
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
                      _onImageButtonPressed1(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: (){
                      _onImageButtonPressed1(ImageSource.camera,
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
    var genders = _genders.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();

    var adsState= _adsState.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();


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
              padding: EdgeInsets.fromLTRB(25,5,25,10),
              child: Text(_homeProvider.currentLang=='ar'?"صور الاعلان":"Ad photos"),
            ),
          Row(
            children: <Widget>[
              Padding(padding:EdgeInsets.fromLTRB(25,5,5,10)),
              GestureDetector(
                  onTap: (){
                    _settingModalBottomSheet(context);
                  },
                  child: Container(
                    height: 100,
                    width: _width*.42,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      border: Border.all(
                        color: hintColor.withOpacity(0.4),
                      ),
                      color: Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          blurRadius: 6,
                        ),
                      ],
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
                        Image.asset('assets/images/newadd.png'),

                      ],
                    ),
                  )),

              Padding(padding: EdgeInsets.all(5)),

              GestureDetector(
                  onTap: (){
                    _settingModalBottomSheet1(context);
                  },
                  child: Container(
                    height: 100,
                    width: _width*.42,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      border: Border.all(
                        color: hintColor.withOpacity(0.4),
                      ),
                      color: Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: _imageFile1 != null
                        ?ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child:  Image.file(
                          _imageFile1,
                          // fit: BoxFit.fill,
                        ))
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/images/newadd.png'),

                      ],
                    ),
                  )),





            ],

          ),
            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(
                hintTxt: AppLocalizations.of(context).translate('ad_title'),
                onChangedFunc: (text) {
                  _adsTitle = text;
                },
                validationFunc: validateAdTitle,
              ),
            ),
            FutureBuilder<List<CategoryModel>>(
              future: _categoryList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.hasData) {
                    var categoryList = snapshot.data.map((item) {
                      return new DropdownMenuItem<CategoryModel>(
                        child: new Text(item.catName),
                        value: item,
                      );
                    }).toList();
                    return DropDownListSelector(
                      dropDownList: categoryList,
                      hint: AppLocalizations.of(context).translate('choose_category'),
                      onChangeFunc: (newValue) {
                        FocusScope.of(context).requestFocus( FocusNode());
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      value: _selectedCategory,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Center(child: CircularProgressIndicator());
              },
            ),

          /*  Container(
              margin: EdgeInsets.only(top: _height * 0.02,bottom: _height * 0.01),
              child: CustomTextFormField(
                hintTxt:  AppLocalizations.of(context).translate('ad_price'),
                onChangedFunc: (text) {
                  _adsPrice = text;
                },
                validationFunc: validateAdPrice,
              ),
            ), */

            Container(
              margin: EdgeInsets.only(top: _height * 0.01,bottom: _height * 0.01),
            ),
            FutureBuilder<List<Country>>(
              future: _countryList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.hasData) {
                    var countryList = snapshot.data.map((item) {
                      return new DropdownMenuItem<Country>(
                        child: new Text(item.countryName),
                        value: item,
                      );
                    }).toList();
                    return DropDownListSelector(
                      dropDownList: countryList,
                      hint:  AppLocalizations.of(context).translate('choose_country'),
                      onChangeFunc: (newValue) {
                        FocusScope.of(context).requestFocus( FocusNode());
                        setState(() {
                          _selectedCountry = newValue;
                          _selectedCity=null;
                          _homeProvider.setSelectedCountry(newValue);
                          _cityList = _homeProvider.getCityList(enableCountry: true,countryId:_homeProvider.selectedCountry.countryId);
                        });
                      },

                      value: _selectedCountry,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
            Container(
              margin: EdgeInsets.only(top: _height * 0.02),
            ),
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

            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: DropDownListSelector(

                dropDownList: adsState,
                hint:  _homeProvider.currentLang=="ar"?"حالة المنتج":"Ads State",
                onChangeFunc: (newValue) {
                  FocusScope.of(context).requestFocus( FocusNode());
                  setState(() {
                    _selectedAdsState= newValue;
                    print(newValue);
                  });
                },
                value: _selectedAdsState,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(
                maxLines: 3,
                hintTxt:  AppLocalizations.of(context).translate('ad_description'),
                validationFunc: validateAdDescription,
                onChangedFunc: (text) {
                  _adsDescription = text;
                },
              ),
            ),


            /* Container(
                width: _locData == null ? _width * 0.5 : _width *0.55,
                child: CustomButton(
                  btnColor: Colors.white,
                  borderColor: accentColor,
                  onPressedFunction: (){
                    _getCurrentUserLocation();

                  },
                  btnStyle: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                  btnLbl: _locData == null ? AppLocalizations.of(context).translate('choose_location') : AppLocalizations.of(context).translate('detect_location'),
                )), */


            CustomButton(
              btnLbl: AppLocalizations.of(context).translate('publish_ad'),
              btnColor: accentColor,
              onPressedFunction: () async {
                if (_formKey.currentState.validate() &
                checkAddAdValidation(context,
                    imgFile: _imageFile,
                    adMainCategory: _selectedCategory,
                    adCity: _selectedCity)) {

                  FocusScope.of(context).requestFocus( FocusNode());
                  setState(() => _isLoading = true);
                  String fileName = (_imageFile!=null)?Path.basename(_imageFile.path):"";
                  String fileName1 = (_imageFile1!=null)?Path.basename(_imageFile1.path):"";



                  if(_selectedAdsState=="جديد"){
                    _xx1="1";
                  }else if(_selectedAdsState=="شبه جديد"){
                    _xx1="2";
                  }else if(_selectedAdsState=="مستعمل"){
                    _xx1="3";
                  }else if(_selectedAdsState=="new"){
                    _xx1="1";
                  }else if(_selectedAdsState=="Almost new"){
                    _xx1="2";
                  }else if(_selectedAdsState=="used"){
                    _xx1="3";
                  }


                  FormData formData = new FormData.fromMap({
                    "user_id": _authProvider.currentUser.userId,
                    "ads_title": _adsTitle,
                    "ads_details": _adsDescription,
                    "ads_cat": _selectedCategory.catId,
                    "ads_country": _selectedCountry.countryId,
                    "ads_city": _selectedCity.cityId,
                    "ads_state": _xx1,
                    //"ads_location":'${_locData.latitude},${_locData.longitude}',
                    "imgURL[0]": (_imageFile!=null)?await MultipartFile.fromFile(_imageFile.path, filename: fileName):"",
                    "imgURL[1]": (_imageFile1!=null)?await MultipartFile.fromFile(_imageFile1.path, filename: fileName1):"",
                  });
                  final results = await _apiProvider
                      .postWithDio(Urls.ADD_AD_URL + "?api_lang=${_authProvider.currentLang}", body: formData);

                  setState(() => _isLoading = false);

                  if (results['response'] == "1") {


                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) {
                          return ConfirmationDialog(
                            title: AppLocalizations.of(context).translate('ad_has_published_successfully'),
                            message:
                            AppLocalizations.of(context).translate('ad_published_and_manage_my_ads'),
                          );
                        });
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/my_ads_screen');
                      _navigationProvider.upadateNavigationIndex(4);
                    });


                  } else {
                    Commons.showError(context, results["message"]);
                  }

                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    _homeProvider = Provider.of<HomeProvider>(context);
    _navigationProvider = Provider.of<NavigationProvider>(context);


    final appBar = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: mainAppColor,
      leading: null,
      centerTitle: true,
      title: Text(AppLocalizations.of(context).translate('add_ad'),style: TextStyle(fontSize: 18),),
      actions: <Widget>[
        GestureDetector(
          child: Icon(Icons.arrow_forward,color: Colors.white,size: 35,),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        Padding(padding: EdgeInsets.all(5)),

      ],

    );


    return PageContainer(
      child: Scaffold(
          appBar: appBar,
          body: Stack(

            children: <Widget>[
              _buildBodyItem(),


              _isLoading
                  ? Center(
                child: SpinKitFadingCircle(color: mainAppColor),
              )
                  : Container()
            ],
          )),
    );
  }
}



