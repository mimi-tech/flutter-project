import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'camera_post_model.g.dart';

@JsonSerializable()
class CameraPostModel {
  final String? aID; // means author id
  final Map<String, dynamic>? nm; // author's full name
  final String? auSpec; // author's core speciality
  final String? auPimg;
  final List<String?>? friID; // list of friends
  final List<String>? imgVid; // list of images/video message
  final String? title; // Title of the post
  final String? desc; // post descriptions
  final String? postT; // type of post
  final Map<String, String?>? cln; // author's location
  int? nOfCmts; // Number of comments
  int? nOfLikes; // Number of likes
  int? nOfShs; // Number of shares
  final String? postId; // Post Id
  final String? delID; // A unique Id use for post deletion
  final String? mediaT; // type of media file
  final DateTime? ptc; // time the message was made.

  CameraPostModel({
    required this.aID,
    required this.nm,
    required this.auSpec,
    required this.auPimg,
    required this.friID,
    required this.imgVid,
    required this.title,
    required this.desc,
    required this.cln,
    required this.nOfCmts,
    required this.nOfLikes,
    required this.nOfShs,
    required this.postId,
    required this.delID,
    required this.postT,
    required this.mediaT,
    required this.ptc,
  });

  factory CameraPostModel.fromJson(Map<String, dynamic> json) => _$CameraPostModelFromJson(json);
  Map<String, dynamic> toJson() => _$CameraPostModelToJson(this);

}
