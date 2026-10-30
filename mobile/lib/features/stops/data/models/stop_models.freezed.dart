// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stop_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StopSummary {

 int get id; String get name; String? get code; double get lat; double get lon;
/// Create a copy of StopSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StopSummaryCopyWith<StopSummary> get copyWith => _$StopSummaryCopyWithImpl<StopSummary>(this as StopSummary, _$identity);

  /// Serializes this StopSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StopSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lon, _this.lon) || other.lon == _this.lon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StopSummary;
  return Object.hash(runtimeType,_this.id,_this.name,_this.code,_this.lat,_this.lon);
}

@override
String toString() {
  final _this = this as StopSummary;
  return 'StopSummary(id: ${_this.id}, name: ${_this.name}, code: ${_this.code}, lat: ${_this.lat}, lon: ${_this.lon})';
}


}

/// @nodoc
abstract mixin class $StopSummaryCopyWith<$Res>  {
  factory $StopSummaryCopyWith(StopSummary value, $Res Function(StopSummary) _then) = _$StopSummaryCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? code, double lat, double lon
});




}
/// @nodoc
class _$StopSummaryCopyWithImpl<$Res>
    implements $StopSummaryCopyWith<$Res> {
  _$StopSummaryCopyWithImpl(this._self, this._then);

  final StopSummary _self;
  final $Res Function(StopSummary) _then;

/// Create a copy of StopSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? code = freezed,Object? lat = null,Object? lon = null,}) {
  return _then(StopSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [StopSummary].
extension StopSummaryPatterns on StopSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StopSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StopSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StopSummary value)  $default,){
final _that = this;
switch (_that) {
case _StopSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StopSummary value)?  $default,){
final _that = this;
switch (_that) {
case _StopSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? code,  double lat,  double lon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StopSummary() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.lat,_that.lon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? code,  double lat,  double lon)  $default,) {final _that = this;
switch (_that) {
case _StopSummary():
return $default(_that.id,_that.name,_that.code,_that.lat,_that.lon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? code,  double lat,  double lon)?  $default,) {final _that = this;
switch (_that) {
case _StopSummary() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.lat,_that.lon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StopSummary implements StopSummary {
  const _StopSummary({required this.id, required this.name, this.code, required this.lat, required this.lon});
  factory _StopSummary.fromJson(Map<String, dynamic> json) => _$StopSummaryFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? code;
@override final  double lat;
@override final  double lon;

/// Create a copy of StopSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StopSummaryCopyWith<_StopSummary> get copyWith => __$StopSummaryCopyWithImpl<_StopSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StopSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,code,lat,lon);
}

@override
String toString() {
    return 'StopSummary(id: $id, name: $name, code: $code, lat: $lat, lon: $lon)';
}


}

/// @nodoc
abstract mixin class _$StopSummaryCopyWith<$Res> implements $StopSummaryCopyWith<$Res> {
  factory _$StopSummaryCopyWith(_StopSummary value, $Res Function(_StopSummary) _then) = __$StopSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? code, double lat, double lon
});




}
/// @nodoc
class __$StopSummaryCopyWithImpl<$Res>
    implements _$StopSummaryCopyWith<$Res> {
  __$StopSummaryCopyWithImpl(this._self, this._then);

  final _StopSummary _self;
  final $Res Function(_StopSummary) _then;

/// Create a copy of StopSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? code = freezed,Object? lat = null,Object? lon = null,}) {
  return _then(_StopSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$NearbyStop {

 int get id; String get name; String? get code; double get lat; double get lon; double get distanceM;
/// Create a copy of NearbyStop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NearbyStopCopyWith<NearbyStop> get copyWith => _$NearbyStopCopyWithImpl<NearbyStop>(this as NearbyStop, _$identity);

  /// Serializes this NearbyStop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NearbyStop;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyStop&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lon, _this.lon) || other.lon == _this.lon)&&(identical(other.distanceM, _this.distanceM) || other.distanceM == _this.distanceM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NearbyStop;
  return Object.hash(runtimeType,_this.id,_this.name,_this.code,_this.lat,_this.lon,_this.distanceM);
}

@override
String toString() {
  final _this = this as NearbyStop;
  return 'NearbyStop(id: ${_this.id}, name: ${_this.name}, code: ${_this.code}, lat: ${_this.lat}, lon: ${_this.lon}, distanceM: ${_this.distanceM})';
}


}

/// @nodoc
abstract mixin class $NearbyStopCopyWith<$Res>  {
  factory $NearbyStopCopyWith(NearbyStop value, $Res Function(NearbyStop) _then) = _$NearbyStopCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? code, double lat, double lon, double distanceM
});




}
/// @nodoc
class _$NearbyStopCopyWithImpl<$Res>
    implements $NearbyStopCopyWith<$Res> {
  _$NearbyStopCopyWithImpl(this._self, this._then);

  final NearbyStop _self;
  final $Res Function(NearbyStop) _then;

/// Create a copy of NearbyStop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? code = freezed,Object? lat = null,Object? lon = null,Object? distanceM = null,}) {
  return _then(NearbyStop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [NearbyStop].
extension NearbyStopPatterns on NearbyStop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NearbyStop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NearbyStop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NearbyStop value)  $default,){
final _that = this;
switch (_that) {
case _NearbyStop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NearbyStop value)?  $default,){
final _that = this;
switch (_that) {
case _NearbyStop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? code,  double lat,  double lon,  double distanceM)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NearbyStop() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.lat,_that.lon,_that.distanceM);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? code,  double lat,  double lon,  double distanceM)  $default,) {final _that = this;
switch (_that) {
case _NearbyStop():
return $default(_that.id,_that.name,_that.code,_that.lat,_that.lon,_that.distanceM);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? code,  double lat,  double lon,  double distanceM)?  $default,) {final _that = this;
switch (_that) {
case _NearbyStop() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.lat,_that.lon,_that.distanceM);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NearbyStop implements NearbyStop {
  const _NearbyStop({required this.id, required this.name, this.code, required this.lat, required this.lon, required this.distanceM});
  factory _NearbyStop.fromJson(Map<String, dynamic> json) => _$NearbyStopFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? code;
@override final  double lat;
@override final  double lon;
@override final  double distanceM;

/// Create a copy of NearbyStop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NearbyStopCopyWith<_NearbyStop> get copyWith => __$NearbyStopCopyWithImpl<_NearbyStop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NearbyStopToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NearbyStop&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,code,lat,lon,distanceM);
}

@override
String toString() {
    return 'NearbyStop(id: $id, name: $name, code: $code, lat: $lat, lon: $lon, distanceM: $distanceM)';
}


}

/// @nodoc
abstract mixin class _$NearbyStopCopyWith<$Res> implements $NearbyStopCopyWith<$Res> {
  factory _$NearbyStopCopyWith(_NearbyStop value, $Res Function(_NearbyStop) _then) = __$NearbyStopCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? code, double lat, double lon, double distanceM
});




}
/// @nodoc
class __$NearbyStopCopyWithImpl<$Res>
    implements _$NearbyStopCopyWith<$Res> {
  __$NearbyStopCopyWithImpl(this._self, this._then);

  final _NearbyStop _self;
  final $Res Function(_NearbyStop) _then;

/// Create a copy of NearbyStop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? code = freezed,Object? lat = null,Object? lon = null,Object? distanceM = null,}) {
  return _then(_NearbyStop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$StopDetail {

 int get id; String get name; String? get code; double get lat; double get lon; String? get description; List<RouteSummary> get routes;
/// Create a copy of StopDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StopDetailCopyWith<StopDetail> get copyWith => _$StopDetailCopyWithImpl<StopDetail>(this as StopDetail, _$identity);

  /// Serializes this StopDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StopDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lon, _this.lon) || other.lon == _this.lon)&&(identical(other.description, _this.description) || other.description == _this.description)&&const DeepCollectionEquality().equals(other.routes, _this.routes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StopDetail;
  return Object.hash(runtimeType,_this.id,_this.name,_this.code,_this.lat,_this.lon,_this.description,const DeepCollectionEquality().hash(_this.routes));
}

@override
String toString() {
  final _this = this as StopDetail;
  return 'StopDetail(id: ${_this.id}, name: ${_this.name}, code: ${_this.code}, lat: ${_this.lat}, lon: ${_this.lon}, description: ${_this.description}, routes: ${_this.routes})';
}


}

/// @nodoc
abstract mixin class $StopDetailCopyWith<$Res>  {
  factory $StopDetailCopyWith(StopDetail value, $Res Function(StopDetail) _then) = _$StopDetailCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? code, double lat, double lon, String? description, List<RouteSummary> routes
});




}
/// @nodoc
class _$StopDetailCopyWithImpl<$Res>
    implements $StopDetailCopyWith<$Res> {
  _$StopDetailCopyWithImpl(this._self, this._then);

  final StopDetail _self;
  final $Res Function(StopDetail) _then;

/// Create a copy of StopDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? code = freezed,Object? lat = null,Object? lon = null,Object? description = freezed,Object? routes = null,}) {
  return _then(StopDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,routes: null == routes ? _self.routes : routes // ignore: cast_nullable_to_non_nullable
as List<RouteSummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [StopDetail].
extension StopDetailPatterns on StopDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StopDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StopDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StopDetail value)  $default,){
final _that = this;
switch (_that) {
case _StopDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StopDetail value)?  $default,){
final _that = this;
switch (_that) {
case _StopDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? code,  double lat,  double lon,  String? description,  List<RouteSummary> routes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StopDetail() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.lat,_that.lon,_that.description,_that.routes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? code,  double lat,  double lon,  String? description,  List<RouteSummary> routes)  $default,) {final _that = this;
switch (_that) {
case _StopDetail():
return $default(_that.id,_that.name,_that.code,_that.lat,_that.lon,_that.description,_that.routes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? code,  double lat,  double lon,  String? description,  List<RouteSummary> routes)?  $default,) {final _that = this;
switch (_that) {
case _StopDetail() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.lat,_that.lon,_that.description,_that.routes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StopDetail implements StopDetail {
  const _StopDetail({required this.id, required this.name, this.code, required this.lat, required this.lon, this.description, required  List<RouteSummary> routes}): _routes = routes;
  factory _StopDetail.fromJson(Map<String, dynamic> json) => _$StopDetailFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? code;
@override final  double lat;
@override final  double lon;
@override final  String? description;
 final  List<RouteSummary> _routes;
@override List<RouteSummary> get routes {
  if (_routes is EqualUnmodifiableListView) return _routes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routes);
}


/// Create a copy of StopDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StopDetailCopyWith<_StopDetail> get copyWith => __$StopDetailCopyWithImpl<_StopDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StopDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.routes, _routes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,code,lat,lon,description,const DeepCollectionEquality().hash(_routes));
}

@override
String toString() {
    return 'StopDetail(id: $id, name: $name, code: $code, lat: $lat, lon: $lon, description: $description, routes: $routes)';
}


}

/// @nodoc
abstract mixin class _$StopDetailCopyWith<$Res> implements $StopDetailCopyWith<$Res> {
  factory _$StopDetailCopyWith(_StopDetail value, $Res Function(_StopDetail) _then) = __$StopDetailCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? code, double lat, double lon, String? description, List<RouteSummary> routes
});




}
/// @nodoc
class __$StopDetailCopyWithImpl<$Res>
    implements _$StopDetailCopyWith<$Res> {
  __$StopDetailCopyWithImpl(this._self, this._then);

  final _StopDetail _self;
  final $Res Function(_StopDetail) _then;

/// Create a copy of StopDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? code = freezed,Object? lat = null,Object? lon = null,Object? description = freezed,Object? routes = null,}) {
  return _then(_StopDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,routes: null == routes ? _self._routes : routes // ignore: cast_nullable_to_non_nullable
as List<RouteSummary>,
  ));
}


}


/// @nodoc
mixin _$Departure {

 int get tripId; RouteSummary get route; String? get headsign; DateTime get departureAt; int get stopSequence;
/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartureCopyWith<Departure> get copyWith => _$DepartureCopyWithImpl<Departure>(this as Departure, _$identity);

  /// Serializes this Departure to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Departure;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Departure&&(identical(other.tripId, _this.tripId) || other.tripId == _this.tripId)&&(identical(other.route, _this.route) || other.route == _this.route)&&(identical(other.headsign, _this.headsign) || other.headsign == _this.headsign)&&(identical(other.departureAt, _this.departureAt) || other.departureAt == _this.departureAt)&&(identical(other.stopSequence, _this.stopSequence) || other.stopSequence == _this.stopSequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Departure;
  return Object.hash(runtimeType,_this.tripId,_this.route,_this.headsign,_this.departureAt,_this.stopSequence);
}

@override
String toString() {
  final _this = this as Departure;
  return 'Departure(tripId: ${_this.tripId}, route: ${_this.route}, headsign: ${_this.headsign}, departureAt: ${_this.departureAt}, stopSequence: ${_this.stopSequence})';
}


}

/// @nodoc
abstract mixin class $DepartureCopyWith<$Res>  {
  factory $DepartureCopyWith(Departure value, $Res Function(Departure) _then) = _$DepartureCopyWithImpl;
@useResult
$Res call({
 int tripId, RouteSummary route, String? headsign, DateTime departureAt, int stopSequence
});


$RouteSummaryCopyWith<$Res> get route;

}
/// @nodoc
class _$DepartureCopyWithImpl<$Res>
    implements $DepartureCopyWith<$Res> {
  _$DepartureCopyWithImpl(this._self, this._then);

  final Departure _self;
  final $Res Function(Departure) _then;

/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tripId = null,Object? route = null,Object? headsign = freezed,Object? departureAt = null,Object? stopSequence = null,}) {
  return _then(Departure(
tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as RouteSummary,headsign: freezed == headsign ? _self.headsign : headsign // ignore: cast_nullable_to_non_nullable
as String?,departureAt: null == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as DateTime,stopSequence: null == stopSequence ? _self.stopSequence : stopSequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteSummaryCopyWith<$Res> get route {
  
  return $RouteSummaryCopyWith<$Res>(_self.route, (value) {
    return _then(_self.copyWith(route: value));
  });
}
}


/// Adds pattern-matching-related methods to [Departure].
extension DeparturePatterns on Departure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Departure value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Departure() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Departure value)  $default,){
final _that = this;
switch (_that) {
case _Departure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Departure value)?  $default,){
final _that = this;
switch (_that) {
case _Departure() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tripId,  RouteSummary route,  String? headsign,  DateTime departureAt,  int stopSequence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Departure() when $default != null:
return $default(_that.tripId,_that.route,_that.headsign,_that.departureAt,_that.stopSequence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tripId,  RouteSummary route,  String? headsign,  DateTime departureAt,  int stopSequence)  $default,) {final _that = this;
switch (_that) {
case _Departure():
return $default(_that.tripId,_that.route,_that.headsign,_that.departureAt,_that.stopSequence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tripId,  RouteSummary route,  String? headsign,  DateTime departureAt,  int stopSequence)?  $default,) {final _that = this;
switch (_that) {
case _Departure() when $default != null:
return $default(_that.tripId,_that.route,_that.headsign,_that.departureAt,_that.stopSequence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Departure implements Departure {
  const _Departure({required this.tripId, required this.route, this.headsign, required this.departureAt, required this.stopSequence});
  factory _Departure.fromJson(Map<String, dynamic> json) => _$DepartureFromJson(json);

@override final  int tripId;
@override final  RouteSummary route;
@override final  String? headsign;
@override final  DateTime departureAt;
@override final  int stopSequence;

/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepartureCopyWith<_Departure> get copyWith => __$DepartureCopyWithImpl<_Departure>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepartureToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Departure&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.route, route) || other.route == route)&&(identical(other.headsign, headsign) || other.headsign == headsign)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.stopSequence, stopSequence) || other.stopSequence == stopSequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tripId,route,headsign,departureAt,stopSequence);
}

@override
String toString() {
    return 'Departure(tripId: $tripId, route: $route, headsign: $headsign, departureAt: $departureAt, stopSequence: $stopSequence)';
}


}

/// @nodoc
abstract mixin class _$DepartureCopyWith<$Res> implements $DepartureCopyWith<$Res> {
  factory _$DepartureCopyWith(_Departure value, $Res Function(_Departure) _then) = __$DepartureCopyWithImpl;
@override @useResult
$Res call({
 int tripId, RouteSummary route, String? headsign, DateTime departureAt, int stopSequence
});


@override $RouteSummaryCopyWith<$Res> get route;

}
/// @nodoc
class __$DepartureCopyWithImpl<$Res>
    implements _$DepartureCopyWith<$Res> {
  __$DepartureCopyWithImpl(this._self, this._then);

  final _Departure _self;
  final $Res Function(_Departure) _then;

/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tripId = null,Object? route = null,Object? headsign = freezed,Object? departureAt = null,Object? stopSequence = null,}) {
  return _then(_Departure(
tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as RouteSummary,headsign: freezed == headsign ? _self.headsign : headsign // ignore: cast_nullable_to_non_nullable
as String?,departureAt: null == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as DateTime,stopSequence: null == stopSequence ? _self.stopSequence : stopSequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteSummaryCopyWith<$Res> get route {
  
  return $RouteSummaryCopyWith<$Res>(_self.route, (value) {
    return _then(_self.copyWith(route: value));
  });
}
}

// dart format on
