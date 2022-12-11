import 'package:flutter/material.dart';
class ProgressIndicatorState extends ChangeNotifier {
  bool _isLoading = false;  
  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  } 
   bool get isLoading => _isLoading;
}