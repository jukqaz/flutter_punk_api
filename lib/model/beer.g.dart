// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Beer _$BeerFromJson(Map<String, dynamic> json) {
  return Beer(
    (json['id'] as num)?.toDouble(),
    json['name'] as String,
    json['image_url'] as String,
    json['first_brewed'] as String,
  );
}

Map<String, dynamic> _$BeerToJson(Beer instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'first_brewed': instance.firstBrewed,
    };
