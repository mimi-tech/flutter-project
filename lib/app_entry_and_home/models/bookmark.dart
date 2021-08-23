import 'package:json_annotation/json_annotation.dart';

part 'bookmark.g.dart';

@JsonSerializable()
class SparksBookmark {
  final String? auId;
  final String? postId;
  final String? bkOwn;
  final DateTime? bkCrt;

  SparksBookmark({
    this.auId,
    this.postId,
    this.bkOwn,
    this.bkCrt,
  });

  factory SparksBookmark.fromJson(Map<String, dynamic> json) => _$SparksBookmarkFromJson(json);
  Map<String, dynamic> toJson() => _$SparksBookmarkToJson(this);
}
