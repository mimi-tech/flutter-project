import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alumni_school.g.dart';

@JsonSerializable()
class AlumniSchool {
  @JsonKey(name: "id")
  String? schoolOwnerId; // School owner account ID

  @JsonKey(name: "schId")
  String? schoolId; // School ID

  @JsonKey(name: "name")
  String? schoolName; // School name

  @JsonKey(name: "str")
  String? schoolStreet; // School street

  @JsonKey(name: "city")
  String? schoolCity; // School city

  @JsonKey(name: "st")
  String? schoolState; // School state

  @JsonKey(name: "cty")
  String? schoolCountry; // School country

  @JsonKey(name: "logo")
  String? schoolLogo; // School logo

  @JsonKey(defaultValue: false)
  bool? isAlumni;

  AlumniSchool({
    required this.schoolOwnerId,
    required this.schoolId,
    required this.schoolName,
    required this.schoolStreet,
    required this.schoolCity,
    required this.schoolState,
    required this.schoolCountry,
    this.schoolLogo,
    this.isAlumni,
  });

  factory AlumniSchool.fromJson(Map<String, dynamic> json) =>
      _$AlumniSchoolFromJson(json);
  Map<String, dynamic> toJson() => _$AlumniSchoolToJson(this);
}
