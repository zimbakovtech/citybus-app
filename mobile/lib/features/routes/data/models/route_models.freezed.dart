// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RouteSummary {

 int get id; String? get shortName; String? get longName; String? get color;
/// Create a copy of RouteSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteSummaryCopyWith<RouteSummary> get copyWith => _$RouteSummaryCopyWithImpl<RouteSummary>(this as RouteSummary, _$identity);

  /// Serializes this RouteSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.shortName, _this.shortName) || other.shortName == _this.shortName)&&(identical(other.longName, _this.longName) || other.longName == _this.longName)&&(identical(other.color, _this.color) || other.color == _this.color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteSummary;
  return Object.hash(runtimeType,_this.id,_this.shortName,_this.longName,_this.color);
}

@override
String toString() {
  final _this = this as RouteSummary;
  return 'RouteSummary(id: ${_this.id}, shortName: ${_this.shortName}, longName: ${_this.longName}, color: ${_this.color})';
}


}

/// @nodoc
abstract mixin class $RouteSummaryCopyWith<$Res>  {
  factory $RouteSummaryCopyWith(RouteSummary value, $Res Function(RouteSummary) _then) = _$RouteSummaryCopyWithImpl;
@useResult
$Res call({
 int id, String? shortName, String? longName, String? color
});




}
/// @nodoc
class _$RouteSummaryCopyWithImpl<$Res>
    implements $RouteSummaryCopyWith<$Res> {
  _$RouteSummaryCopyWithImpl(this._self, this._then);

  final RouteSummary _self;
  final $Res Function(RouteSummary) _then;

/// Create a copy of RouteSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? shortName = freezed,Object? longName = freezed,Object? color = freezed,}) {
  return _then(RouteSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,shortName: freezed == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String?,longName: freezed == longName ? _self.longName : longName // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteSummary].
extension RouteSummaryPatterns on RouteSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteSummary value)  $default,){
final _that = this;
switch (_that) {
case _RouteSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RouteSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? shortName,  String? longName,  String? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteSummary() when $default != null:
return $default(_that.id,_that.shortName,_that.longName,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? shortName,  String? longName,  String? color)  $default,) {final _that = this;
switch (_that) {
case _RouteSummary():
return $default(_that.id,_that.shortName,_that.longName,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? shortName,  String? longName,  String? color)?  $default,) {final _that = this;
switch (_that) {
case _RouteSummary() when $default != null:
return $default(_that.id,_that.shortName,_that.longName,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteSummary implements RouteSummary {
  const _RouteSummary({required this.id, this.shortName, this.longName, this.color});
  factory _RouteSummary.fromJson(Map<String, dynamic> json) => _$RouteSummaryFromJson(json);

@override final  int id;
@override final  String? shortName;
@override final  String? longName;
@override final  String? color;

/// Create a copy of RouteSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteSummaryCopyWith<_RouteSummary> get copyWith => __$RouteSummaryCopyWithImpl<_RouteSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.shortName, shortName) || other.shortName == shortName)&&(identical(other.longName, longName) || other.longName == longName)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,shortName,longName,color);
}

@override
String toString() {
    return 'RouteSummary(id: $id, shortName: $shortName, longName: $longName, color: $color)';
}


}

/// @nodoc
abstract mixin class _$RouteSummaryCopyWith<$Res> implements $RouteSummaryCopyWith<$Res> {
  factory _$RouteSummaryCopyWith(_RouteSummary value, $Res Function(_RouteSummary) _then) = __$RouteSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id, String? shortName, String? longName, String? color
});




}
/// @nodoc
class __$RouteSummaryCopyWithImpl<$Res>
    implements _$RouteSummaryCopyWith<$Res> {
  __$RouteSummaryCopyWithImpl(this._self, this._then);

  final _RouteSummary _self;
  final $Res Function(_RouteSummary) _then;

/// Create a copy of RouteSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? shortName = freezed,Object? longName = freezed,Object? color = freezed,}) {
  return _then(_RouteSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,shortName: freezed == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String?,longName: freezed == longName ? _self.longName : longName // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RouteDetail {

 int get id; String? get shortName; String? get longName; String? get color; String get gtfsRouteId; int get routeType; String? get textColor; String get agencyName;
/// Create a copy of RouteDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteDetailCopyWith<RouteDetail> get copyWith => _$RouteDetailCopyWithImpl<RouteDetail>(this as RouteDetail, _$identity);

  /// Serializes this RouteDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.shortName, _this.shortName) || other.shortName == _this.shortName)&&(identical(other.longName, _this.longName) || other.longName == _this.longName)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.gtfsRouteId, _this.gtfsRouteId) || other.gtfsRouteId == _this.gtfsRouteId)&&(identical(other.routeType, _this.routeType) || other.routeType == _this.routeType)&&(identical(other.textColor, _this.textColor) || other.textColor == _this.textColor)&&(identical(other.agencyName, _this.agencyName) || other.agencyName == _this.agencyName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteDetail;
  return Object.hash(runtimeType,_this.id,_this.shortName,_this.longName,_this.color,_this.gtfsRouteId,_this.routeType,_this.textColor,_this.agencyName);
}

@override
String toString() {
  final _this = this as RouteDetail;
  return 'RouteDetail(id: ${_this.id}, shortName: ${_this.shortName}, longName: ${_this.longName}, color: ${_this.color}, gtfsRouteId: ${_this.gtfsRouteId}, routeType: ${_this.routeType}, textColor: ${_this.textColor}, agencyName: ${_this.agencyName})';
}


}

/// @nodoc
abstract mixin class $RouteDetailCopyWith<$Res>  {
  factory $RouteDetailCopyWith(RouteDetail value, $Res Function(RouteDetail) _then) = _$RouteDetailCopyWithImpl;
@useResult
$Res call({
 int id, String? shortName, String? longName, String? color, String gtfsRouteId, int routeType, String? textColor, String agencyName
});




}
/// @nodoc
class _$RouteDetailCopyWithImpl<$Res>
    implements $RouteDetailCopyWith<$Res> {
  _$RouteDetailCopyWithImpl(this._self, this._then);

  final RouteDetail _self;
  final $Res Function(RouteDetail) _then;

/// Create a copy of RouteDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? shortName = freezed,Object? longName = freezed,Object? color = freezed,Object? gtfsRouteId = null,Object? routeType = null,Object? textColor = freezed,Object? agencyName = null,}) {
  return _then(RouteDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,shortName: freezed == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String?,longName: freezed == longName ? _self.longName : longName // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,gtfsRouteId: null == gtfsRouteId ? _self.gtfsRouteId : gtfsRouteId // ignore: cast_nullable_to_non_nullable
as String,routeType: null == routeType ? _self.routeType : routeType // ignore: cast_nullable_to_non_nullable
as int,textColor: freezed == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as String?,agencyName: null == agencyName ? _self.agencyName : agencyName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteDetail].
extension RouteDetailPatterns on RouteDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteDetail value)  $default,){
final _that = this;
switch (_that) {
case _RouteDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteDetail value)?  $default,){
final _that = this;
switch (_that) {
case _RouteDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? shortName,  String? longName,  String? color,  String gtfsRouteId,  int routeType,  String? textColor,  String agencyName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteDetail() when $default != null:
return $default(_that.id,_that.shortName,_that.longName,_that.color,_that.gtfsRouteId,_that.routeType,_that.textColor,_that.agencyName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? shortName,  String? longName,  String? color,  String gtfsRouteId,  int routeType,  String? textColor,  String agencyName)  $default,) {final _that = this;
switch (_that) {
case _RouteDetail():
return $default(_that.id,_that.shortName,_that.longName,_that.color,_that.gtfsRouteId,_that.routeType,_that.textColor,_that.agencyName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? shortName,  String? longName,  String? color,  String gtfsRouteId,  int routeType,  String? textColor,  String agencyName)?  $default,) {final _that = this;
switch (_that) {
case _RouteDetail() when $default != null:
return $default(_that.id,_that.shortName,_that.longName,_that.color,_that.gtfsRouteId,_that.routeType,_that.textColor,_that.agencyName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteDetail implements RouteDetail {
  const _RouteDetail({required this.id, this.shortName, this.longName, this.color, required this.gtfsRouteId, required this.routeType, this.textColor, required this.agencyName});
  factory _RouteDetail.fromJson(Map<String, dynamic> json) => _$RouteDetailFromJson(json);

@override final  int id;
@override final  String? shortName;
@override final  String? longName;
@override final  String? color;
@override final  String gtfsRouteId;
@override final  int routeType;
@override final  String? textColor;
@override final  String agencyName;

/// Create a copy of RouteDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteDetailCopyWith<_RouteDetail> get copyWith => __$RouteDetailCopyWithImpl<_RouteDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.shortName, shortName) || other.shortName == shortName)&&(identical(other.longName, longName) || other.longName == longName)&&(identical(other.color, color) || other.color == color)&&(identical(other.gtfsRouteId, gtfsRouteId) || other.gtfsRouteId == gtfsRouteId)&&(identical(other.routeType, routeType) || other.routeType == routeType)&&(identical(other.textColor, textColor) || other.textColor == textColor)&&(identical(other.agencyName, agencyName) || other.agencyName == agencyName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,shortName,longName,color,gtfsRouteId,routeType,textColor,agencyName);
}

@override
String toString() {
    return 'RouteDetail(id: $id, shortName: $shortName, longName: $longName, color: $color, gtfsRouteId: $gtfsRouteId, routeType: $routeType, textColor: $textColor, agencyName: $agencyName)';
}


}

/// @nodoc
abstract mixin class _$RouteDetailCopyWith<$Res> implements $RouteDetailCopyWith<$Res> {
  factory _$RouteDetailCopyWith(_RouteDetail value, $Res Function(_RouteDetail) _then) = __$RouteDetailCopyWithImpl;
@override @useResult
$Res call({
 int id, String? shortName, String? longName, String? color, String gtfsRouteId, int routeType, String? textColor, String agencyName
});




}
/// @nodoc
class __$RouteDetailCopyWithImpl<$Res>
    implements _$RouteDetailCopyWith<$Res> {
  __$RouteDetailCopyWithImpl(this._self, this._then);

  final _RouteDetail _self;
  final $Res Function(_RouteDetail) _then;

/// Create a copy of RouteDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? shortName = freezed,Object? longName = freezed,Object? color = freezed,Object? gtfsRouteId = null,Object? routeType = null,Object? textColor = freezed,Object? agencyName = null,}) {
  return _then(_RouteDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,shortName: freezed == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String?,longName: freezed == longName ? _self.longName : longName // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,gtfsRouteId: null == gtfsRouteId ? _self.gtfsRouteId : gtfsRouteId // ignore: cast_nullable_to_non_nullable
as String,routeType: null == routeType ? _self.routeType : routeType // ignore: cast_nullable_to_non_nullable
as int,textColor: freezed == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as String?,agencyName: null == agencyName ? _self.agencyName : agencyName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RouteShape {

 String get type; List<List<double>> get coordinates;
/// Create a copy of RouteShape
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteShapeCopyWith<RouteShape> get copyWith => _$RouteShapeCopyWithImpl<RouteShape>(this as RouteShape, _$identity);

  /// Serializes this RouteShape to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteShape;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteShape&&(identical(other.type, _this.type) || other.type == _this.type)&&const DeepCollectionEquality().equals(other.coordinates, _this.coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteShape;
  return Object.hash(runtimeType,_this.type,const DeepCollectionEquality().hash(_this.coordinates));
}

@override
String toString() {
  final _this = this as RouteShape;
  return 'RouteShape(type: ${_this.type}, coordinates: ${_this.coordinates})';
}


}

/// @nodoc
abstract mixin class $RouteShapeCopyWith<$Res>  {
  factory $RouteShapeCopyWith(RouteShape value, $Res Function(RouteShape) _then) = _$RouteShapeCopyWithImpl;
@useResult
$Res call({
 String type, List<List<double>> coordinates
});




}
/// @nodoc
class _$RouteShapeCopyWithImpl<$Res>
    implements $RouteShapeCopyWith<$Res> {
  _$RouteShapeCopyWithImpl(this._self, this._then);

  final RouteShape _self;
  final $Res Function(RouteShape) _then;

/// Create a copy of RouteShape
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? coordinates = null,}) {
  return _then(RouteShape(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,coordinates: null == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<List<double>>,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteShape].
extension RouteShapePatterns on RouteShape {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteShape value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteShape() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteShape value)  $default,){
final _that = this;
switch (_that) {
case _RouteShape():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteShape value)?  $default,){
final _that = this;
switch (_that) {
case _RouteShape() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  List<List<double>> coordinates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteShape() when $default != null:
return $default(_that.type,_that.coordinates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  List<List<double>> coordinates)  $default,) {final _that = this;
switch (_that) {
case _RouteShape():
return $default(_that.type,_that.coordinates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  List<List<double>> coordinates)?  $default,) {final _that = this;
switch (_that) {
case _RouteShape() when $default != null:
return $default(_that.type,_that.coordinates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteShape implements RouteShape {
  const _RouteShape({required this.type, required  List<List<double>> coordinates}): _coordinates = coordinates;
  factory _RouteShape.fromJson(Map<String, dynamic> json) => _$RouteShapeFromJson(json);

@override final  String type;
 final  List<List<double>> _coordinates;
@override List<List<double>> get coordinates {
  if (_coordinates is EqualUnmodifiableListView) return _coordinates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coordinates);
}


/// Create a copy of RouteShape
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteShapeCopyWith<_RouteShape> get copyWith => __$RouteShapeCopyWithImpl<_RouteShape>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteShapeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteShape&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.coordinates, _coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_coordinates));
}

@override
String toString() {
    return 'RouteShape(type: $type, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class _$RouteShapeCopyWith<$Res> implements $RouteShapeCopyWith<$Res> {
  factory _$RouteShapeCopyWith(_RouteShape value, $Res Function(_RouteShape) _then) = __$RouteShapeCopyWithImpl;
@override @useResult
$Res call({
 String type, List<List<double>> coordinates
});




}
/// @nodoc
class __$RouteShapeCopyWithImpl<$Res>
    implements _$RouteShapeCopyWith<$Res> {
  __$RouteShapeCopyWithImpl(this._self, this._then);

  final _RouteShape _self;
  final $Res Function(_RouteShape) _then;

/// Create a copy of RouteShape
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? coordinates = null,}) {
  return _then(_RouteShape(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,coordinates: null == coordinates ? _self._coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<List<double>>,
  ));
}


}


/// @nodoc
mixin _$TripSummary {

 int get id; String? get headsign; int? get directionId; String get startsAt; String get endsAt;
/// Create a copy of TripSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripSummaryCopyWith<TripSummary> get copyWith => _$TripSummaryCopyWithImpl<TripSummary>(this as TripSummary, _$identity);

  /// Serializes this TripSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TripSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.headsign, _this.headsign) || other.headsign == _this.headsign)&&(identical(other.directionId, _this.directionId) || other.directionId == _this.directionId)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TripSummary;
  return Object.hash(runtimeType,_this.id,_this.headsign,_this.directionId,_this.startsAt,_this.endsAt);
}

@override
String toString() {
  final _this = this as TripSummary;
  return 'TripSummary(id: ${_this.id}, headsign: ${_this.headsign}, directionId: ${_this.directionId}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt})';
}


}

/// @nodoc
abstract mixin class $TripSummaryCopyWith<$Res>  {
  factory $TripSummaryCopyWith(TripSummary value, $Res Function(TripSummary) _then) = _$TripSummaryCopyWithImpl;
@useResult
$Res call({
 int id, String? headsign, int? directionId, String startsAt, String endsAt
});




}
/// @nodoc
class _$TripSummaryCopyWithImpl<$Res>
    implements $TripSummaryCopyWith<$Res> {
  _$TripSummaryCopyWithImpl(this._self, this._then);

  final TripSummary _self;
  final $Res Function(TripSummary) _then;

/// Create a copy of TripSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? headsign = freezed,Object? directionId = freezed,Object? startsAt = null,Object? endsAt = null,}) {
  return _then(TripSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,headsign: freezed == headsign ? _self.headsign : headsign // ignore: cast_nullable_to_non_nullable
as String?,directionId: freezed == directionId ? _self.directionId : directionId // ignore: cast_nullable_to_non_nullable
as int?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as String,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TripSummary].
extension TripSummaryPatterns on TripSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripSummary value)  $default,){
final _that = this;
switch (_that) {
case _TripSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TripSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? headsign,  int? directionId,  String startsAt,  String endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripSummary() when $default != null:
return $default(_that.id,_that.headsign,_that.directionId,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? headsign,  int? directionId,  String startsAt,  String endsAt)  $default,) {final _that = this;
switch (_that) {
case _TripSummary():
return $default(_that.id,_that.headsign,_that.directionId,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? headsign,  int? directionId,  String startsAt,  String endsAt)?  $default,) {final _that = this;
switch (_that) {
case _TripSummary() when $default != null:
return $default(_that.id,_that.headsign,_that.directionId,_that.startsAt,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripSummary implements TripSummary {
  const _TripSummary({required this.id, this.headsign, this.directionId, required this.startsAt, required this.endsAt});
  factory _TripSummary.fromJson(Map<String, dynamic> json) => _$TripSummaryFromJson(json);

@override final  int id;
@override final  String? headsign;
@override final  int? directionId;
@override final  String startsAt;
@override final  String endsAt;

/// Create a copy of TripSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripSummaryCopyWith<_TripSummary> get copyWith => __$TripSummaryCopyWithImpl<_TripSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.headsign, headsign) || other.headsign == headsign)&&(identical(other.directionId, directionId) || other.directionId == directionId)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,headsign,directionId,startsAt,endsAt);
}

@override
String toString() {
    return 'TripSummary(id: $id, headsign: $headsign, directionId: $directionId, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$TripSummaryCopyWith<$Res> implements $TripSummaryCopyWith<$Res> {
  factory _$TripSummaryCopyWith(_TripSummary value, $Res Function(_TripSummary) _then) = __$TripSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id, String? headsign, int? directionId, String startsAt, String endsAt
});




}
/// @nodoc
class __$TripSummaryCopyWithImpl<$Res>
    implements _$TripSummaryCopyWith<$Res> {
  __$TripSummaryCopyWithImpl(this._self, this._then);

  final _TripSummary _self;
  final $Res Function(_TripSummary) _then;

/// Create a copy of TripSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? headsign = freezed,Object? directionId = freezed,Object? startsAt = null,Object? endsAt = null,}) {
  return _then(_TripSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,headsign: freezed == headsign ? _self.headsign : headsign // ignore: cast_nullable_to_non_nullable
as String?,directionId: freezed == directionId ? _self.directionId : directionId // ignore: cast_nullable_to_non_nullable
as int?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as String,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TripStopTime {

 int get stopSequence; StopSummary get stop; String get arrivalTime; String get departureTime;
/// Create a copy of TripStopTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripStopTimeCopyWith<TripStopTime> get copyWith => _$TripStopTimeCopyWithImpl<TripStopTime>(this as TripStopTime, _$identity);

  /// Serializes this TripStopTime to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TripStopTime;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripStopTime&&(identical(other.stopSequence, _this.stopSequence) || other.stopSequence == _this.stopSequence)&&(identical(other.stop, _this.stop) || other.stop == _this.stop)&&(identical(other.arrivalTime, _this.arrivalTime) || other.arrivalTime == _this.arrivalTime)&&(identical(other.departureTime, _this.departureTime) || other.departureTime == _this.departureTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TripStopTime;
  return Object.hash(runtimeType,_this.stopSequence,_this.stop,_this.arrivalTime,_this.departureTime);
}

@override
String toString() {
  final _this = this as TripStopTime;
  return 'TripStopTime(stopSequence: ${_this.stopSequence}, stop: ${_this.stop}, arrivalTime: ${_this.arrivalTime}, departureTime: ${_this.departureTime})';
}


}

/// @nodoc
abstract mixin class $TripStopTimeCopyWith<$Res>  {
  factory $TripStopTimeCopyWith(TripStopTime value, $Res Function(TripStopTime) _then) = _$TripStopTimeCopyWithImpl;
@useResult
$Res call({
 int stopSequence, StopSummary stop, String arrivalTime, String departureTime
});


$StopSummaryCopyWith<$Res> get stop;

}
/// @nodoc
class _$TripStopTimeCopyWithImpl<$Res>
    implements $TripStopTimeCopyWith<$Res> {
  _$TripStopTimeCopyWithImpl(this._self, this._then);

  final TripStopTime _self;
  final $Res Function(TripStopTime) _then;

/// Create a copy of TripStopTime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stopSequence = null,Object? stop = null,Object? arrivalTime = null,Object? departureTime = null,}) {
  return _then(TripStopTime(
stopSequence: null == stopSequence ? _self.stopSequence : stopSequence // ignore: cast_nullable_to_non_nullable
as int,stop: null == stop ? _self.stop : stop // ignore: cast_nullable_to_non_nullable
as StopSummary,arrivalTime: null == arrivalTime ? _self.arrivalTime : arrivalTime // ignore: cast_nullable_to_non_nullable
as String,departureTime: null == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of TripStopTime
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StopSummaryCopyWith<$Res> get stop {
  
  return $StopSummaryCopyWith<$Res>(_self.stop, (value) {
    return _then(_self.copyWith(stop: value));
  });
}
}


/// Adds pattern-matching-related methods to [TripStopTime].
extension TripStopTimePatterns on TripStopTime {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripStopTime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripStopTime() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripStopTime value)  $default,){
final _that = this;
switch (_that) {
case _TripStopTime():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripStopTime value)?  $default,){
final _that = this;
switch (_that) {
case _TripStopTime() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int stopSequence,  StopSummary stop,  String arrivalTime,  String departureTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripStopTime() when $default != null:
return $default(_that.stopSequence,_that.stop,_that.arrivalTime,_that.departureTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int stopSequence,  StopSummary stop,  String arrivalTime,  String departureTime)  $default,) {final _that = this;
switch (_that) {
case _TripStopTime():
return $default(_that.stopSequence,_that.stop,_that.arrivalTime,_that.departureTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int stopSequence,  StopSummary stop,  String arrivalTime,  String departureTime)?  $default,) {final _that = this;
switch (_that) {
case _TripStopTime() when $default != null:
return $default(_that.stopSequence,_that.stop,_that.arrivalTime,_that.departureTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripStopTime implements TripStopTime {
  const _TripStopTime({required this.stopSequence, required this.stop, required this.arrivalTime, required this.departureTime});
  factory _TripStopTime.fromJson(Map<String, dynamic> json) => _$TripStopTimeFromJson(json);

@override final  int stopSequence;
@override final  StopSummary stop;
@override final  String arrivalTime;
@override final  String departureTime;

/// Create a copy of TripStopTime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripStopTimeCopyWith<_TripStopTime> get copyWith => __$TripStopTimeCopyWithImpl<_TripStopTime>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripStopTimeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripStopTime&&(identical(other.stopSequence, stopSequence) || other.stopSequence == stopSequence)&&(identical(other.stop, stop) || other.stop == stop)&&(identical(other.arrivalTime, arrivalTime) || other.arrivalTime == arrivalTime)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,stopSequence,stop,arrivalTime,departureTime);
}

@override
String toString() {
    return 'TripStopTime(stopSequence: $stopSequence, stop: $stop, arrivalTime: $arrivalTime, departureTime: $departureTime)';
}


}

/// @nodoc
abstract mixin class _$TripStopTimeCopyWith<$Res> implements $TripStopTimeCopyWith<$Res> {
  factory _$TripStopTimeCopyWith(_TripStopTime value, $Res Function(_TripStopTime) _then) = __$TripStopTimeCopyWithImpl;
@override @useResult
$Res call({
 int stopSequence, StopSummary stop, String arrivalTime, String departureTime
});


@override $StopSummaryCopyWith<$Res> get stop;

}
/// @nodoc
class __$TripStopTimeCopyWithImpl<$Res>
    implements _$TripStopTimeCopyWith<$Res> {
  __$TripStopTimeCopyWithImpl(this._self, this._then);

  final _TripStopTime _self;
  final $Res Function(_TripStopTime) _then;

/// Create a copy of TripStopTime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stopSequence = null,Object? stop = null,Object? arrivalTime = null,Object? departureTime = null,}) {
  return _then(_TripStopTime(
stopSequence: null == stopSequence ? _self.stopSequence : stopSequence // ignore: cast_nullable_to_non_nullable
as int,stop: null == stop ? _self.stop : stop // ignore: cast_nullable_to_non_nullable
as StopSummary,arrivalTime: null == arrivalTime ? _self.arrivalTime : arrivalTime // ignore: cast_nullable_to_non_nullable
as String,departureTime: null == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of TripStopTime
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StopSummaryCopyWith<$Res> get stop {
  
  return $StopSummaryCopyWith<$Res>(_self.stop, (value) {
    return _then(_self.copyWith(stop: value));
  });
}
}


/// @nodoc
mixin _$TripDetail {

 int get id; String get gtfsTripId; RouteSummary get route; String? get headsign; int? get directionId; List<TripStopTime> get stopTimes;
/// Create a copy of TripDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripDetailCopyWith<TripDetail> get copyWith => _$TripDetailCopyWithImpl<TripDetail>(this as TripDetail, _$identity);

  /// Serializes this TripDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TripDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.gtfsTripId, _this.gtfsTripId) || other.gtfsTripId == _this.gtfsTripId)&&(identical(other.route, _this.route) || other.route == _this.route)&&(identical(other.headsign, _this.headsign) || other.headsign == _this.headsign)&&(identical(other.directionId, _this.directionId) || other.directionId == _this.directionId)&&const DeepCollectionEquality().equals(other.stopTimes, _this.stopTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TripDetail;
  return Object.hash(runtimeType,_this.id,_this.gtfsTripId,_this.route,_this.headsign,_this.directionId,const DeepCollectionEquality().hash(_this.stopTimes));
}

@override
String toString() {
  final _this = this as TripDetail;
  return 'TripDetail(id: ${_this.id}, gtfsTripId: ${_this.gtfsTripId}, route: ${_this.route}, headsign: ${_this.headsign}, directionId: ${_this.directionId}, stopTimes: ${_this.stopTimes})';
}


}

/// @nodoc
abstract mixin class $TripDetailCopyWith<$Res>  {
  factory $TripDetailCopyWith(TripDetail value, $Res Function(TripDetail) _then) = _$TripDetailCopyWithImpl;
@useResult
$Res call({
 int id, String gtfsTripId, RouteSummary route, String? headsign, int? directionId, List<TripStopTime> stopTimes
});


$RouteSummaryCopyWith<$Res> get route;

}
/// @nodoc
class _$TripDetailCopyWithImpl<$Res>
    implements $TripDetailCopyWith<$Res> {
  _$TripDetailCopyWithImpl(this._self, this._then);

  final TripDetail _self;
  final $Res Function(TripDetail) _then;

/// Create a copy of TripDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gtfsTripId = null,Object? route = null,Object? headsign = freezed,Object? directionId = freezed,Object? stopTimes = null,}) {
  return _then(TripDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,gtfsTripId: null == gtfsTripId ? _self.gtfsTripId : gtfsTripId // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as RouteSummary,headsign: freezed == headsign ? _self.headsign : headsign // ignore: cast_nullable_to_non_nullable
as String?,directionId: freezed == directionId ? _self.directionId : directionId // ignore: cast_nullable_to_non_nullable
as int?,stopTimes: null == stopTimes ? _self.stopTimes : stopTimes // ignore: cast_nullable_to_non_nullable
as List<TripStopTime>,
  ));
}
/// Create a copy of TripDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteSummaryCopyWith<$Res> get route {
  
  return $RouteSummaryCopyWith<$Res>(_self.route, (value) {
    return _then(_self.copyWith(route: value));
  });
}
}


/// Adds pattern-matching-related methods to [TripDetail].
extension TripDetailPatterns on TripDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripDetail value)  $default,){
final _that = this;
switch (_that) {
case _TripDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripDetail value)?  $default,){
final _that = this;
switch (_that) {
case _TripDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String gtfsTripId,  RouteSummary route,  String? headsign,  int? directionId,  List<TripStopTime> stopTimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripDetail() when $default != null:
return $default(_that.id,_that.gtfsTripId,_that.route,_that.headsign,_that.directionId,_that.stopTimes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String gtfsTripId,  RouteSummary route,  String? headsign,  int? directionId,  List<TripStopTime> stopTimes)  $default,) {final _that = this;
switch (_that) {
case _TripDetail():
return $default(_that.id,_that.gtfsTripId,_that.route,_that.headsign,_that.directionId,_that.stopTimes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String gtfsTripId,  RouteSummary route,  String? headsign,  int? directionId,  List<TripStopTime> stopTimes)?  $default,) {final _that = this;
switch (_that) {
case _TripDetail() when $default != null:
return $default(_that.id,_that.gtfsTripId,_that.route,_that.headsign,_that.directionId,_that.stopTimes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripDetail implements TripDetail {
  const _TripDetail({required this.id, required this.gtfsTripId, required this.route, this.headsign, this.directionId, required  List<TripStopTime> stopTimes}): _stopTimes = stopTimes;
  factory _TripDetail.fromJson(Map<String, dynamic> json) => _$TripDetailFromJson(json);

@override final  int id;
@override final  String gtfsTripId;
@override final  RouteSummary route;
@override final  String? headsign;
@override final  int? directionId;
 final  List<TripStopTime> _stopTimes;
@override List<TripStopTime> get stopTimes {
  if (_stopTimes is EqualUnmodifiableListView) return _stopTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stopTimes);
}


/// Create a copy of TripDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripDetailCopyWith<_TripDetail> get copyWith => __$TripDetailCopyWithImpl<_TripDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.gtfsTripId, gtfsTripId) || other.gtfsTripId == gtfsTripId)&&(identical(other.route, route) || other.route == route)&&(identical(other.headsign, headsign) || other.headsign == headsign)&&(identical(other.directionId, directionId) || other.directionId == directionId)&&const DeepCollectionEquality().equals(other.stopTimes, _stopTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,gtfsTripId,route,headsign,directionId,const DeepCollectionEquality().hash(_stopTimes));
}

@override
String toString() {
    return 'TripDetail(id: $id, gtfsTripId: $gtfsTripId, route: $route, headsign: $headsign, directionId: $directionId, stopTimes: $stopTimes)';
}


}

/// @nodoc
abstract mixin class _$TripDetailCopyWith<$Res> implements $TripDetailCopyWith<$Res> {
  factory _$TripDetailCopyWith(_TripDetail value, $Res Function(_TripDetail) _then) = __$TripDetailCopyWithImpl;
@override @useResult
$Res call({
 int id, String gtfsTripId, RouteSummary route, String? headsign, int? directionId, List<TripStopTime> stopTimes
});


@override $RouteSummaryCopyWith<$Res> get route;

}
/// @nodoc
class __$TripDetailCopyWithImpl<$Res>
    implements _$TripDetailCopyWith<$Res> {
  __$TripDetailCopyWithImpl(this._self, this._then);

  final _TripDetail _self;
  final $Res Function(_TripDetail) _then;

/// Create a copy of TripDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gtfsTripId = null,Object? route = null,Object? headsign = freezed,Object? directionId = freezed,Object? stopTimes = null,}) {
  return _then(_TripDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,gtfsTripId: null == gtfsTripId ? _self.gtfsTripId : gtfsTripId // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as RouteSummary,headsign: freezed == headsign ? _self.headsign : headsign // ignore: cast_nullable_to_non_nullable
as String?,directionId: freezed == directionId ? _self.directionId : directionId // ignore: cast_nullable_to_non_nullable
as int?,stopTimes: null == stopTimes ? _self._stopTimes : stopTimes // ignore: cast_nullable_to_non_nullable
as List<TripStopTime>,
  ));
}

/// Create a copy of TripDetail
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
