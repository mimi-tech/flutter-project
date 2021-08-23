import 'package:json_annotation/json_annotation.dart';

part 'sparks_user_general.g.dart';

@JsonSerializable()
class SparksUserGeneral {

  //TODO: variable declaration
  final List<Map<String, dynamic>>? acct;
  final List<Map<String, dynamic>>? phne;
  final String? tkn;
  final String? sts;
  final bool? ol;
  final String? em;
  final bool? emv;

  //TODO: Constructor declaration
  SparksUserGeneral({
    this.acct,
    this.phne,
    this.tkn,
    this.sts,
    this.ol,
    this.em,
    this.emv,
  });

  factory SparksUserGeneral.fromJson(Map<String, dynamic> json) => _$SparksUserGeneralFromJson(json);
  Map<String, dynamic> toJson() => _$SparksUserGeneralToJson(this);

}