import 'package:json_annotation/json_annotation.dart';

part 'create_spark_up_mm.g.dart';

@JsonSerializable()
class CreateSparkUpMM {
  String? sid; // Uid of the person sending the request
  String? recId; // Uid of the person receiving the request
  String? stsT; // represents the status of the person sending the request
  DateTime? reqSt; // Date when the request was sent
  DateTime? reqCom; // Date when the request was confirmed
  String? sUpTy; // The state of the request. Could be ' REQUEST SENT | RECEIVED | CONFIRMED | BLOCK | UNBLOCK
  String? asA; // Wants to be a tutor | tutee
  String? meId; // The id of the tutor or tutee
  String? em; // email
  Map<String, String?>? nm; // fullname
  String? pimg; // profile pics

  CreateSparkUpMM({
    this.sid,
    this.recId,
    this.stsT,
    this.reqSt,
    this.reqCom,
    this.sUpTy,
    this.asA,
    this.meId,
    this.nm,
    this.em,
    this.pimg,
  });

  factory CreateSparkUpMM.fromJson(Map<String, dynamic> json) =>
      _$CreateSparkUpMMFromJson(json);
  Map<String, dynamic> toJson() => _$CreateSparkUpMMToJson(this);
}
