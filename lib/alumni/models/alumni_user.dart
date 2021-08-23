import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alumni_user.g.dart';

@JsonSerializable()
class AlumniUser {
  String? id; // User ID
  String? accId; // School owner account ID
  String? schId; // School ID
  String? name; // User's full name
  int? ts; // Timestamp
  int? yr; // User entry year
  String? dept; // User school department

  AlumniUser({
    required this.id,
    required this.accId,
    required this.schId,
    required this.name,
    required this.ts,
    required this.yr,
    required this.dept,
  });

  factory AlumniUser.fromJson(Map<String, dynamic> json) =>
      _$AlumniUserFromJson(json);
  Map<String, dynamic> toJson() => _$AlumniUserToJson(this);
}
