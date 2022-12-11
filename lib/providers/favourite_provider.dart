import 'package:flutter/material.dart';
import 'package:warshat/models/ad.dart';
import 'package:warshat/models/user.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/utils/urls.dart';
class FavouriteProvider extends ChangeNotifier {

  ApiProvider _apiProvider =ApiProvider();
    User _currentUser;  
   String _currentLang;


  void update(AuthProvider authProvider) {
    _currentUser = authProvider.currentUser;
    _currentLang = authProvider.currentLang;
  }



// favourite ads list
    Map<String,int> _favouriteAdsList =  Map<String,int>();

// into didCHange() 
     addItemToFavouriteAdsList(String id ,int value){
     _favouriteAdsList[id] = value; 
  }

   addToFavouriteAdsList(String id ,int value){
     _favouriteAdsList[id] = value;
         notifyListeners(); 
  }
   
     removeFromFavouriteAdsList(String id ){
    _favouriteAdsList.remove(id);
   notifyListeners();
  }

   clearFavouriteAdsList( ){
    _favouriteAdsList.clear();
   notifyListeners();
  }

 Map<String,int> get favouriteAdsList => _favouriteAdsList;


 
   Future<List<User>> getFavouriteAdsList() async {
    final response = await _apiProvider.get(Urls.FAVOURITE_URL +
        'user_id=${_currentUser.userId}&page=1&api_lang=$_currentLang');
    List<User> adsList = List<User>();
    if (response['response'] == '1') {
      Iterable iterable = response['ads'];
      adsList = iterable.map((model) => User.fromJson(model)).toList();
    }
    return adsList;
  }


}