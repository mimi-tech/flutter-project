import 'package:json_annotation/json_annotation.dart';

part 'create_spark_up.g.dart';

@JsonSerializable()
class CreateSparkUp {
  String? sid; // Uid of the person sending the request
  String? reqTo; // Uid of the person receiving the request
  String? stsT; // represents the status of the person sending the request
  DateTime? reqSt; // Date when the request was sent
  DateTime? reqCom; // Date when the request was confirmed
  String? sUpTy; // The state of the request. Could be ' REQUEST SENT | RECEIVED | CONFIRMED | BLOCK | UNBLOCK
  String? fId; // The id of the friend, tutor, tutee, mentee, or mentor
  String? em; // email
  Map<String, String?>? nm; // fullname
  String? pimg; // profile pics

  CreateSparkUp({
    this.sid,
    this.reqTo,
    this.stsT,
    this.reqSt,
    this.reqCom,
    this.sUpTy,
    this.fId,
    this.nm,
    this.em,
    this.pimg,
  });

  factory CreateSparkUp.fromJson(Map<String, dynamic> json) =>
      _$CreateSparkUpFromJson(json);
  Map<String, dynamic> toJson() => _$CreateSparkUpToJson(this);
}
