// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState()';
}


}

/// @nodoc
class $HomeStateCopyWith<$Res>  {
$HomeStateCopyWith(HomeState _, $Res Function(HomeState) __);
}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( SpecializationsLoading value)?  specializationsLoading,TResult Function( SpecializationsSuccess value)?  specializationsSuccess,TResult Function( SpecializationsError value)?  specializationsError,TResult Function( VenuesSuccess value)?  venuesSuccess,TResult Function( VenuesError value)?  venuesError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case SpecializationsLoading() when specializationsLoading != null:
return specializationsLoading(_that);case SpecializationsSuccess() when specializationsSuccess != null:
return specializationsSuccess(_that);case SpecializationsError() when specializationsError != null:
return specializationsError(_that);case VenuesSuccess() when venuesSuccess != null:
return venuesSuccess(_that);case VenuesError() when venuesError != null:
return venuesError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( SpecializationsLoading value)  specializationsLoading,required TResult Function( SpecializationsSuccess value)  specializationsSuccess,required TResult Function( SpecializationsError value)  specializationsError,required TResult Function( VenuesSuccess value)  venuesSuccess,required TResult Function( VenuesError value)  venuesError,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case SpecializationsLoading():
return specializationsLoading(_that);case SpecializationsSuccess():
return specializationsSuccess(_that);case SpecializationsError():
return specializationsError(_that);case VenuesSuccess():
return venuesSuccess(_that);case VenuesError():
return venuesError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( SpecializationsLoading value)?  specializationsLoading,TResult? Function( SpecializationsSuccess value)?  specializationsSuccess,TResult? Function( SpecializationsError value)?  specializationsError,TResult? Function( VenuesSuccess value)?  venuesSuccess,TResult? Function( VenuesError value)?  venuesError,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case SpecializationsLoading() when specializationsLoading != null:
return specializationsLoading(_that);case SpecializationsSuccess() when specializationsSuccess != null:
return specializationsSuccess(_that);case SpecializationsError() when specializationsError != null:
return specializationsError(_that);case VenuesSuccess() when venuesSuccess != null:
return venuesSuccess(_that);case VenuesError() when venuesError != null:
return venuesError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  specializationsLoading,TResult Function( List<SpecializationsData?>? specializationDataList)?  specializationsSuccess,TResult Function( ErrorState errorState)?  specializationsError,TResult Function( List<Doctors?>? venuesList)?  venuesSuccess,TResult Function( ErrorState errorState)?  venuesError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case SpecializationsLoading() when specializationsLoading != null:
return specializationsLoading();case SpecializationsSuccess() when specializationsSuccess != null:
return specializationsSuccess(_that.specializationDataList);case SpecializationsError() when specializationsError != null:
return specializationsError(_that.errorState);case VenuesSuccess() when venuesSuccess != null:
return venuesSuccess(_that.venuesList);case VenuesError() when venuesError != null:
return venuesError(_that.errorState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  specializationsLoading,required TResult Function( List<SpecializationsData?>? specializationDataList)  specializationsSuccess,required TResult Function( ErrorState errorState)  specializationsError,required TResult Function( List<Doctors?>? venuesList)  venuesSuccess,required TResult Function( ErrorState errorState)  venuesError,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case SpecializationsLoading():
return specializationsLoading();case SpecializationsSuccess():
return specializationsSuccess(_that.specializationDataList);case SpecializationsError():
return specializationsError(_that.errorState);case VenuesSuccess():
return venuesSuccess(_that.venuesList);case VenuesError():
return venuesError(_that.errorState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  specializationsLoading,TResult? Function( List<SpecializationsData?>? specializationDataList)?  specializationsSuccess,TResult? Function( ErrorState errorState)?  specializationsError,TResult? Function( List<Doctors?>? venuesList)?  venuesSuccess,TResult? Function( ErrorState errorState)?  venuesError,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case SpecializationsLoading() when specializationsLoading != null:
return specializationsLoading();case SpecializationsSuccess() when specializationsSuccess != null:
return specializationsSuccess(_that.specializationDataList);case SpecializationsError() when specializationsError != null:
return specializationsError(_that.errorState);case VenuesSuccess() when venuesSuccess != null:
return venuesSuccess(_that.venuesList);case VenuesError() when venuesError != null:
return venuesError(_that.errorState);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements HomeState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState.initial()';
}


}




/// @nodoc


class SpecializationsLoading implements HomeState {
  const SpecializationsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecializationsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState.specializationsLoading()';
}


}




/// @nodoc


class SpecializationsSuccess implements HomeState {
  const SpecializationsSuccess(final  List<SpecializationsData?>? specializationDataList): _specializationDataList = specializationDataList;
  

 final  List<SpecializationsData?>? _specializationDataList;
 List<SpecializationsData?>? get specializationDataList {
  final value = _specializationDataList;
  if (value == null) return null;
  if (_specializationDataList is EqualUnmodifiableListView) return _specializationDataList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpecializationsSuccessCopyWith<SpecializationsSuccess> get copyWith => _$SpecializationsSuccessCopyWithImpl<SpecializationsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecializationsSuccess&&const DeepCollectionEquality().equals(other._specializationDataList, _specializationDataList));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_specializationDataList));

@override
String toString() {
  return 'HomeState.specializationsSuccess(specializationDataList: $specializationDataList)';
}


}

/// @nodoc
abstract mixin class $SpecializationsSuccessCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory $SpecializationsSuccessCopyWith(SpecializationsSuccess value, $Res Function(SpecializationsSuccess) _then) = _$SpecializationsSuccessCopyWithImpl;
@useResult
$Res call({
 List<SpecializationsData?>? specializationDataList
});




}
/// @nodoc
class _$SpecializationsSuccessCopyWithImpl<$Res>
    implements $SpecializationsSuccessCopyWith<$Res> {
  _$SpecializationsSuccessCopyWithImpl(this._self, this._then);

  final SpecializationsSuccess _self;
  final $Res Function(SpecializationsSuccess) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? specializationDataList = freezed,}) {
  return _then(SpecializationsSuccess(
freezed == specializationDataList ? _self._specializationDataList : specializationDataList // ignore: cast_nullable_to_non_nullable
as List<SpecializationsData?>?,
  ));
}


}

/// @nodoc


class SpecializationsError implements HomeState {
  const SpecializationsError(this.errorState);
  

 final  ErrorState errorState;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpecializationsErrorCopyWith<SpecializationsError> get copyWith => _$SpecializationsErrorCopyWithImpl<SpecializationsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecializationsError&&(identical(other.errorState, errorState) || other.errorState == errorState));
}


@override
int get hashCode => Object.hash(runtimeType,errorState);

@override
String toString() {
  return 'HomeState.specializationsError(errorState: $errorState)';
}


}

/// @nodoc
abstract mixin class $SpecializationsErrorCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory $SpecializationsErrorCopyWith(SpecializationsError value, $Res Function(SpecializationsError) _then) = _$SpecializationsErrorCopyWithImpl;
@useResult
$Res call({
 ErrorState errorState
});




}
/// @nodoc
class _$SpecializationsErrorCopyWithImpl<$Res>
    implements $SpecializationsErrorCopyWith<$Res> {
  _$SpecializationsErrorCopyWithImpl(this._self, this._then);

  final SpecializationsError _self;
  final $Res Function(SpecializationsError) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorState = null,}) {
  return _then(SpecializationsError(
null == errorState ? _self.errorState : errorState // ignore: cast_nullable_to_non_nullable
as ErrorState,
  ));
}


}

/// @nodoc


class VenuesSuccess implements HomeState {
  const VenuesSuccess(final  List<Doctors?>? venuesList): _venuesList = venuesList;
  

 final  List<Doctors?>? _venuesList;
 List<Doctors?>? get venuesList {
  final value = _venuesList;
  if (value == null) return null;
  if (_venuesList is EqualUnmodifiableListView) return _venuesList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VenuesSuccessCopyWith<VenuesSuccess> get copyWith => _$VenuesSuccessCopyWithImpl<VenuesSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VenuesSuccess&&const DeepCollectionEquality().equals(other._venuesList, _venuesList));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_venuesList));

@override
String toString() {
  return 'HomeState.venuesSuccess(venuesList: $venuesList)';
}


}

/// @nodoc
abstract mixin class $VenuesSuccessCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory $VenuesSuccessCopyWith(VenuesSuccess value, $Res Function(VenuesSuccess) _then) = _$VenuesSuccessCopyWithImpl;
@useResult
$Res call({
 List<Doctors?>? venuesList
});




}
/// @nodoc
class _$VenuesSuccessCopyWithImpl<$Res>
    implements $VenuesSuccessCopyWith<$Res> {
  _$VenuesSuccessCopyWithImpl(this._self, this._then);

  final VenuesSuccess _self;
  final $Res Function(VenuesSuccess) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? venuesList = freezed,}) {
  return _then(VenuesSuccess(
freezed == venuesList ? _self._venuesList : venuesList // ignore: cast_nullable_to_non_nullable
as List<Doctors?>?,
  ));
}


}

/// @nodoc


class VenuesError implements HomeState {
  const VenuesError(this.errorState);
  

 final  ErrorState errorState;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VenuesErrorCopyWith<VenuesError> get copyWith => _$VenuesErrorCopyWithImpl<VenuesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VenuesError&&(identical(other.errorState, errorState) || other.errorState == errorState));
}


@override
int get hashCode => Object.hash(runtimeType,errorState);

@override
String toString() {
  return 'HomeState.venuesError(errorState: $errorState)';
}


}

/// @nodoc
abstract mixin class $VenuesErrorCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory $VenuesErrorCopyWith(VenuesError value, $Res Function(VenuesError) _then) = _$VenuesErrorCopyWithImpl;
@useResult
$Res call({
 ErrorState errorState
});




}
/// @nodoc
class _$VenuesErrorCopyWithImpl<$Res>
    implements $VenuesErrorCopyWith<$Res> {
  _$VenuesErrorCopyWithImpl(this._self, this._then);

  final VenuesError _self;
  final $Res Function(VenuesError) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorState = null,}) {
  return _then(VenuesError(
null == errorState ? _self.errorState : errorState // ignore: cast_nullable_to_non_nullable
as ErrorState,
  ));
}


}

// dart format on
