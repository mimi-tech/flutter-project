import 'package:json_annotation/json_annotation.dart';

part 'spark_request_sent.g.dart';

@JsonSerializable()
class SparksRequestSent {
  //TODO: Variable declaration
  final String? id;
  final String? rType;
  final DateTime? rSent;

  SparksRequestSent({this.id, this.rType, this.rSent,});

  factory SparksRequestSent.fromJson(Map<String, dynamic> json) => _$SparksRequestSentFromJson(json);
  Map<String, dynamic> toJson() => _$SparksRequestSentToJson(this);
}