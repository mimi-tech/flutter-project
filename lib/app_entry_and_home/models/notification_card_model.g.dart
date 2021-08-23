// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationCardModel _$NotificationCardModelFromJson(
    Map<String, dynamic> json) {
  return NotificationCardModel(
    auId: json['auId'] as String?,
    postId: json['postId'] as String?,
    ptOwn: json['ptOwn'] as String?,
    nm: (json['nm'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    pimg: json['pimg'] as String?,
    comm: json['comm'] as String?,
    notID: json['notID'] as String?,
    notSts: json['notSts'] as String?,
    notTye: json['notTye'] as String?,
    cts: json['cts'] as int?,
  );
}

Map<String, dynamic> _$NotificationCardModelToJson(
        NotificationCardModel instance) =>
    <String, dynamic>{
      'auId': instance.auId,
      'postId': instance.postId,
      'ptOwn': instance.ptOwn,
      'pimg': instance.pimg,
      'nm': instance.nm,
      'comm': instance.comm,
      'notSts': instance.notSts,
      'notID': instance.notID,
      'notTye': instance.notTye,
      'cts': instance.cts,
    };
