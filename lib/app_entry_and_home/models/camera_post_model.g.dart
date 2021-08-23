// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CameraPostModel _$CameraPostModelFromJson(Map<String, dynamic> json) {
  return CameraPostModel(
    aID: json['aID'] as String?,
    nm: json['nm'] as Map<String, dynamic>?,
    auSpec: json['auSpec'] as String?,
    auPimg: json['auPimg'] as String?,
    friID: (json['friID'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    imgVid:
        (json['imgVid'] as List<dynamic>?)?.map((e) => e as String).toList(),
    title: json['title'] as String?,
    desc: json['desc'] as String?,
    cln: (json['cln'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String?),
    ),
    nOfCmts: json['nOfCmts'] as int?,
    nOfLikes: json['nOfLikes'] as int?,
    nOfShs: json['nOfShs'] as int?,
    postId: json['postId'] as String?,
    delID: json['delID'] as String?,
    postT: json['postT'] as String?,
    mediaT: json['mediaT'] as String?,
    ptc: json['ptc'] == null ? null : DateTime.parse(json['ptc'] as String),
  );
}

Map<String, dynamic> _$CameraPostModelToJson(CameraPostModel instance) =>
    <String, dynamic>{
      'aID': instance.aID,
      'nm': instance.nm,
      'auSpec': instance.auSpec,
      'auPimg': instance.auPimg,
      'friID': instance.friID,
      'imgVid': instance.imgVid,
      'title': instance.title,
      'desc': instance.desc,
      'postT': instance.postT,
      'cln': instance.cln,
      'nOfCmts': instance.nOfCmts,
      'nOfLikes': instance.nOfLikes,
      'nOfShs': instance.nOfShs,
      'postId': instance.postId,
      'delID': instance.delID,
      'mediaT': instance.mediaT,
      'ptc': instance.ptc?.toIso8601String(),
    };
