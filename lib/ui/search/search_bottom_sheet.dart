import 'package:warshat/ui/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:warshat/custom_widgets/buttons/custom_button.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:warshat/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/models/category.dart';
import 'package:warshat/models/city.dart';
import 'package:warshat/models/country.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:warshat/ui/home/home_screen.dart';
import 'package:warshat/ui/search/search_screen.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({Key key}) : super(key: key);
  @override
  _SearchBottomSheetState createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> with ValidationMixin
  {
  String _keySearch = '';
  Future<List<City>> _cityList;
  Future<List<CategoryModel>> _categoryList;
  Future<List<Country>> _countryList;
  City _selectedCity;
  Country _selectedCountry;
  CategoryModel _selectedCategory;
  bool _initialRun = true;
  HomeProvider _homeProvider;

  List<String> _userRate;
  String _selectedUserRate;
  String _xx9='';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);
            _categoryList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:false ,catId: '0',catName:
      AppLocalizations.of(context).translate('all'),catImage: 'assets/images/all.png'));
      _countryList = _homeProvider.getCountryList();
      _cityList = _homeProvider.getCityList(enableCountry: false);


      _userRate= _homeProvider.currentLang=="ar"?["نعم", "لا"]:["Yes", "No"];


      _initialRun = false;
    }
  }

  Widget build(BuildContext context) {

    var userRate = _userRate.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();

    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus( FocusNode());
            },
            child: Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: ListView(children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: mainAppColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                    ),
                    child: Text(
                     _homeProvider.currentLang=="ar"?"تصفية الورش":"Workshop filtering",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    )),


                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.04),
                    child: FutureBuilder<List<CategoryModel>>(
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
                    )),


                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: constraints.maxHeight * 0.04),
                  child: FutureBuilder<List<City>>(
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
                            hint:_homeProvider.currentLang=="ar"?"اختار المنطقة الصناعية":"Choose the industrial area",
                            onChangeFunc: (newValue) {
                              setState(() {
                                _selectedCity = newValue;
                              });
                            },
                            value: _selectedCity,
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
                ),




                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: constraints.maxHeight * 0.04),
                  child: DropDownListSelector(

                    dropDownList: userRate,
                    hint:  _homeProvider.currentLang=="ar"?"الفرز بالاعلي تقييما":"Sorting by highest rated",

                    onChangeFunc: (newValue) {

                      if(newValue=="نعم"){
                        _xx9="1";
                      }else if(newValue=="لا"){
                        _xx9="0";
                      }else if(newValue=="Yes"){
                        _xx9="1";
                      }else if(newValue=="No"){
                        _xx9="2";
                      }
                      _homeProvider.setCurrentUserRate(_xx9);

                      FocusScope.of(context).requestFocus( FocusNode());
                      setState(() {
                        _selectedUserRate = newValue;
                      });
                    },
                    value: _selectedUserRate,

                  ),
                ),



                CustomButton(

                  btnLbl:  AppLocalizations.of(context).translate('search'),
                  btnColor: mainAppColor,
                  onPressedFunction: () {
                 if (
checkSearchValidation(context)){
   _homeProvider.setEnableSearch(true);

                    _homeProvider.setSelectedCategory1(_selectedCategory);
                     _homeProvider.setSelectedCity(_selectedCity);

   Navigator.pushReplacement(
       context,
       MaterialPageRoute(
           builder: (context) =>
               HomeScreen()));

                     
}
                   
                  },
                ),
              ]),
            ),
          ));
    });
  }
}
