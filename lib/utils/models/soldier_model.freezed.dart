// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'soldier_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Soldier _$SoldierFromJson(Map<String, dynamic> json) {
  return _Soldier.fromJson(json);
}

/// @nodoc
mixin _$Soldier {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  double get temp => throw _privateConstructorUsedError;
  double get bpm => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SoldierCopyWith<Soldier> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SoldierCopyWith<$Res> {
  factory $SoldierCopyWith(Soldier value, $Res Function(Soldier) then) =
      _$SoldierCopyWithImpl<$Res, Soldier>;
  @useResult
  $Res call(
      {String id,
      String name,
      double lat,
      double lng,
      double temp,
      double bpm});
}

/// @nodoc
class _$SoldierCopyWithImpl<$Res, $Val extends Soldier>
    implements $SoldierCopyWith<$Res> {
  _$SoldierCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? lat = null,
    Object? lng = null,
    Object? temp = null,
    Object? bpm = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      temp: null == temp
          ? _value.temp
          : temp // ignore: cast_nullable_to_non_nullable
              as double,
      bpm: null == bpm
          ? _value.bpm
          : bpm // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SoldierImplCopyWith<$Res> implements $SoldierCopyWith<$Res> {
  factory _$$SoldierImplCopyWith(
          _$SoldierImpl value, $Res Function(_$SoldierImpl) then) =
      __$$SoldierImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double lat,
      double lng,
      double temp,
      double bpm});
}

/// @nodoc
class __$$SoldierImplCopyWithImpl<$Res>
    extends _$SoldierCopyWithImpl<$Res, _$SoldierImpl>
    implements _$$SoldierImplCopyWith<$Res> {
  __$$SoldierImplCopyWithImpl(
      _$SoldierImpl _value, $Res Function(_$SoldierImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? lat = null,
    Object? lng = null,
    Object? temp = null,
    Object? bpm = null,
  }) {
    return _then(_$SoldierImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      temp: null == temp
          ? _value.temp
          : temp // ignore: cast_nullable_to_non_nullable
              as double,
      bpm: null == bpm
          ? _value.bpm
          : bpm // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SoldierImpl implements _Soldier {
  _$SoldierImpl(
      {required this.id,
      required this.name,
      required this.lat,
      required this.lng,
      required this.temp,
      required this.bpm});

  factory _$SoldierImpl.fromJson(Map<String, dynamic> json) =>
      _$$SoldierImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double lat;
  @override
  final double lng;
  @override
  final double temp;
  @override
  final double bpm;

  @override
  String toString() {
    return 'Soldier(id: $id, name: $name, lat: $lat, lng: $lng, temp: $temp, bpm: $bpm)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SoldierImplCopyWith<_$SoldierImpl> get copyWith =>
      __$$SoldierImplCopyWithImpl<_$SoldierImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SoldierImplToJson(
      this,
    );
  }
}

abstract class _Soldier implements Soldier {
  factory _Soldier(
      {required final String id,
      required final String name,
      required final double lat,
      required final double lng,
      required final double temp,
      required final double bpm}) = _$SoldierImpl;

  factory _Soldier.fromJson(Map<String, dynamic> json) = _$SoldierImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get lat;
  @override
  double get lng;
  @override
  double get temp;
  @override
  double get bpm;
  @override
  @JsonKey(ignore: true)
  _$$SoldierImplCopyWith<_$SoldierImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
