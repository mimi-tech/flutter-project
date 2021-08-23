// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeNotifications _$HomeNotificationsFromJson(Map<String, dynamic> json) {
  return HomeNotifications(
    notCts: json['notCts'] as int?,
    actSrn: json['actSrn'] as bool?,
  );
}

Map<String, dynamic> _$HomeNotificationsToJson(HomeNotifications instance) =>
    <String, dynamic>{
      'notCts': instance.notCts,
      'actSrn': instance.actSrn,
    };
