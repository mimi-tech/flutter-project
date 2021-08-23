import 'package:json_annotation/json_annotation.dart';
import 'package:sparks/market/market_models/product_home_detail_model.dart';
import 'package:sparks/market/market_models/store_details_model.dart';

part 'displayed_product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DisplayedProductModel {
  StoreDetailsModel? storeDetailsModel;
  ProductHomeDetailModel? productHomeDetailModel;

  DisplayedProductModel({this.storeDetailsModel, this.productHomeDetailModel});

  factory DisplayedProductModel.fromJson(Map<String, dynamic> json) =>
      _$DisplayedProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$DisplayedProductModelToJson(this);
}
