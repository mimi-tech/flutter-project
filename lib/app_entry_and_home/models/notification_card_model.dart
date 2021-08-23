import 'package:json_annotation/json_annotation.dart';

part 'notification_card_model.g.dart';

@JsonSerializable()
class NotificationCardModel {
  final String? auId;
  final String? postId;
  final String? ptOwn;
  final String? pimg;
  final Map<String, String>? nm;
  final String? comm;
  String? notSts;
  final String? notID;
  final String? notTye;
  final int? cts;

  NotificationCardModel({
    this.auId,
    this.postId,
    this.ptOwn,
    this.nm,
    this.pimg,
    this.comm,
    this.notID,
    this.notSts,
    this.notTye,
    this.cts,
});

  factory NotificationCardModel.fromJson(Map<String, dynamic> json) => _$NotificationCardModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationCardModelToJson(this);
}