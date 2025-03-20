// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_table_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeTableState {
  bool get saturday;
  bool get obed;

  /// Create a copy of TimeTableState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimeTableStateCopyWith<TimeTableState> get copyWith =>
      _$TimeTableStateCopyWithImpl<TimeTableState>(
          this as TimeTableState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimeTableState &&
            (identical(other.saturday, saturday) ||
                other.saturday == saturday) &&
            (identical(other.obed, obed) || other.obed == obed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, saturday, obed);

  @override
  String toString() {
    return 'TimeTableState(saturday: $saturday, obed: $obed)';
  }
}

/// @nodoc
abstract mixin class $TimeTableStateCopyWith<$Res> {
  factory $TimeTableStateCopyWith(
          TimeTableState value, $Res Function(TimeTableState) _then) =
      _$TimeTableStateCopyWithImpl;
  @useResult
  $Res call({bool saturday, bool obed});
}

/// @nodoc
class _$TimeTableStateCopyWithImpl<$Res>
    implements $TimeTableStateCopyWith<$Res> {
  _$TimeTableStateCopyWithImpl(this._self, this._then);

  final TimeTableState _self;
  final $Res Function(TimeTableState) _then;

  /// Create a copy of TimeTableState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? saturday = null,
    Object? obed = null,
  }) {
    return _then(_self.copyWith(
      saturday: null == saturday
          ? _self.saturday
          : saturday // ignore: cast_nullable_to_non_nullable
              as bool,
      obed: null == obed
          ? _self.obed
          : obed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _TimeTableState implements TimeTableState {
  _TimeTableState({required this.saturday, required this.obed});

  @override
  final bool saturday;
  @override
  final bool obed;

  /// Create a copy of TimeTableState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TimeTableStateCopyWith<_TimeTableState> get copyWith =>
      __$TimeTableStateCopyWithImpl<_TimeTableState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TimeTableState &&
            (identical(other.saturday, saturday) ||
                other.saturday == saturday) &&
            (identical(other.obed, obed) || other.obed == obed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, saturday, obed);

  @override
  String toString() {
    return 'TimeTableState(saturday: $saturday, obed: $obed)';
  }
}

/// @nodoc
abstract mixin class _$TimeTableStateCopyWith<$Res>
    implements $TimeTableStateCopyWith<$Res> {
  factory _$TimeTableStateCopyWith(
          _TimeTableState value, $Res Function(_TimeTableState) _then) =
      __$TimeTableStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool saturday, bool obed});
}

/// @nodoc
class __$TimeTableStateCopyWithImpl<$Res>
    implements _$TimeTableStateCopyWith<$Res> {
  __$TimeTableStateCopyWithImpl(this._self, this._then);

  final _TimeTableState _self;
  final $Res Function(_TimeTableState) _then;

  /// Create a copy of TimeTableState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? saturday = null,
    Object? obed = null,
  }) {
    return _then(_TimeTableState(
      saturday: null == saturday
          ? _self.saturday
          : saturday // ignore: cast_nullable_to_non_nullable
              as bool,
      obed: null == obed
          ? _self.obed
          : obed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
