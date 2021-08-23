import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alumni_post.g.dart';

@JsonSerializable()
class AlumniPost {
  String/*?*/ id; // User ID
  String? docId; // Document ID of post
  int? ts; // Timestamp
  int? yr; // Year
  String? dept; // Department
  String? name; // Name of user
  String? type; // Type of post

  @JsonKey(name: "noOfCmts")
  int? commentsCount; // Number of comments

  @JsonKey(name: "noOfLikes")
  int? likesCount; // Number of likes

  @JsonKey(name: "noOfShs")
  int? sharesCount; // Number of shares

  @JsonKey(name: "st")
  String? state;

  @JsonKey(name: "cty")
  String? country;

  @JsonKey(name: "aoi")
  List<String?>? areaOfInterest;

  @JsonKey(disallowNullValue: true)
  String? text; // Post text

  @JsonKey(disallowNullValue: true)
  List<String>? img; // Image strings

  @JsonKey(disallowNullValue: true)
  List<String>? vids; // Video links

  @JsonKey(ignore: true)
  String? pImg;

  AlumniPost({
    required this.id,
    required this.docId,
    required this.ts,
    required this.yr,
    required this.dept,
    required this.name,
    required this.type,
    required this.commentsCount,
    required this.likesCount,
    required this.sharesCount,
    required this.state,
    required this.country,
    required this.areaOfInterest,
    this.text,
    this.img,
    this.vids,
    this.pImg,
  });

  factory AlumniPost.fromJson(Map<String, dynamic> json) =>
      _$AlumniPostFromJson(json);
  Map<String, dynamic> toJson() => _$AlumniPostToJson(this);
}
