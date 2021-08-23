// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alumni_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlumniUser _$AlumniUserFromJson(Map<String, dynamic> json) {
  return AlumniUser(
    id: json['id'] as String?,
    accId: json['accId'] as String?,
    schId: json['schId'] as String?,
    name: json['name'] as String?,
    ts: json['ts'] as int?,
    yr: json['yr'] as int?,
    dept: json['dept'] as String?,
  );
}

Map<String, dynamic> _$AlumniUserToJson(AlumniUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accId': instance.accId,
      'schId': instance.schId,
      'name': instance.name,
      'ts': instance.ts,
      'yr': instance.yr,
      'dept': instance.dept,
    };
