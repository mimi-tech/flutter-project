import 'package:json_annotation/json_annotation.dart';

part 'comment_reply.g.dart';

@JsonSerializable()
class ReplyComments {
  final String? rPimg; //profile image
  final Map<String, dynamic>? fn; // full name
  final String? replyText; // reply message
  final String? delRId; // delete reply id
  final String? comID; // comment id
  final String? tRep; // when the reply was made
  final String? id; // Id of the user who replied

  ReplyComments({
    this.rPimg,
    this.fn,
    this.replyText,
    this.delRId,
    this.comID,
    this.tRep,
    this.id,
});

  factory ReplyComments.fromJson(Map<String, dynamic> json) => _$ReplyCommentsFromJson(json);
  Map<String, dynamic> toJson() => _$ReplyCommentsToJson(this);

}