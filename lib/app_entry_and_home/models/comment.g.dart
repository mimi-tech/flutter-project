// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) {
  return CommentModel(
    auID: json['auID'] as String?,
    commID: json['commID'] as String?,
    postID: json['postID'] as String?,
    nm: (json['nm'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String?),
    ),
    pimg: json['pimg'] as String?,
    auSpec: json['auSpec'] as String?,
    comment: json['comment'] as String?,
    nOfLikes: json['nOfLikes'] as int?,
    nOfRpy: json['nOfRpy'] as int?,
    tOfPst: json['tOfPst'] == null
        ? null
        : DateTime.parse(json['tOfPst'] as String),
  );
}

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'auID': instance.auID,
      'commID': instance.commID,
      'postID': instance.postID,
      'nm': instance.nm,
      'pimg': instance.pimg,
      'auSpec': instance.auSpec,
      'comment': instance.comment,
      'nOfLikes': instance.nOfLikes,
      'nOfRpy': instance.nOfRpy,
      'tOfPst': instance.tOfPst?.toIso8601String(),
    };
