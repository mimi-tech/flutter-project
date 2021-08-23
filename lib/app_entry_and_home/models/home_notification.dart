import 'package:json_annotation/json_annotation.dart';

part 'home_notification.g.dart';

@JsonSerializable()
class HomeNotifications {
  int? notCts; // notification counter
  final bool? actSrn; // Means active screen

  HomeNotifications({
    this.notCts,
    this.actSrn,
  });

  factory HomeNotifications.fromJson(Map<String, dynamic> json) => _$HomeNotificationsFromJson(json);
  Map<String, dynamic> toJson() => _$HomeNotificationsToJson(this);
}
