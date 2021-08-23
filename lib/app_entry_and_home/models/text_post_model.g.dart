// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextPostModel _$TextPostModelFromJson(Map<String, dynamic> json) {
  return TextPostModel(
    aID: json['aID'] as String?,
    postId: json['postId'] as String?,
    nm: json['nm'] as Map<String, dynamic>?,
    auPimg: json['auPimg'] as String?,
    auSpec: json['auSpec'] as String?,
    friID: (json['friID'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    text: json['text'] as String?,
    txtC: json['txtC'] as int?,
    fonFa: json['fonFa'] as String?,
    fontS: json['fontS'] as int?,
    likeP: json['likeP'] as bool?,
    bgImg: json['bgImg'] as String?,
    postT: json['postT'] as String?,
    nOfLikes: json['nOfLikes'] as int?,
    nOfCmts: json['nOfCmts'] as int?,
    nOfShs: json['nOfShs'] as int?,
    cln: (json['cln'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String?),
    ),
    ptc: json['ptc'] == null ? null : DateTime.parse(json['ptc'] as String),
    delID: json['delID'] as String?,
  );
}

Map<String, dynamic> _$TextPostModelToJson(TextPostModel instance) =>
    <String, dynamic>{
      'aID': instance.aID,
      'postId': instance.postId,
      'nm': instance.nm,
      'auSpec': instance.auSpec,
      'auPimg': instance.auPimg,
      'friID': instance.friID,
      'text': instance.text,
      'txtC': instance.txtC,
      'fonFa': instance.fonFa,
      'fontS': instance.fontS,
      'likeP': instance.likeP,
      'bgImg': instance.bgImg,
      'postT': instance.postT,
      'nOfLikes': instance.nOfLikes,
      'nOfCmts': instance.nOfCmts,
      'nOfShs': instance.nOfShs,
      'cln': instance.cln,
      'ptc': instance.ptc?.toIso8601String(),
      'delID': instance.delID,
    };
