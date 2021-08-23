import 'package:json_annotation/json_annotation.dart';

part 'market_info.g.dart';

@JsonSerializable()
class MarketInfo {
  String? id; // User's uid

  String? un; // Username

  String? em; // User's email address

  bool? emv; // Is user's email verified

  MarketInfo({this.id, this.un, this.em, this.emv});

  factory MarketInfo.fromJson(Map<String, dynamic> json) =>
      _$MarketInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MarketInfoToJson(this);
}
