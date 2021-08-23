// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreDetailsModel _$StoreDetailsModelFromJson(Map<String, dynamic> json) {
  return StoreDetailsModel(
    stNm: json['stNm'] as String?,
    stImg: json['stImg'] as String?,
    rate: (json['rate'] as num?)?.toDouble(),
    fols: json['fols'] as int?,
    rtC: json['rtC'] as int?,
  );
}

Map<String, dynamic> _$StoreDetailsModelToJson(StoreDetailsModel instance) =>
    <String, dynamic>{
      'stNm': instance.stNm,
      'stImg': instance.stImg,
      'rate': instance.rate,
      'fols': instance.fols,
      'rtC': instance.rtC,
    };
