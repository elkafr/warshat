import 'package:flutter/material.dart';
import 'package:warshat/models/userDetails.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/utils/urls.dart';
  class AdDetailsProvider extends ChangeNotifier {
    String _currentLang;


  void update(AuthProvider authProvider) {
    _currentLang = authProvider.currentLang;

  }




    ApiProvider _apiProvider = ApiProvider();

  Future<UserDetails> getAdDetails(String userId,String currentLat,String currentLong) async {
    final response =
        await _apiProvider.get(Urls.AD_DETAILS_URL +  'id=$userId&api_lang=$_currentLang&current_lat=$currentLat&current_long=$currentLong');
    UserDetails adDetails = UserDetails();
    if (response['response'] == '1') {
      adDetails = UserDetails.fromJson(response['results']);
    }
    return adDetails;
  }
  }
