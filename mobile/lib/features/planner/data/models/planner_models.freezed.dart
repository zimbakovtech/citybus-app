// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planner_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
PlanLeg _$PlanLegFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'ride':
          return PlanRideLeg.fromJson(
            json
          );
                case 'transfer':
          return PlanTransferLeg.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'PlanLeg',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$PlanLeg {



  /// Serializes this PlanLeg to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanLeg);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PlanLeg()';
}


}

/// @nodoc
class $PlanLegCopyWith<$Res>  {
$PlanLegCopyWith(PlanLeg _, $Res Function(PlanLeg) __);
}


/// Adds pattern-matching-related methods to [PlanLeg].
extension PlanLegPatterns on PlanLeg {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PlanRideLeg value)?  ride,TResult Function( PlanTransferLeg value)?  transfer,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PlanRideLeg() when ride != null:
return ride(_that);case PlanTransferLeg() when transfer != null:
return transfer(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PlanRideLeg value)  ride,required TResult Function( PlanTransferLeg value)  transfer,}){
final _that = this;
switch (_that) {
case PlanRideLeg():
return ride(_that);case PlanTransferLeg():
return transfer(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PlanRideLeg value)?  ride,TResult? Function( PlanTransferLeg value)?  transfer,}){
final _that = this;
switch (_that) {
case PlanRideLeg() when ride != null:
return ride(_that);case PlanTransferLeg() when transfer != null:
return transfer(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RouteSummary route,  int tripId,  StopSummary boardStop,  DateTime boardTime,  StopSummary alightStop,  DateTime alightTime,  int numStops)?  ride,TResult Function( StopSummary atStop,  int seconds)?  transfer,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PlanRideLeg() when ride != null:
return ride(_that.route,_that.tripId,_that.boardStop,_that.boardTime,_that.alightStop,_that.alightTime,_that.numStops);case PlanTransferLeg() when transfer != null:
return transfer(_that.atStop,_that.seconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RouteSummary route,  int tripId,  StopSummary boardStop,  DateTime boardTime,  StopSummary alightStop,  DateTime alightTime,  int numStops)  ride,required TResult Function( StopSummary atStop,  int seconds)  transfer,}) {final _that = this;
switch (_that) {
case PlanRideLeg():
return ride(_that.route,_that.tripId,_that.boardStop,_that.boardTime,_that.alightStop,_that.alightTime,_that.numStops);case PlanTransferLeg():
return transfer(_that.atStop,_that.seconds);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RouteSummary route,  int tripId,  StopSummary boardStop,  DateTime boardTime,  StopSummary alightStop,  DateTime alightTime,  int numStops)?  ride,TResult? Function( StopSummary atStop,  int seconds)?  transfer,}) {final _that = this;
switch (_that) {
case PlanRideLeg() when ride != null:
return ride(_that.route,_that.tripId,_that.boardStop,_that.boardTime,_that.alightStop,_that.alightTime,_that.numStops);case PlanTransferLeg() when transfer != null:
return transfer(_that.atStop,_that.seconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class PlanRideLeg implements PlanLeg {
  const PlanRideLeg({required this.route, required this.tripId, required this.boardStop, required this.boardTime, required this.alightStop, required this.alightTime, required this.numStops,  String? $type}): $type = $type ?? 'ride';
  factory PlanRideLeg.fromJson(Map<String, dynamic> json) => _$PlanRideLegFromJson(json);

 final  RouteSummary route;
 final  int tripId;
 final  StopSummary boardStop;
 final  DateTime boardTime;
 final  StopSummary alightStop;
 final  DateTime alightTime;
 final  int numStops;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of PlanLeg
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanRideLegCopyWith<PlanRideLeg> get copyWith => _$PlanRideLegCopyWithImpl<PlanRideLeg>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanRideLegToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanRideLeg&&(identical(other.route, route) || other.route == route)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.boardStop, boardStop) || other.boardStop == boardStop)&&(identical(other.boardTime, boardTime) || other.boardTime == boardTime)&&(identical(other.alightStop, alightStop) || other.alightStop == alightStop)&&(identical(other.alightTime, alightTime) || other.alightTime == alightTime)&&(identical(other.numStops, numStops) || other.numStops == numStops));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,route,tripId,boardStop,boardTime,alightStop,alightTime,numStops);
}

@override
String toString() {
    return 'PlanLeg.ride(route: $route, tripId: $tripId, boardStop: $boardStop, boardTime: $boardTime, alightStop: $alightStop, alightTime: $alightTime, numStops: $numStops)';
}


}

/// @nodoc
abstract mixin class $PlanRideLegCopyWith<$Res> implements $PlanLegCopyWith<$Res> {
  factory $PlanRideLegCopyWith(PlanRideLeg value, $Res Function(PlanRideLeg) _then) = _$PlanRideLegCopyWithImpl;
@useResult
$Res call({
 RouteSummary route, int tripId, StopSummary boardStop, DateTime boardTime, StopSummary alightStop, DateTime alightTime, int numStops
});


$RouteSummaryCopyWith<$Res> get route;$StopSummaryCopyWith<$Res> get boardStop;$StopSummaryCopyWith<$Res> get alightStop;

}
/// @nodoc
class _$PlanRideLegCopyWithImpl<$Res>
    implements $PlanRideLegCopyWith<$Res> {
  _$PlanRideLegCopyWithImpl(this._self, this._then);

  final PlanRideLeg _self;
  final $Res Function(PlanRideLeg) _then;

/// Create a copy of PlanLeg
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? route = null,Object? tripId = null,Object? boardStop = null,Object? boardTime = null,Object? alightStop = null,Object? alightTime = null,Object? numStops = null,}) {
  return _then(PlanRideLeg(
route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as RouteSummary,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int,boardStop: null == boardStop ? _self.boardStop : boardStop // ignore: cast_nullable_to_non_nullable
as StopSummary,boardTime: null == boardTime ? _self.boardTime : boardTime // ignore: cast_nullable_to_non_nullable
as DateTime,alightStop: null == alightStop ? _self.alightStop : alightStop // ignore: cast_nullable_to_non_nullable
as StopSummary,alightTime: null == alightTime ? _self.alightTime : alightTime // ignore: cast_nullable_to_non_nullable
as DateTime,numStops: null == numStops ? _self.numStops : numStops // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PlanLeg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteSummaryCopyWith<$Res> get route {
  
  return $RouteSummaryCopyWith<$Res>(_self.route, (value) {
    return _then(_self.copyWith(route: value));
  });
}/// Create a copy of PlanLeg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StopSummaryCopyWith<$Res> get boardStop {
  
  return $StopSummaryCopyWith<$Res>(_self.boardStop, (value) {
    return _then(_self.copyWith(boardStop: value));
  });
}/// Create a copy of PlanLeg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StopSummaryCopyWith<$Res> get alightStop {
  
  return $StopSummaryCopyWith<$Res>(_self.alightStop, (value) {
    return _then(_self.copyWith(alightStop: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class PlanTransferLeg implements PlanLeg {
  const PlanTransferLeg({required this.atStop, required this.seconds,  String? $type}): $type = $type ?? 'transfer';
  factory PlanTransferLeg.fromJson(Map<String, dynamic> json) => _$PlanTransferLegFromJson(json);

 final  StopSummary atStop;
 final  int seconds;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of PlanLeg
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanTransferLegCopyWith<PlanTransferLeg> get copyWith => _$PlanTransferLegCopyWithImpl<PlanTransferLeg>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanTransferLegToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanTransferLeg&&(identical(other.atStop, atStop) || other.atStop == atStop)&&(identical(other.seconds, seconds) || other.seconds == seconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,atStop,seconds);
}

@override
String toString() {
    return 'PlanLeg.transfer(atStop: $atStop, seconds: $seconds)';
}


}

/// @nodoc
abstract mixin class $PlanTransferLegCopyWith<$Res> implements $PlanLegCopyWith<$Res> {
  factory $PlanTransferLegCopyWith(PlanTransferLeg value, $Res Function(PlanTransferLeg) _then) = _$PlanTransferLegCopyWithImpl;
@useResult
$Res call({
 StopSummary atStop, int seconds
});


$StopSummaryCopyWith<$Res> get atStop;

}
/// @nodoc
class _$PlanTransferLegCopyWithImpl<$Res>
    implements $PlanTransferLegCopyWith<$Res> {
  _$PlanTransferLegCopyWithImpl(this._self, this._then);

  final PlanTransferLeg _self;
  final $Res Function(PlanTransferLeg) _then;

/// Create a copy of PlanLeg
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? atStop = null,Object? seconds = null,}) {
  return _then(PlanTransferLeg(
atStop: null == atStop ? _self.atStop : atStop // ignore: cast_nullable_to_non_nullable
as StopSummary,seconds: null == seconds ? _self.seconds : seconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PlanLeg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StopSummaryCopyWith<$Res> get atStop {
  
  return $StopSummaryCopyWith<$Res>(_self.atStop, (value) {
    return _then(_self.copyWith(atStop: value));
  });
}
}


/// @nodoc
mixin _$PlanResponse {

 bool get found; StopSummary get fromStop; StopSummary get toStop; DateTime get departAt; DateTime? get arriveAt; int? get durationSeconds; int? get transfers; List<PlanLeg> get legs;
/// Create a copy of PlanResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanResponseCopyWith<PlanResponse> get copyWith => _$PlanResponseCopyWithImpl<PlanResponse>(this as PlanResponse, _$identity);

  /// Serializes this PlanResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlanResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanResponse&&(identical(other.found, _this.found) || other.found == _this.found)&&(identical(other.fromStop, _this.fromStop) || other.fromStop == _this.fromStop)&&(identical(other.toStop, _this.toStop) || other.toStop == _this.toStop)&&(identical(other.departAt, _this.departAt) || other.departAt == _this.departAt)&&(identical(other.arriveAt, _this.arriveAt) || other.arriveAt == _this.arriveAt)&&(identical(other.durationSeconds, _this.durationSeconds) || other.durationSeconds == _this.durationSeconds)&&(identical(other.transfers, _this.transfers) || other.transfers == _this.transfers)&&const DeepCollectionEquality().equals(other.legs, _this.legs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlanResponse;
  return Object.hash(runtimeType,_this.found,_this.fromStop,_this.toStop,_this.departAt,_this.arriveAt,_this.durationSeconds,_this.transfers,const DeepCollectionEquality().hash(_this.legs));
}

@override
String toString() {
  final _this = this as PlanResponse;
  return 'PlanResponse(found: ${_this.found}, fromStop: ${_this.fromStop}, toStop: ${_this.toStop}, departAt: ${_this.departAt}, arriveAt: ${_this.arriveAt}, durationSeconds: ${_this.durationSeconds}, transfers: ${_this.transfers}, legs: ${_this.legs})';
}


}

/// @nodoc
abstract mixin class $PlanResponseCopyWith<$Res>  {
  factory $PlanResponseCopyWith(PlanResponse value, $Res Function(PlanResponse) _then) = _$PlanResponseCopyWithImpl;
@useResult
$Res call({
 bool found, StopSummary fromStop, StopSummary toStop, DateTime departAt, DateTime? arriveAt, int? durationSeconds, int? transfers, List<PlanLeg> legs
});


$StopSummaryCopyWith<$Res> get fromStop;$StopSummaryCopyWith<$Res> get toStop;

}
/// @nodoc
class _$PlanResponseCopyWithImpl<$Res>
    implements $PlanResponseCopyWith<$Res> {
  _$PlanResponseCopyWithImpl(this._self, this._then);

  final PlanResponse _self;
  final $Res Function(PlanResponse) _then;

/// Create a copy of PlanResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? found = null,Object? fromStop = null,Object? toStop = null,Object? departAt = null,Object? arriveAt = freezed,Object? durationSeconds = freezed,Object? transfers = freezed,Object? legs = null,}) {
  return _then(PlanResponse(
found: null == found ? _self.found : found // ignore: cast_nullable_to_non_nullable
as bool,fromStop: null == fromStop ? _self.fromStop : fromStop // ignore: cast_nullable_to_non_nullable
as StopSummary,toStop: null == toStop ? _self.toStop : toStop // ignore: cast_nullable_to_non_nullable
as StopSummary,departAt: null == departAt ? _self.departAt : departAt // ignore: cast_nullable_to_non_nullable
as DateTime,arriveAt: freezed == arriveAt ? _self.arriveAt : arriveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,transfers: freezed == transfers ? _self.transfers : transfers // ignore: cast_nullable_to_non_nullable
as int?,legs: null == legs ? _self.legs : legs // ignore: cast_nullable_to_non_nullable
as List<PlanLeg>,
  ));
}
/// Create a copy of PlanResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StopSummaryCopyWith<$Res> get fromStop {
  
  return $StopSummaryCopyWith<$Res>(_self.fromStop, (value) {
    return _then(_self.copyWith(fromStop: value));
  });
}/// Create a copy of PlanResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StopSummaryCopyWith<$Res> get toStop {
  
  return $StopSummaryCopyWith<$Res>(_self.toStop, (value) {
    return _then(_self.copyWith(toStop: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlanResponse].
extension PlanResponsePatterns on PlanResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanResponse value)  $default,){
final _that = this;
switch (_that) {
case _PlanResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PlanResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool found,  StopSummary fromStop,  StopSummary toStop,  DateTime departAt,  DateTime? arriveAt,  int? durationSeconds,  int? transfers,  List<PlanLeg> legs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanResponse() when $default != null:
return $default(_that.found,_that.fromStop,_that.toStop,_that.departAt,_that.arriveAt,_that.durationSeconds,_that.transfers,_that.legs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool found,  StopSummary fromStop,  StopSummary toStop,  DateTime departAt,  DateTime? arriveAt,  int? durationSeconds,  int? transfers,  List<PlanLeg> legs)  $default,) {final _that = this;
switch (_that) {
case _PlanResponse():
return $default(_that.found,_that.fromStop,_that.toStop,_that.departAt,_that.arriveAt,_that.durationSeconds,_that.transfers,_that.legs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool found,  StopSummary fromStop,  StopSummary toStop,  DateTime departAt,  DateTime? arriveAt,  int? durationSeconds,  int? transfers,  List<PlanLeg> legs)?  $default,) {final _that = this;
switch (_that) {
case _PlanResponse() when $default != null:
return $default(_that.found,_that.fromStop,_that.toStop,_that.departAt,_that.arriveAt,_that.durationSeconds,_that.transfers,_that.legs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanResponse implements PlanResponse {
  const _PlanResponse({required this.found, required this.fromStop, required this.toStop, required this.departAt, this.arriveAt, this.durationSeconds, this.transfers, required  List<PlanLeg> legs}): _legs = legs;
  factory _PlanResponse.fromJson(Map<String, dynamic> json) => _$PlanResponseFromJson(json);

@override final  bool found;
@override final  StopSummary fromStop;
@override final  StopSummary toStop;
@override final  DateTime departAt;
@override final  DateTime? arriveAt;
@override final  int? durationSeconds;
@override final  int? transfers;
 final  List<PlanLeg> _legs;
@override List<PlanLeg> get legs {
  if (_legs is EqualUnmodifiableListView) return _legs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_legs);
}


/// Create a copy of PlanResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanResponseCopyWith<_PlanResponse> get copyWith => __$PlanResponseCopyWithImpl<_PlanResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanResponse&&(identical(other.found, found) || other.found == found)&&(identical(other.fromStop, fromStop) || other.fromStop == fromStop)&&(identical(other.toStop, toStop) || other.toStop == toStop)&&(identical(other.departAt, departAt) || other.departAt == departAt)&&(identical(other.arriveAt, arriveAt) || other.arriveAt == arriveAt)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.transfers, transfers) || other.transfers == transfers)&&const DeepCollectionEquality().equals(other.legs, _legs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,found,fromStop,toStop,departAt,arriveAt,durationSeconds,transfers,const DeepCollectionEquality().hash(_legs));
}

@override
String toString() {
    return 'PlanResponse(found: $found, fromStop: $fromStop, toStop: $toStop, departAt: $departAt, arriveAt: $arriveAt, durationSeconds: $durationSeconds, transfers: $transfers, legs: $legs)';
}


}

/// @nodoc
abstract mixin class _$PlanResponseCopyWith<$Res> implements $PlanResponseCopyWith<$Res> {
  factory _$PlanResponseCopyWith(_PlanResponse value, $Res Function(_PlanResponse) _then) = __$PlanResponseCopyWithImpl;
@override @useResult
$Res call({
 bool found, StopSummary fromStop, StopSummary toStop, DateTime departAt, DateTime? arriveAt, int? durationSeconds, int? transfers, List<PlanLeg> legs
});


@override $StopSummaryCopyWith<$Res> get fromStop;@override $StopSummaryCopyWith<$Res> get toStop;

}
/// @nodoc
class __$PlanResponseCopyWithImpl<$Res>
    implements _$PlanResponseCopyWith<$Res> {
  __$PlanResponseCopyWithImpl(this._self, this._then);

  final _PlanResponse _self;
  final $Res Function(_PlanResponse) _then;

/// Create a copy of PlanResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? found = null,Object? fromStop = null,Object? toStop = null,Object? departAt = null,Object? arriveAt = freezed,Object? durationSeconds = freezed,Object? transfers = freezed,Object? legs = null,}) {
  return _then(_PlanResponse(
found: null == found ? _self.found : found // ignore: cast_nullable_to_non_nullable
as bool,fromStop: null == fromStop ? _self.fromStop : fromStop // ignore: cast_nullable_to_non_nullable
as StopSummary,toStop: null == toStop ? _self.toStop : toStop // ignore: cast_nullable_to_non_nullable
as StopSummary,departAt: null == departAt ? _self.departAt : departAt // ignore: cast_nullable_to_non_nullable
as DateTime,arriveAt: freezed == arriveAt ? _self.arriveAt : arriveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,transfers: freezed == transfers ? _self.transfers : transfers // ignore: cast_nullable_to_non_nullable
as int?,legs: null == legs ? _self._legs : legs // ignore: cast_nullable_to_non_nullable
as List<PlanLeg>,
  ));
}

/// Create a copy of PlanResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StopSummaryCopyWith<$Res> get fromStop {
  
  return $StopSummaryCopyWith<$Res>(_self.fromStop, (value) {
    return _then(_self.copyWith(fromStop: value));
  });
}/// Create a copy of PlanResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StopSummaryCopyWith<$Res> get toStop {
  
  return $StopSummaryCopyWith<$Res>(_self.toStop, (value) {
    return _then(_self.copyWith(toStop: value));
  });
}
}

// dart format on
