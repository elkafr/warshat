import 'package:flutter/material.dart';
import 'package:warshat/ui/add_ad/add_ad_screen.dart';
import 'package:warshat/ui/favourite/favourite_screen.dart';
import 'package:warshat/ui/home/home_screen.dart';
import 'package:warshat/ui/notification/notification_screen.dart';
import 'package:warshat/ui/categories/categories_screen.dart';
import 'package:warshat/ui/search/search_bottom_sheet.dart';


class NavigationProvider extends ChangeNotifier {
  int _navigationIndex = 0;

  void upadateNavigationIndex(int value) {
    _navigationIndex = value;
    notifyListeners();
  }

  int get navigationIndex => _navigationIndex;

  List<Widget> _screens = [
    SearchBottomSheet(),
    SearchBottomSheet(),
    SearchBottomSheet()
  ];

  Widget get selectedContent => _screens[_navigationIndex];

  bool _mapIsActive = false;

  void setMapIsActive(bool value) {
    _mapIsActive = value;
    notifyListeners();
  }

  bool get mapIsActive => _mapIsActive;
}
