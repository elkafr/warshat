import 'package:flutter/material.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/models/category.dart';
import 'package:warshat/models/city.dart';
import 'package:warshat/models/country.dart';
import 'package:warshat/utils/commons.dart';
import 'package:validators/validators.dart';
import 'dart:io';

mixin ValidationMixin<T extends StatefulWidget> on State<T> {
  String _password = '';

  String validateUserName(String userName) {
    if (userName.trim().length == 0) {
      return  AppLocalizations.of(context).translate('user_name_validation');
    }
    return null;
  }

  String validateUserEmail(String userEmail) {
    if (userEmail.trim().length == 0 || !isEmail(userEmail)) {
      return AppLocalizations.of(context).translate('email_validation1');
    }

    return null;
  }


  String validateActivationCode(String activationCode) {
    if (activationCode.trim().length == 0) {
      return  AppLocalizations.of(context).translate('activation_code_validation');
    }
    return null;
  }




  String validateAdTitle(String title) {
    if (title.trim().length == 0) {
      return AppLocalizations.of(context).translate('ad_title');
    }
    return null;
  }

  String validateMsg(String msgTitle) {
    if (msgTitle.trim().length == 0) {
      return  AppLocalizations.of(context).translate('msg_validation');
    }
    return null;
  }


  String validateAdDescription(String adsDetails) {
    if (adsDetails.trim().length == 0) {
      return  AppLocalizations.of(context).translate('ad_description_validation');
    }
    return null;
  }

  String validatePassword(String password) {
    _password = password;
    if (password.trim().length == 0) {
      return AppLocalizations.of(context).translate('password_validation') ;
    }
    return null;
  }

  String validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.trim().length == 0) {
      return  AppLocalizations.of(context).translate('confirm_password_validation');
    } else if (_password != confirmPassword) {
      return AppLocalizations.of(context).translate('Password_not_identical');
    }
    return null;
  }

  String validateUserPhone(String phone) {
    if (phone.trim().length == 0 || !isNumeric(phone)) {
      return  AppLocalizations.of(context).translate('phone_no_validation');
    }else     if (phone.trim().length <10) {
      return  "يجب ان لايقل رقم الهاتف عن 10 ارقام";
    }
    return null;
  }



  String validateAdPrice(String adPrice) {
    if (adPrice.trim().length == 0 || !isNumeric(adPrice)) {
      return AppLocalizations.of(context).translate('ad_price_validation');
    }
    return null;
  }

  // String validateKeySearch(String keySearch) {
  //   if (keySearch.trim().length == 0) {
  //     return ' يرجى إدخال كلمة البحث';
  //   }
  //   return null;
  // }

  // String validateAge(String age) {
  //   if (age.trim().length == 0 || !isNumeric(age)) {
  //     return ' يرجى إدخال العمر';
  //   }
  //   return null;
  // }

  bool checkAddAdValidation(BuildContext context,
      {File imgFile, CategoryModel adMainCategory, City adCity, String adKind}) {
    // if (imgFile == null) {
    //  Commons.showToast(context,
    //      message:  AppLocalizations.of(context).translate('ad_image_validation'), color: Colors.red);
    //  return false;
   // }
    if (adMainCategory == null) {
      Commons.showToast(context,
          message: AppLocalizations.of(context).translate('ad_category_validation'), color: Colors.red);
      return false;
    } else if (adCity == null) {
      Commons.showToast(context,
          message: AppLocalizations.of(context).translate('ad_city_validation'), color: Colors.red);
      return false;
    }
    return true;
  }

   bool checkEditAdValidation(BuildContext context,
      { CategoryModel adMainCategory, City adCity, String adKind}) {
  
    if (adMainCategory == null) {
      Commons.showToast(context,
          message: AppLocalizations.of(context).translate('ad_category_validation'), color: Colors.red);
      return false;
    }  else if (adCity == null) {
      Commons.showToast(context,
          message: AppLocalizations.of(context).translate('ad_city_validation'), color: Colors.red);
      return false;
    }
    return true;
  }

  bool checkSearchValidation(
    BuildContext context) {


    return true;
  }

  bool checkValidationCountry(
    BuildContext context, {
    Country country,
  }) {
    if (country == null) {
      Commons.showToast(context,
          message: AppLocalizations.of(context).translate('country_validation'), color: Colors.red);
      return false;
    }
    return true;
  }
}
