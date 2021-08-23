import 'package:flutter/material.dart';

class CompanyAccessTest extends ChangeNotifier{
  bool _checkPinTrial = false;
   int _falseCredentials = 0;
   int _perClick= 0;
  bool get checkPinTrial => _checkPinTrial;

  int get falseCredentials => _falseCredentials;

  int get perClick => _perClick;

  void updateCounter1(){
    _falseCredentials += 1;
    print("FALSE CRED: $falseCredentials");
    notifyListeners();
  }

  void updateCounter2(){
    _perClick += 1;
    print("PER CLICK AFTER TIMER: $perClick");
    notifyListeners();
  }

  void updatePinAccess(){

    if(!_checkPinTrial){
      _checkPinTrial = true;
    }
    Future.delayed(Duration(seconds: 20), () {
     if(_checkPinTrial){
       _checkPinTrial = false;
       _falseCredentials = 0;
       _perClick= 0;

       print("Future called: $_checkPinTrial");
     }
    });
    notifyListeners();
  }
}