// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LiveVehicle {

 String get vehicleId; int? get tripId; String? get routeShortName; double get lat; double get lon; double? get bearing; int get delaySeconds; int? get currentStopId;
/// Create a copy of LiveVehicle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveVehicleCopyWith<LiveVehicle> get copyWith => _$LiveVehicleCopyWithImpl<LiveVehicle>(this as LiveVehicle, _$identity);

  /// Serializes this LiveVehicle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LiveVehicle;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveVehicle&&(identical(other.vehicleId, _this.vehicleId) || other.vehicleId == _this.vehicleId)&&(identical(other.tripId, _this.tripId) || other.tripId == _this.tripId)&&(identical(other.routeShortName, _this.routeShortName) || other.routeShortName == _this.routeShortName)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lon, _this.lon) || other.lon == _this.lon)&&(identical(other.bearing, _this.bearing) || other.bearing == _this.bearing)&&(identical(other.delaySeconds, _this.delaySeconds) || other.delaySeconds == _this.delaySeconds)&&(identical(other.currentStopId, _this.currentStopId) || other.currentStopId == _this.currentStopId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LiveVehicle;
  return Object.hash(runtimeType,_this.vehicleId,_this.tripId,_this.routeShortName,_this.lat,_this.lon,_this.bearing,_this.delaySeconds,_this.currentStopId);
}

@override
String toString() {
  final _this = this as LiveVehicle;
  return 'LiveVehicle(vehicleId: ${_this.vehicleId}, tripId: ${_this.tripId}, routeShortName: ${_this.routeShortName}, lat: ${_this.lat}, lon: ${_this.lon}, bearing: ${_this.bearing}, delaySeconds: ${_this.delaySeconds}, currentStopId: ${_this.currentStopId})';
}


}

/// @nodoc
abstract mixin class $LiveVehicleCopyWith<$Res>  {
  factory $LiveVehicleCopyWith(LiveVehicle value, $Res Function(LiveVehicle) _then) = _$LiveVehicleCopyWithImpl;
@useResult
$Res call({
 String vehicleId, int? tripId, String? routeShortName, double lat, double lon, double? bearing, int delaySeconds, int? currentStopId
});




}
/// @nodoc
class _$LiveVehicleCopyWithImpl<$Res>
    implements $LiveVehicleCopyWith<$Res> {
  _$LiveVehicleCopyWithImpl(this._self, this._then);

  final LiveVehicle _self;
  final $Res Function(LiveVehicle) _then;

/// Create a copy of LiveVehicle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vehicleId = null,Object? tripId = freezed,Object? routeShortName = freezed,Object? lat = null,Object? lon = null,Object? bearing = freezed,Object? delaySeconds = null,Object? currentStopId = freezed,}) {
  return _then(LiveVehicle(
vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,tripId: freezed == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int?,routeShortName: freezed == routeShortName ? _self.routeShortName : routeShortName // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,bearing: freezed == bearing ? _self.bearing : bearing // ignore: cast_nullable_to_non_nullable
as double?,delaySeconds: null == delaySeconds ? _self.delaySeconds : delaySeconds // ignore: cast_nullable_to_non_nullable
as int,currentStopId: freezed == currentStopId ? _self.currentStopId : currentStopId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LiveVehicle].
extension LiveVehiclePatterns on LiveVehicle {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveVehicle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveVehicle() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveVehicle value)  $default,){
final _that = this;
switch (_that) {
case _LiveVehicle():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveVehicle value)?  $default,){
final _that = this;
switch (_that) {
case _LiveVehicle() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String vehicleId,  int? tripId,  String? routeShortName,  double lat,  double lon,  double? bearing,  int delaySeconds,  int? currentStopId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveVehicle() when $default != null:
return $default(_that.vehicleId,_that.tripId,_that.routeShortName,_that.lat,_that.lon,_that.bearing,_that.delaySeconds,_that.currentStopId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String vehicleId,  int? tripId,  String? routeShortName,  double lat,  double lon,  double? bearing,  int delaySeconds,  int? currentStopId)  $default,) {final _that = this;
switch (_that) {
case _LiveVehicle():
return $default(_that.vehicleId,_that.tripId,_that.routeShortName,_that.lat,_that.lon,_that.bearing,_that.delaySeconds,_that.currentStopId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String vehicleId,  int? tripId,  String? routeShortName,  double lat,  double lon,  double? bearing,  int delaySeconds,  int? currentStopId)?  $default,) {final _that = this;
switch (_that) {
case _LiveVehicle() when $default != null:
return $default(_that.vehicleId,_that.tripId,_that.routeShortName,_that.lat,_that.lon,_that.bearing,_that.delaySeconds,_that.currentStopId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LiveVehicle implements LiveVehicle {
  const _LiveVehicle({required this.vehicleId, this.tripId, this.routeShortName, required this.lat, required this.lon, this.bearing, required this.delaySeconds, this.currentStopId});
  factory _LiveVehicle.fromJson(Map<String, dynamic> json) => _$LiveVehicleFromJson(json);

@override final  String vehicleId;
@override final  int? tripId;
@override final  String? routeShortName;
@override final  double lat;
@override final  double lon;
@override final  double? bearing;
@override final  int delaySeconds;
@override final  int? currentStopId;

/// Create a copy of LiveVehicle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveVehicleCopyWith<_LiveVehicle> get copyWith => __$LiveVehicleCopyWithImpl<_LiveVehicle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LiveVehicleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveVehicle&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.routeShortName, routeShortName) || other.routeShortName == routeShortName)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.bearing, bearing) || other.bearing == bearing)&&(identical(other.delaySeconds, delaySeconds) || other.delaySeconds == delaySeconds)&&(identical(other.currentStopId, currentStopId) || other.currentStopId == currentStopId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,vehicleId,tripId,routeShortName,lat,lon,bearing,delaySeconds,currentStopId);
}

@override
String toString() {
    return 'LiveVehicle(vehicleId: $vehicleId, tripId: $tripId, routeShortName: $routeShortName, lat: $lat, lon: $lon, bearing: $bearing, delaySeconds: $delaySeconds, currentStopId: $currentStopId)';
}


}

/// @nodoc
abstract mixin class _$LiveVehicleCopyWith<$Res> implements $LiveVehicleCopyWith<$Res> {
  factory _$LiveVehicleCopyWith(_LiveVehicle value, $Res Function(_LiveVehicle) _then) = __$LiveVehicleCopyWithImpl;
@override @useResult
$Res call({
 String vehicleId, int? tripId, String? routeShortName, double lat, double lon, double? bearing, int delaySeconds, int? currentStopId
});




}
/// @nodoc
class __$LiveVehicleCopyWithImpl<$Res>
    implements _$LiveVehicleCopyWith<$Res> {
  __$LiveVehicleCopyWithImpl(this._self, this._then);

  final _LiveVehicle _self;
  final $Res Function(_LiveVehicle) _then;

/// Create a copy of LiveVehicle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vehicleId = null,Object? tripId = freezed,Object? routeShortName = freezed,Object? lat = null,Object? lon = null,Object? bearing = freezed,Object? delaySeconds = null,Object? currentStopId = freezed,}) {
  return _then(_LiveVehicle(
vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,tripId: freezed == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int?,routeShortName: freezed == routeShortName ? _self.routeShortName : routeShortName // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,bearing: freezed == bearing ? _self.bearing : bearing // ignore: cast_nullable_to_non_nullable
as double?,delaySeconds: null == delaySeconds ? _self.delaySeconds : delaySeconds // ignore: cast_nullable_to_non_nullable
as int,currentStopId: freezed == currentStopId ? _self.currentStopId : currentStopId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
