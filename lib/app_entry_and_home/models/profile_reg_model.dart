//TODO: Profile registration part one.
class ProfileReg {
  //TODO: Variable creation.
  final String? certificateType;
  final String? certAndAbove;
  final String? fullName;
  final String? dob;
  final String? gender;

  //TODO: Constructor creation.
  ProfileReg(
      {this.certificateType,
      this.certAndAbove,
      this.fullName,
      this.dob,
      this.gender});
}

//TODO: Profile registration part two.
class ProfileRegTwo {
  //TODO: Variable creation.
  final String? profileImageURL;
  final String? residentialCity;
  final String? homeCity;
  final String? nationality;
  final List<String>? userSpokenLanguages;

  //TODO: Constructor creation.
  ProfileRegTwo({
    this.profileImageURL,
    this.residentialCity,
    this.homeCity,
    this.nationality,
    this.userSpokenLanguages,
  });
}

//TODO: Create a language model.
class LanguageModel {
  final String? languageName;
  bool? isChecked;

  LanguageModel({this.languageName, this.isChecked});

}

//TODO: Create a hobbies model.
class HobbiesModel {
  final String? hobby;
  bool? isChecked;

  HobbiesModel({this.hobby, this.isChecked});

}

//TODO: Create a specialities model.
class SpecialtiesModel {
  final String? specialities;
  bool? isChecked;

  SpecialtiesModel({this.specialities, this.isChecked});

}

//TODO: Create an interest model.
class InterestModel {
  final String? interest;
  bool? isChecked;

  InterestModel({this.interest, this.isChecked});

}
