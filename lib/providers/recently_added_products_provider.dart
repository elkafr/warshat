import 'package:flutter/material.dart';
import 'package:warshat/models/ad.dart';
import 'package:warshat/models/user.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/utils/urls.dart';

class RecentlyAddedProductsProvider extends ChangeNotifier {

  User _currentUser;


void update(AuthProvider authProvider) {
    _currentUser = authProvider.currentUser;

}





   Future<List<User>> getAllRecentlyAddedProductList() async {

     ApiProvider _apiProvider = ApiProvider();
     HomeProvider _homeProvider = HomeProvider();

    final response = await _apiProvider.post(
        Urls.SEARCH_URL);
    List<User> productList = List<User>();
    if (response['response'] == "1") {
      Iterable iterable = response['results'];
      productList = iterable.map((model) => User.fromJson(model)).toList();
    }

    return productList;
  }

}

class MarkersListFeeder{

   Future<List<User>> getAllMarkersList() async {

     ApiProvider _apiProvider = ApiProvider();
     HomeProvider _homeProvider = HomeProvider();


    final response = await _apiProvider
        .post(Urls.SEARCH_URL);
    List<User> productList = List<User>();
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      productList = iterable.map((model) => User.fromJson(model)).toList();
    }

    return productList;
  }


   Future<List<User>> getAllMarkersListSearch(String city,String cat,String title,String rate) async {

     ApiProvider _apiProvider = ApiProvider();
     HomeProvider _homeProvider = HomeProvider();

     final response = await _apiProvider
         .post(Urls.SEARCH_URL + "?api_lang=ar", body: {
       "user_title":title,
       "user_cat": cat,
       // "ads_country": _selectedCity != null ? _selectedCountry.countryId : '',
       "user_city": city,
       "user_rate": rate,
       "fav_user_id": ""
     });
     List<User> productList = List<User>();
     if (response['response'] == '1') {
       Iterable iterable = response['results'];
       productList = iterable.map((model) => User.fromJson(model)).toList();
     }

     return productList;
   }




}
