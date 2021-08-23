import 'package:json_annotation/json_annotation.dart';

part 'store_details_model.g.dart';

@JsonSerializable()
class StoreDetailsModel {
  /// Store name
  String? stNm;

  /// Store image
  String? stImg;

  /// Store rating
  double? rate;

  /// Store followers
  int? fols;

  /// Total rating count
  int? rtC;

  StoreDetailsModel({this.stNm, this.stImg, this.rate, this.fols, this.rtC});

  factory StoreDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$StoreDetailsModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoreDetailsModelToJson(this);
}
