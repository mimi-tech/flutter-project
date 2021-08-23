// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SparksBookmark _$SparksBookmarkFromJson(Map<String, dynamic> json) {
  return SparksBookmark(
    auId: json['auId'] as String?,
    postId: json['postId'] as String?,
    bkOwn: json['bkOwn'] as String?,
    bkCrt:
        json['bkCrt'] == null ? null : DateTime.parse(json['bkCrt'] as String),
  );
}

Map<String, dynamic> _$SparksBookmarkToJson(SparksBookmark instance) =>
    <String, dynamic>{
      'auId': instance.auId,
      'postId': instance.postId,
      'bkOwn': instance.bkOwn,
      'bkCrt': instance.bkCrt?.toIso8601String(),
    };
