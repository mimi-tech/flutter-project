// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alumni_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlumniPost _$AlumniPostFromJson(Map<String, dynamic> json) {
  $checkKeys(json, disallowNullValues: const ['text', 'img', 'vids']);
  return AlumniPost(
    id: json['id'] as String,
    docId: json['docId'] as String?,
    ts: json['ts'] as int?,
    yr: json['yr'] as int?,
    dept: json['dept'] as String?,
    name: json['name'] as String?,
    type: json['type'] as String?,
    commentsCount: json['noOfCmts'] as int?,
    likesCount: json['noOfLikes'] as int?,
    sharesCount: json['noOfShs'] as int?,
    state: json['st'] as String?,
    country: json['cty'] as String?,
    areaOfInterest:
        (json['aoi'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    text: json['text'] as String?,
    img: (json['img'] as List<dynamic>?)?.map((e) => e as String).toList(),
    vids: (json['vids'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$AlumniPostToJson(AlumniPost instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'docId': instance.docId,
    'ts': instance.ts,
    'yr': instance.yr,
    'dept': instance.dept,
    'name': instance.name,
    'type': instance.type,
    'noOfCmts': instance.commentsCount,
    'noOfLikes': instance.likesCount,
    'noOfShs': instance.sharesCount,
    'st': instance.state,
    'cty': instance.country,
    'aoi': instance.areaOfInterest,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('text', instance.text);
  writeNotNull('img', instance.img);
  writeNotNull('vids', instance.vids);
  return val;
}
