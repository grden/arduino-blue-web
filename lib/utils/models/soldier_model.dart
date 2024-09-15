import 'package:freezed_annotation/freezed_annotation.dart';

part 'soldier_model.freezed.dart';
part 'soldier_model.g.dart';

@unfreezed
sealed class Soldier with _$Soldier {
  factory Soldier({
    required final String id,
    required final String name,
    required final double lat,
    required final double lng,
    required final double temp,
    required final double bpm,
  }) = _Soldier;

  factory Soldier.fromJson(Map<String, dynamic> json) =>
      _$SoldierFromJson(json);

  factory Soldier.fromFirestore(String id, Map<String, dynamic> json) =>
      Soldier(
        id: id,
        name: json['name'],
        lat: json['lat'],
        lng: json['lng'],
        temp: json['temp'],
        bpm: json['bpm'],
      );
}
