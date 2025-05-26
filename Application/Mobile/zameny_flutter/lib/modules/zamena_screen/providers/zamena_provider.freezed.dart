// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zamena_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ZamenaScreenState {

 DateTime get currentDate; ZamenaViewType get view; DateTimeRange get visibleDateRange;
/// Create a copy of ZamenaScreenState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZamenaScreenStateCopyWith<ZamenaScreenState> get copyWith => _$ZamenaScreenStateCopyWithImpl<ZamenaScreenState>(this as ZamenaScreenState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ZamenaScreenState&&(identical(other.currentDate, currentDate) || other.currentDate == currentDate)&&(identical(other.view, view) || other.view == view)&&(identical(other.visibleDateRange, visibleDateRange) || other.visibleDateRange == visibleDateRange));
}


@override
int get hashCode => Object.hash(runtimeType,currentDate,view,visibleDateRange);

@override
String toString() {
  return 'ZamenaScreenState(currentDate: $currentDate, view: $view, visibleDateRange: $visibleDateRange)';
}


}

/// @nodoc
abstract mixin class $ZamenaScreenStateCopyWith<$Res>  {
  factory $ZamenaScreenStateCopyWith(ZamenaScreenState value, $Res Function(ZamenaScreenState) _then) = _$ZamenaScreenStateCopyWithImpl;
@useResult
$Res call({
 DateTime currentDate, ZamenaViewType view, DateTimeRange visibleDateRange
});




}
/// @nodoc
class _$ZamenaScreenStateCopyWithImpl<$Res>
    implements $ZamenaScreenStateCopyWith<$Res> {
  _$ZamenaScreenStateCopyWithImpl(this._self, this._then);

  final ZamenaScreenState _self;
  final $Res Function(ZamenaScreenState) _then;

/// Create a copy of ZamenaScreenState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentDate = null,Object? view = null,Object? visibleDateRange = null,}) {
  return _then(_self.copyWith(
currentDate: null == currentDate ? _self.currentDate : currentDate // ignore: cast_nullable_to_non_nullable
as DateTime,view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as ZamenaViewType,visibleDateRange: null == visibleDateRange ? _self.visibleDateRange : visibleDateRange // ignore: cast_nullable_to_non_nullable
as DateTimeRange,
  ));
}

}


/// @nodoc


class _ZamenaScreenState implements ZamenaScreenState {
   _ZamenaScreenState({required this.currentDate, required this.view, required this.visibleDateRange});
  

@override final  DateTime currentDate;
@override final  ZamenaViewType view;
@override final  DateTimeRange visibleDateRange;

/// Create a copy of ZamenaScreenState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ZamenaScreenStateCopyWith<_ZamenaScreenState> get copyWith => __$ZamenaScreenStateCopyWithImpl<_ZamenaScreenState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ZamenaScreenState&&(identical(other.currentDate, currentDate) || other.currentDate == currentDate)&&(identical(other.view, view) || other.view == view)&&(identical(other.visibleDateRange, visibleDateRange) || other.visibleDateRange == visibleDateRange));
}


@override
int get hashCode => Object.hash(runtimeType,currentDate,view,visibleDateRange);

@override
String toString() {
  return 'ZamenaScreenState(currentDate: $currentDate, view: $view, visibleDateRange: $visibleDateRange)';
}


}

/// @nodoc
abstract mixin class _$ZamenaScreenStateCopyWith<$Res> implements $ZamenaScreenStateCopyWith<$Res> {
  factory _$ZamenaScreenStateCopyWith(_ZamenaScreenState value, $Res Function(_ZamenaScreenState) _then) = __$ZamenaScreenStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime currentDate, ZamenaViewType view, DateTimeRange visibleDateRange
});




}
/// @nodoc
class __$ZamenaScreenStateCopyWithImpl<$Res>
    implements _$ZamenaScreenStateCopyWith<$Res> {
  __$ZamenaScreenStateCopyWithImpl(this._self, this._then);

  final _ZamenaScreenState _self;
  final $Res Function(_ZamenaScreenState) _then;

/// Create a copy of ZamenaScreenState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentDate = null,Object? view = null,Object? visibleDateRange = null,}) {
  return _then(_ZamenaScreenState(
currentDate: null == currentDate ? _self.currentDate : currentDate // ignore: cast_nullable_to_non_nullable
as DateTime,view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as ZamenaViewType,visibleDateRange: null == visibleDateRange ? _self.visibleDateRange : visibleDateRange // ignore: cast_nullable_to_non_nullable
as DateTimeRange,
  ));
}


}

// dart format on
