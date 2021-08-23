import 'package:json_annotation/json_annotation.dart';

part 'spark_up.g.dart';

@JsonSerializable()
class SparkUp {
  int? numF;
  int? numT;
  int? numM;
  int? numTe;
  int? numMe;
  int? hob;

  SparkUp({
    this.numF,
    this.numT,
    this.numM,
    this.numMe,
    this.numTe,
    this.hob,
  });

  factory SparkUp.fromJson(Map<String, dynamic> json) => _$SparkUpFromJson(json);
  Map<String, dynamic> toJson() => _$SparkUpToJson(this);
}
