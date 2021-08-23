// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alumni_school.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlumniSchool _$AlumniSchoolFromJson(Map<String, dynamic> json) {
  return AlumniSchool(
    schoolOwnerId: json['id'] as String?,
    schoolId: json['schId'] as String?,
    schoolName: json['name'] as String?,
    schoolStreet: json['str'] as String?,
    schoolCity: json['city'] as String?,
    schoolState: json['st'] as String?,
    schoolCountry: json['cty'] as String?,
    schoolLogo: json['logo'] as String?,
    isAlumni: json['isAlumni'] as bool? ?? false,
  );
}

Map<String, dynamic> _$AlumniSchoolToJson(AlumniSchool instance) =>
    <String, dynamic>{
      'id': instance.schoolOwnerId,
      'schId': instance.schoolId,
      'name': instance.schoolName,
      'str': instance.schoolStreet,
      'city': instance.schoolCity,
      'st': instance.schoolState,
      'cty': instance.schoolCountry,
      'logo': instance.schoolLogo,
      'isAlumni': instance.isAlumni,
    };
