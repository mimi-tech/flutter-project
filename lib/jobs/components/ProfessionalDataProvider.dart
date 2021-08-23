import 'package:flutter/material.dart';

class ProfessionalStateData extends ChangeNotifier{
  bool _hasProject = false;
  bool _hasAwards = false;
  bool get getHasProject => _hasProject;

  bool get getHasAwards => _hasAwards;



  void setHasProjectToTrue(){
    _hasProject = true;
    notifyListeners();
  }

  void setHasAwardToTrue(){

    _hasAwards = true;
    notifyListeners();
  }


}