import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:warshat/models/ad.dart';
import 'package:warshat/models/category.dart';
import 'package:warshat/models/city.dart';
import 'package:warshat/models/country.dart';
import 'package:warshat/models/package.dart';
import 'package:warshat/models/user.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/utils/urls.dart';

class HomeProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  User _currentUser;

  String _currentLang;

  void update(AuthProvider authProvider) {
    _currentUser = authProvider.currentUser;
    _currentLang = authProvider.currentLang;
  }

  String get currentLang => _currentLang;

  bool _enableSearch = false;

  void setEnableSearch(bool enableSearch) {
    _enableSearch = enableSearch;
    notifyListeners();
  }

  bool get enableSearch => _enableSearch;

  List<CategoryModel> _categoryList = List<CategoryModel>();

  List<CategoryModel> get categoryList => _categoryList;

  CategoryModel _lastSelectedCategory;

  void updateChangesOnCategoriesList(int index) {
    if (lastSelectedCategory != null) {
      _lastSelectedCategory.isSelected = false;
    }
    _categoryList[index].isSelected = true;
    _lastSelectedCategory = _categoryList[index];
    notifyListeners();
  }

  void updateSelectedCategory(CategoryModel categoryModel) {
    _lastSelectedCategory.isSelected = false;
    for (int i = 0; i < _categoryList.length; i++) {
      if (categoryModel.catId == _categoryList[i].catId) {
        _lastSelectedCategory = _categoryList[i];
        _lastSelectedCategory.isSelected = true;
      }
      notifyListeners();
    }
  }

  CategoryModel get lastSelectedCategory => _lastSelectedCategory;

  Future<List<CategoryModel>> getCategoryList(
      {CategoryModel categoryModel}) async {
    final response = await _apiProvider
        .get(Urls.MAIN_CATEGORY_URL + "?api_lang=$_currentLang");

    if (response['response'] == '1') {
      Iterable iterable = response['cat'];
      _categoryList =
          iterable.map((model) => CategoryModel.fromJson(model)).toList();

      if (!_enableSearch) {


        _lastSelectedCategory = _categoryList[0];
      }
      else{
        categoryModel.isSelected = false;
          _categoryList.insert(0, categoryModel);
           for (int i = 0; i < _categoryList.length; i++) {
      if (lastSelectedCategory.catId == _categoryList[i].catId) {
        _categoryList[i].isSelected = true;
      }
      }
      }
    }
    return _categoryList;
  }

  Future<List<City>> getCityList(
      {@required bool enableCountry, String countryId}) async {
    var response;
    if (enableCountry) {
      response = await _apiProvider.get(Urls.CITIES_URL +
          "?api_lang=$_currentLang" +
           "&country_id=$countryId");
    } else {
      response = await _apiProvider.get(Urls.CITIES_URL+
          "?api_lang=$_currentLang");
    }

    List cityList = List<City>();
    if (response['response'] == '1') {
      Iterable iterable = response['city'];
      cityList = iterable.map((model) => City.fromJson(model)).toList();
    }
    return cityList;
  }

  Future<List<Country>> getCountryList() async {
    final response = await _apiProvider
        .get(Urls.GET_COUNTRY_URL + "?api_lang=$_currentLang");
    List<Country> countryList = List<Country>();
    if (response['response'] == '1') {
      Iterable iterable = response['country'];
      countryList = iterable.map((model) => Country.fromJson(model)).toList();
    }
    return countryList;
  }

  Future<List<Package>> getPackageList() async {
    final response = await _apiProvider
        .get("https://wersh1.com/api/getpackages" + "?api_lang=$_currentLang");
    List<Package> packageList = List<Package>();
    if (response['response'] == '1') {
      Iterable iterable = response['result'];
      packageList = iterable.map((model) => Package.fromJson(model)).toList();
    }
    return packageList;
  }

  Future<List<User>> getAdsList() async {
    final response = await _apiProvider
        .post(Urls.SEARCH_URL + "?api_lang=$_currentLang", body: {
      "fav_user_id": _currentUser == null ? '' : _currentUser.userId
    });
    List<User> adsList = List<User>();
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => User.fromJson(model)).toList();
    }
    return adsList;
  }

  Future<List<Ad>> getAdsListByCity($cityId) async {
    final response = await _apiProvider
        .post(Urls.SEARCH_URL + "?api_lang=$_currentLang", body: {
      "ads_city":$cityId,
      "fav_user_id": _currentUser == null ? '' : _currentUser.userId
    });
    List<Ad> adsList = List<Ad>();
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }


  Future<List<Ad>> getAdsListByCategory($catId) async {
    final response = await _apiProvider
        .post(Urls.SEARCH_URL + "?api_lang=$_currentLang", body: {
      "ads_cat":$catId,
      "fav_user_id": _currentUser == null ? '' : _currentUser.userId
    });
    List<Ad> adsList = List<Ad>();
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }

  Future<List<Ad>> getAdsListRelated($adsId) async {
    final response = await _apiProvider
        .post(Urls.RELATED_ADS , body: {
      "ads_id":$adsId,
    });
    List<Ad> adsList = List<Ad>();
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }

  Future<List<User>> getAdsSearchList() async {
    final response = await _apiProvider
        .post(Urls.SEARCH_URL + "?api_lang=$_currentLang", body: {
      "user_title": _searchKey,
      "user_cat": _lastSelectedCategory.catId,
     // "ads_country": _selectedCity != null ? _selectedCountry.countryId : '',
      "user_city": _selectedCity != null ? _selectedCity.cityId : '',
      "user_rate": _currentUserRate != null ? _currentUserRate : '',
      "fav_user_id": _currentUser == null ? '' : _currentUser.userId
    });

    List<User> adsList = List<User>();
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => User.fromJson(model)).toList();
    }
    return adsList;
  }

  String _searchKey = '';

  void setSearchKey(String searchKey) {
    _searchKey = searchKey;
    notifyListeners();
  }

  String get searchKey => _searchKey;







  String _checkedValue = '';

  void setCheckedValue(String checkedValue) {
    _checkedValue = checkedValue;
    notifyListeners();
  }

  String get checkedValue => _checkedValue;


  String _loginValue = '';

  void setLoginValue(String loginValue) {
    _loginValue = loginValue;
    notifyListeners();
  }

  String get loginValue => _loginValue;


  String _latValue = '';
  void setLatValue(String latValue) {
    _latValue = latValue;
    notifyListeners();
  }
  String get latValue => _latValue;


  String _longValue = '';
  void setLongValue(String longValue) {
    _longValue = longValue;
    notifyListeners();
  }
  String get longValue => _longValue;


  Country _selectedCountry;

  void setSelectedCountry(Country country) {
    _selectedCountry = country;
    notifyListeners();
  }

  Country get selectedCountry => _selectedCountry;

  City _selectedCity;

  void setSelectedCity(City city) {
    _selectedCity = city;
    notifyListeners();
  }
  City get selectedCity => _selectedCity;


  CategoryModel _selectedCategory1;

  void setSelectedCategory1(CategoryModel category) {
    _selectedCategory1 = category;
    notifyListeners();
  }
  CategoryModel get selectedCategory1 => _selectedCategory1;


  String _age = '';

  void setAge(String age) {
    _age = age;
    notifyListeners();
  }

  String get age => _age;


  String _catt = '';

  void setCatt(String catt) {
    _catt = catt;
    notifyListeners();
  }

  String get catt => _catt;



  // الكارت
  int _totalCart = 0;

  void increaseTotalCart() {
    _totalCart++;
    notifyListeners();
  }


  int get totalCart => _totalCart;





  String _selectedGender = '';

  void setSelectedGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  String get selectedGender => _selectedGender;


  String _currentAds = '';

  void setCurrentAds(String currentAds) {
    _currentAds = currentAds;
    notifyListeners();
  }

  String get currentAds => _currentAds;


  dynamic _currentIndex = '';

  void setCurrentIndex(dynamic currentIndex) {
    _currentIndex = currentIndex;
    notifyListeners();
  }

  dynamic get currentIndex => _currentIndex;






  dynamic _currentIndexCity = '';

  void setCurrentIndexCity(dynamic currentIndexCity) {
    _currentIndexCity = currentIndexCity;
    notifyListeners();
  }

  dynamic get currentIndexCity => _currentIndexCity;


  dynamic _currentIndexCountry = '';

  void setCurrentIndexCountry(dynamic currentIndexCountry) {
    _currentIndexCountry = currentIndexCountry;
    notifyListeners();
  }

  dynamic get currentIndexCountry => _currentIndexCountry;


  int _currentIndex1= 0;

  void setCurrentIndex1(int currentIndex1) {
    _currentIndex1 = currentIndex1;
    notifyListeners();
  }

  int get currentIndex1 => _currentIndex1;



  int _currentIndex1City= 0;

  void setCurrentIndex1City(int currentIndex1City) {
    _currentIndex1City = currentIndex1City;
    notifyListeners();
  }

  int get currentIndex1City => _currentIndex1City;



  String _currentCatName= '';

  void setCurrentCatName(String currentCatName) {
    _currentCatName = currentCatName;
    notifyListeners();
  }

  String get currentCatName => _currentCatName;




  String _currentCityName= '';

  void setCurrentCityName(String currentCityName) {
    _currentCityName = currentCityName;
    notifyListeners();
  }

  String get currentCityName => _currentCityName;


  String _currentCountryId= '';

  void setCurrentCountryId(String currentCountryId) {
    _currentCountryId = currentCountryId;
    notifyListeners();
  }

  String get currentCountryId => _currentCountryId;






  String _currentUserRate= '';

  void setCurrentUserRate(String currentUserRate) {
    _currentUserRate = currentUserRate;
    notifyListeners();
  }

  String get currentUserRate => _currentUserRate;





  String _currentPackageId= '';

  void setCurrentPackageId(String currentPackageId) {
    _currentPackageId = currentPackageId;
    notifyListeners();
  }

  String get currentPackageId => _currentPackageId;


  Future<String> getUnreadMessage() async {
    final response =
    await _apiProvider.get("https://wersh1.com/api/get_unread_message?user_id=${_currentUser.userId}");
    String messages = '';
    if (response['response'] == '1') {
      messages = response['Number'];
    }
    return messages;
  }

  Future<String> getUnreadNotify() async {
    final response =
    await _apiProvider.get("https://wersh1.com/api/get_unread_notify?user_id=${_currentUser.userId}");
    String messages = '';
    if (response['response'] == '1') {
      messages = response['Number'];
    }
    return messages;
  }



  Future<List<User>> getAllRecentlyAddedProductList() async {

    final response = await _apiProvider.post(
        Urls.SEARCH_URL);
    List<User> productList = List<User>();
    if (response['response'] == "1") {
      Iterable iterable = response['results'];
      productList = iterable.map((model) => User.fromJson(model)).toList();
    }

    return productList;
  }







  Future<List<User>> getAllMarkersList() async {



    final response = await _apiProvider
        .post(Urls.SEARCH_URL);
    List<User> productList = List<User>();
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      productList = iterable.map((model) => User.fromJson(model)).toList();
    }

    return productList;
  }


  Future<List<User>> getAllMarkersListSearch() async {



    final response = await _apiProvider
        .post(Urls.SEARCH_URL + "?api_lang=$_currentLang", body: {
      "user_title": _searchKey,
      "user_cat": _lastSelectedCategory.catId,
      // "ads_country": _selectedCity != null ? _selectedCountry.countryId : '',
      "user_city": _selectedCity != null ? _selectedCity.cityId : '',
      "user_rate": _currentUserRate != null ? _currentUserRate : '',
      "fav_user_id": _currentUser == null ? '' : _currentUser.userId
    });
    List<User> productList = List<User>();
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      productList = iterable.map((model) => User.fromJson(model)).toList();
    }

    return productList;
  }






}





