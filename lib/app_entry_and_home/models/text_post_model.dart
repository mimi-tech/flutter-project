import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'text_post_model.g.dart';

@JsonSerializable()
class TextPostModel {
  final String? aID; // means author id
  final String? postId;
  final Map<String, dynamic>? nm; // author's full name
  final String? auSpec; // author's core speciality
  final String? auPimg; // author's profile image
  final List<String?>? friID; // list of friends
  final String? text; // message on the user's mind
  final int? txtC; // text colour
  final String? fonFa; // font family
  final int? fontS; // font size
  final bool? likeP;
  final String? bgImg; // background image of the message
  final String? postT; // type of message
  final int? nOfLikes;
  final int? nOfCmts;
  final int? nOfShs;
  final Map<String, String?>? cln;
  final DateTime? ptc; // time the message was made.
  final String? delID; // Use the variable to delete a post.

  TextPostModel({
    required this.aID,
    required this.postId,
    required this.nm,
    required this.auPimg,
    required this.auSpec,
    required this.friID,
    required this.text,
    required this.txtC,
    required this.fonFa,
    required this.fontS,
    required this.likeP,
    required this.bgImg,
    required this.postT,
    required this.nOfLikes,
    required this.nOfCmts,
    required this.nOfShs,
    required this.cln,
    required this.ptc,
    required this.delID,
  });

  factory TextPostModel.fromJson(Map<String, dynamic> json) => _$TextPostModelFromJson(json);
  Map<String, dynamic> toJson() => _$TextPostModelToJson(this);

}
