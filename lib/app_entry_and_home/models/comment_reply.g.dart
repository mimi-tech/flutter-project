// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyComments _$ReplyCommentsFromJson(Map<String, dynamic> json) {
  return ReplyComments(
    rPimg: json['rPimg'] as String?,
    fn: json['fn'] as Map<String, dynamic>?,
    replyText: json['replyText'] as String?,
    delRId: json['delRId'] as String?,
    comID: json['comID'] as String?,
    tRep: json['tRep'] as String?,
    id: json['id'] as String?,
  );
}

Map<String, dynamic> _$ReplyCommentsToJson(ReplyComments instance) =>
    <String, dynamic>{
      'rPimg': instance.rPimg,
      'fn': instance.fn,
      'replyText': instance.replyText,
      'delRId': instance.delRId,
      'comID': instance.comID,
      'tRep': instance.tRep,
      'id': instance.id,
    };
