import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class CommentModel {
  final String? auID;
  final String? commID;
  final String? postID;
  final Map<String, String?>? nm;
  final String? pimg;
  final String? auSpec;
  final String? comment;
  int? nOfLikes;
  int? nOfRpy;
  final DateTime? tOfPst;

  CommentModel({
    this.auID,
    this.commID,
    this.postID,
    this.nm,
    this.pimg,
    this.auSpec,
    this.comment,
    this.nOfLikes,
    this.nOfRpy,
    this.tOfPst,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

}
