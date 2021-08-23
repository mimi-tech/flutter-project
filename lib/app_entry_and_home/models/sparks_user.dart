import 'package:json_annotation/json_annotation.dart';

part 'sparks_user.g.dart';

@JsonSerializable()
class SparksUser {
  //TODO: Variable declaration
  final String? id; // user uid
  final Map<String, String?>? nm; // user full name
  final String? pimg; // user profile image url
  final Map<String, dynamic>? addr; // user address
  final String? bdate; // user date of birth
  final String? sex; // user gender
  final String? marst; // user marital status
  final List<String?>? lang; // user spoken languages
  final List<String?>? hobb; //user hobbies
  final List<String?>? aoi; // user area of interest
  final List<String?>? ind; // user choice of industries
  final List<String?>? spec; // user specialities
  final bool? schVt; // School visited
  final bool? isMen; // user is a mentor or not
  final String? un; // user username
  final String? em; // user email address
  final bool? emv; // Is user email verified
  final DateTime? crAt; // when a user created the account

  //TODO: Constructor declaration
  SparksUser({
    this.id,
    this.nm,
    this.pimg,
    this.addr,
    this.bdate,
    this.sex,
    this.marst,
    this.lang,
    this.hobb,
    this.aoi,
    this.ind,
    this.spec,
    this.schVt,
    this.isMen,
    this.un,
    this.em,
    this.emv,
    this.crAt,
  });

  factory SparksUser.fromJson(Map<String, dynamic> json) => _$SparksUserFromJson(json);
  Map<String, dynamic> toJson() => _$SparksUserToJson(this);

}
