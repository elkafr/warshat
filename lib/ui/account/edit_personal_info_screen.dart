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
import 'package:warshat/providers/auth_provider.dart';
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
import 'package:warshat/shared_preferences/shared_preferences_helper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:io';
import 'package:warshat/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class EditPersonalInfoScreen extends StatefulWidget {
  @override
  _EditPersonalInfoScreenState createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
  RegisterProvider _registerProvider;
  bool _initalRun = true;
  bool _isLoading = false;
  ApiProvider _apiProvider = ApiProvider();
  HomeProvider _homeProvider = HomeProvider();
  AuthProvider _authProvider = AuthProvider();
  String _userName = '', _userPhone = '', _userWhats = '', _userEndDate = '', _userAbout = '', _userEmail = '', _userPassword = '', _userAdress= '';
  Future<List<CategoryModel>> _categoryList;
  CategoryModel _selectedCategory;
  File _imageFile;
  Future<List<City>> _cityList;
  City _selectedCity;
  bool _initSelectedCity = true;
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
      _authProvider = Provider.of<AuthProvider>(context);


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



      _userName = _authProvider.currentUser.userName;
      _userEndDate = _authProvider.currentUser.userEndDate;
      _userPhone = _authProvider.currentUser.userPhone;
      _userEmail = _authProvider.currentUser.userEmail;
      _userWhats = _authProvider.currentUser.userWhats;
      _userAbout = _authProvider.currentUser.userAbout;
      _userAdress = _authProvider.currentUser.userAdress;
      _userEndDate= _authProvider.currentUser.userEndDate;

      _homeProvider.setCatt(_authProvider.currentUser.userCat);



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
    print("cccccc");
    print(_homeProvider.longValue);
    print("cccccc");
    if (_authProvider.currentUser.photos != null)
      return GridView.count(
        crossAxisCount: 3,

        children: List.generate(_authProvider.currentUser.photos.length, (index) {


          return Stack(

            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: Image.network(
                  _authProvider.currentUser.photos[index].photo,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
                
              Positioned(
                right: 5,
                  top: 5,
                  child: GestureDetector(
                child: Icon(Icons.delete,color: Colors.red,),
                    onTap: () async {
                      final results = await _apiProvider
                          .post("https://wersh1.com/api/do_delete_photo" , body: {
                        "id":  _authProvider.currentUser.photos[index].id,

                      });


                      if (results['response'] == "1") {
                        Commons.showToast(context, message: results["message"] );
                        _authProvider.currentUser.photos.removeAt(index);
                       setState(() {

                       });
                      } else {
                        Commons.showError(context, results["message"]);

                      }

                    },
              ))

            ],
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






            SizedBox(
              height: 20,
            ),

            CustomTextFormField(
              prefixIconIsImage: true,
              prefixIconImagePath: 'assets/images/user.png',
              hintTxt: AppLocalizations.of(context).translate('user_name'),
              validationFunc: validateUserName,
              initialValue: _userName,
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
                initialValue: _userPhone,
                onChangedFunc: (text) {
                  _userPhone = text;
                },
              ),
            ),

            _authProvider.currentUser.userType=="2"?Container(
              margin: EdgeInsets.only(bottom: 17),
              child: CustomTextFormField(
                prefixIconIsImage: true,
                prefixIconImagePath: 'assets/images/whats.png',
                hintTxt: "رقم الواتساب",
                validationFunc: validateUserPhone,
                initialValue: _userWhats,
                onChangedFunc: (text) {
                  _userWhats = text;
                },
              ),
            ):Container(height: 0,),


            CustomTextFormField(
              prefixIconIsImage: true,
              prefixIconImagePath: 'assets/images/mail.png',
              hintTxt:AppLocalizations.of(context).translate('email'),

              initialValue: _userEmail,
              onChangedFunc: (text) {
                _userEmail = text;
              },
            ),

            _authProvider.currentUser.userType=="2"?SizedBox(height: 18,):Container(height: 0,),

            _authProvider.currentUser.userType=="2"?FutureBuilder<List<City>>(
          future: _cityList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var cityList = snapshot.data.map((item) {
                return new DropdownMenuItem<City>(
                  child: new Text(item.cityName),
                  value: item,
                );
              }).toList();

              if (_initSelectedCity) {

                for (int i = 0; i < snapshot.data.length; i++) {
                  if (_authProvider.currentUser.userCityName == snapshot.data[i].cityName) {
                    _selectedCity = snapshot.data[i];
                    break;
                  }
                }
                _initSelectedCity = false;


              }
              return DropDownListSelector(
                dropDownList: cityList,
                hint:  AppLocalizations.of(context).translate('choose_city'),
                onChangeFunc: (newValue) {
                  setState(() {
                    _selectedCity = newValue;
                  });
                },
                value: _selectedCity,
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return Center(child: CircularProgressIndicator());
          },
        ):Container(height: 0,),

            SizedBox(height: 18,),
            _authProvider.currentUser.userType=="2"?CustomTextFormField(
              prefixIconIsImage: true,
              prefixIconImagePath: 'assets/images/city.png',
              hintTxt: "العنوان",
              validationFunc: validateUserName,
              initialValue: _userAdress,
              onChangedFunc: (text) {
                _userAdress = text;
              },
            ):Container(height: 0),


            _authProvider.currentUser.userType=="2"?Container(
              margin: EdgeInsets.only(top: 15,right: 30),
              child: Text("اختيار أقسام الورشة",style: TextStyle(fontSize: 16),),
            ):Container(height: 0,),


            _authProvider.currentUser.userType=="2"?Container(
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
                    })):Container(height: 0,),


            _authProvider.currentUser.userType=="2"?Container(
              margin: EdgeInsets.only(top: 15,right: 30,left: 30),
              child: Text("لوجو الورشة",style: TextStyle(fontSize: 16),),
            ):Container(height: 0,),



            _authProvider.currentUser.userType=="2"?Container(
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
                        _authProvider.currentUser.userPhoto==null?Image.asset('assets/images/add.png'):Image.network(
                          _authProvider.currentUser.userPhoto,
                          height: 70,
                          width: 80,
                          fit: BoxFit.cover,
                        ),

                      ],
                    ),
                  )),

            ):Container(height: 0,),

            _authProvider.currentUser.userType=="2"?Container(
              margin: EdgeInsets.only(top: 15,right: 30,left: 30),
              child: Text("صور الورشة",style: TextStyle(fontSize: 16),),
            ):Container(height: 0),



            _authProvider.currentUser.userType=="2"?Container(
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
                title: Text("يمكن التحميل أكثر من صورة",style: TextStyle(color: hintColor),),
                trailing: Icon(Icons.attachment),
                onTap: loadAssets,
              ),

            ):Container(height: 0,),

            SizedBox(height: 10,),
          (_authProvider.currentUser.photos != null)?Container(
              margin: EdgeInsets.all(20),
              height: 200,
              child: buildGridView(),
            ):Container(height: 10,),


            _authProvider.currentUser.userType=="2"?CustomTextFormField(
              prefixIconIsImage: true,
              maxLines: 4,
              prefixIconImagePath: 'assets/images/type.png',
              hintTxt: "نبذة عن الورشة",
              validationFunc: validateUserName,
              initialValue: _userAbout,
              onChangedFunc: (text) {
                _userAbout = text;
              },
            ):Container(height: 0,),


            _authProvider.currentUser.userType=="2"?SizedBox(height: 17,):Container(height: 0,),


            _authProvider.currentUser.userType=="2"?GestureDetector(
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
                      "موقع الورشة على الخريطة",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    )
                  ],
                ),
              ),
            ):Container(height: 0,),


            





            _isLoading
                ? Center(
              child:SpinKitFadingCircle(color: mainAppColor),
            ):CustomButton(
              btnLbl: AppLocalizations.of(context).translate('save'),
              btnColor: mainAppColor,
              onPressedFunction: () async {



                if (_formKey.currentState.validate()) {


                    setState(() {
                      _isLoading = true;
                    });






                    String fileName = (_imageFile!=null)?Path.basename(_imageFile.path):"";








                    for (Asset a in images) {
                      final bytes = await a.getByteData();
                      imagesBytes[a.identifier] = bytes.buffer.asUint8List();
                    }
                    final imagesData = images.map((a) => MultipartFile.fromBytes(imagesBytes[a.identifier], filename: a.name)).toList();



                    FormData formData =  _authProvider.currentUser.userType=="2"?new FormData.fromMap({
                      "user_id": _authProvider.currentUser.userId,
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
                      "user_location":(_locationState.locationLatitude!=null?_locationState.locationLatitude.toString():_homeProvider.latValue)+","+(_locationState.locationlongitude!=null?_locationState.locationlongitude.toString():_homeProvider.longValue),
                      "imgURL":_imageFile!=null?await MultipartFile.fromFile(_imageFile.path, filename: fileName):"",
                      "imgURL1":imagesData
                    }):new FormData.fromMap({
                      "user_id": _authProvider.currentUser.userId,
                      "user_name":_userName,
                      "user_phone": _userPhone,
                      "user_type": "1",
                      "user_email":_userEmail,
                    });

                    final results =
                    await _apiProvider.postWithDio(Urls.PROFILE_URL, body: formData);

                    setState(() => _isLoading = false);
                    if (results['response'] == "1") {

                      _authProvider
                          .setCurrentUser(User.fromJson(results["user"]));
                      SharedPreferencesHelper.save(
                          "user", _authProvider.currentUser);
                      Commons.showToast(context,message: results["message"] );
                      Navigator.pop(context);
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
      title: Text(AppLocalizations.of(context).translate('edit_info'),style: TextStyle(fontSize: 18,color: Colors.black),),



    );

    return PageContainer(
      child: Scaffold(
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
