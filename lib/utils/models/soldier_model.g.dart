// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soldier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SoldierImpl _$$SoldierImplFromJson(Map<String, dynamic> json) =>
    _$SoldierImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      temp: (json['temp'] as num).toDouble(),
      bpm: (json['bpm'] as num).toDouble(),
    );

Map<String, dynamic> _$$SoldierImplToJson(_$SoldierImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lat': instance.lat,
      'lng': instance.lng,
      'temp': instance.temp,
      'bpm': instance.bpm,
    };
