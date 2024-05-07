// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LnUrlCallbackStatus {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() ok,
    required TResult Function(LnUrlErrorData data) errorStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? ok,
    TResult? Function(LnUrlErrorData data)? errorStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? ok,
    TResult Function(LnUrlErrorData data)? errorStatus,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LnUrlCallbackStatus_Ok value) ok,
    required TResult Function(LnUrlCallbackStatus_ErrorStatus value) errorStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LnUrlCallbackStatus_Ok value)? ok,
    TResult? Function(LnUrlCallbackStatus_ErrorStatus value)? errorStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LnUrlCallbackStatus_Ok value)? ok,
    TResult Function(LnUrlCallbackStatus_ErrorStatus value)? errorStatus,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LnUrlCallbackStatusCopyWith<$Res> {
  factory $LnUrlCallbackStatusCopyWith(LnUrlCallbackStatus value, $Res Function(LnUrlCallbackStatus) then) =
      _$LnUrlCallbackStatusCopyWithImpl<$Res, LnUrlCallbackStatus>;
}

/// @nodoc
class _$LnUrlCallbackStatusCopyWithImpl<$Res, $Val extends LnUrlCallbackStatus>
    implements $LnUrlCallbackStatusCopyWith<$Res> {
  _$LnUrlCallbackStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LnUrlCallbackStatus_OkImplCopyWith<$Res> {
  factory _$$LnUrlCallbackStatus_OkImplCopyWith(
          _$LnUrlCallbackStatus_OkImpl value, $Res Function(_$LnUrlCallbackStatus_OkImpl) then) =
      __$$LnUrlCallbackStatus_OkImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LnUrlCallbackStatus_OkImplCopyWithImpl<$Res>
    extends _$LnUrlCallbackStatusCopyWithImpl<$Res, _$LnUrlCallbackStatus_OkImpl>
    implements _$$LnUrlCallbackStatus_OkImplCopyWith<$Res> {
  __$$LnUrlCallbackStatus_OkImplCopyWithImpl(
      _$LnUrlCallbackStatus_OkImpl _value, $Res Function(_$LnUrlCallbackStatus_OkImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LnUrlCallbackStatus_OkImpl extends LnUrlCallbackStatus_Ok {
  const _$LnUrlCallbackStatus_OkImpl() : super._();

  @override
  String toString() {
    return 'LnUrlCallbackStatus.ok()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LnUrlCallbackStatus_OkImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() ok,
    required TResult Function(LnUrlErrorData data) errorStatus,
  }) {
    return ok();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? ok,
    TResult? Function(LnUrlErrorData data)? errorStatus,
  }) {
    return ok?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? ok,
    TResult Function(LnUrlErrorData data)? errorStatus,
    required TResult orElse(),
  }) {
    if (ok != null) {
      return ok();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LnUrlCallbackStatus_Ok value) ok,
    required TResult Function(LnUrlCallbackStatus_ErrorStatus value) errorStatus,
  }) {
    return ok(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LnUrlCallbackStatus_Ok value)? ok,
    TResult? Function(LnUrlCallbackStatus_ErrorStatus value)? errorStatus,
  }) {
    return ok?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LnUrlCallbackStatus_Ok value)? ok,
    TResult Function(LnUrlCallbackStatus_ErrorStatus value)? errorStatus,
    required TResult orElse(),
  }) {
    if (ok != null) {
      return ok(this);
    }
    return orElse();
  }
}

abstract class LnUrlCallbackStatus_Ok extends LnUrlCallbackStatus {
  const factory LnUrlCallbackStatus_Ok() = _$LnUrlCallbackStatus_OkImpl;
  const LnUrlCallbackStatus_Ok._() : super._();
}

/// @nodoc
abstract class _$$LnUrlCallbackStatus_ErrorStatusImplCopyWith<$Res> {
  factory _$$LnUrlCallbackStatus_ErrorStatusImplCopyWith(_$LnUrlCallbackStatus_ErrorStatusImpl value,
          $Res Function(_$LnUrlCallbackStatus_ErrorStatusImpl) then) =
      __$$LnUrlCallbackStatus_ErrorStatusImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlErrorData data});
}

/// @nodoc
class __$$LnUrlCallbackStatus_ErrorStatusImplCopyWithImpl<$Res>
    extends _$LnUrlCallbackStatusCopyWithImpl<$Res, _$LnUrlCallbackStatus_ErrorStatusImpl>
    implements _$$LnUrlCallbackStatus_ErrorStatusImplCopyWith<$Res> {
  __$$LnUrlCallbackStatus_ErrorStatusImplCopyWithImpl(_$LnUrlCallbackStatus_ErrorStatusImpl _value,
      $Res Function(_$LnUrlCallbackStatus_ErrorStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$LnUrlCallbackStatus_ErrorStatusImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LnUrlErrorData,
    ));
  }
}

/// @nodoc

class _$LnUrlCallbackStatus_ErrorStatusImpl extends LnUrlCallbackStatus_ErrorStatus {
  const _$LnUrlCallbackStatus_ErrorStatusImpl({required this.data}) : super._();

  @override
  final LnUrlErrorData data;

  @override
  String toString() {
    return 'LnUrlCallbackStatus.errorStatus(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LnUrlCallbackStatus_ErrorStatusImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LnUrlCallbackStatus_ErrorStatusImplCopyWith<_$LnUrlCallbackStatus_ErrorStatusImpl> get copyWith =>
      __$$LnUrlCallbackStatus_ErrorStatusImplCopyWithImpl<_$LnUrlCallbackStatus_ErrorStatusImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() ok,
    required TResult Function(LnUrlErrorData data) errorStatus,
  }) {
    return errorStatus(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? ok,
    TResult? Function(LnUrlErrorData data)? errorStatus,
  }) {
    return errorStatus?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? ok,
    TResult Function(LnUrlErrorData data)? errorStatus,
    required TResult orElse(),
  }) {
    if (errorStatus != null) {
      return errorStatus(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LnUrlCallbackStatus_Ok value) ok,
    required TResult Function(LnUrlCallbackStatus_ErrorStatus value) errorStatus,
  }) {
    return errorStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LnUrlCallbackStatus_Ok value)? ok,
    TResult? Function(LnUrlCallbackStatus_ErrorStatus value)? errorStatus,
  }) {
    return errorStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LnUrlCallbackStatus_Ok value)? ok,
    TResult Function(LnUrlCallbackStatus_ErrorStatus value)? errorStatus,
    required TResult orElse(),
  }) {
    if (errorStatus != null) {
      return errorStatus(this);
    }
    return orElse();
  }
}

abstract class LnUrlCallbackStatus_ErrorStatus extends LnUrlCallbackStatus {
  const factory LnUrlCallbackStatus_ErrorStatus({required final LnUrlErrorData data}) =
      _$LnUrlCallbackStatus_ErrorStatusImpl;
  const LnUrlCallbackStatus_ErrorStatus._() : super._();

  LnUrlErrorData get data;
  @JsonKey(ignore: true)
  _$$LnUrlCallbackStatus_ErrorStatusImplCopyWith<_$LnUrlCallbackStatus_ErrorStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LnUrlWithdrawResult {
  Object get data => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LnUrlWithdrawSuccessData data) ok,
    required TResult Function(LnUrlErrorData data) errorStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LnUrlWithdrawSuccessData data)? ok,
    TResult? Function(LnUrlErrorData data)? errorStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LnUrlWithdrawSuccessData data)? ok,
    TResult Function(LnUrlErrorData data)? errorStatus,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LnUrlWithdrawResult_Ok value) ok,
    required TResult Function(LnUrlWithdrawResult_ErrorStatus value) errorStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LnUrlWithdrawResult_Ok value)? ok,
    TResult? Function(LnUrlWithdrawResult_ErrorStatus value)? errorStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LnUrlWithdrawResult_Ok value)? ok,
    TResult Function(LnUrlWithdrawResult_ErrorStatus value)? errorStatus,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LnUrlWithdrawResultCopyWith<$Res> {
  factory $LnUrlWithdrawResultCopyWith(LnUrlWithdrawResult value, $Res Function(LnUrlWithdrawResult) then) =
      _$LnUrlWithdrawResultCopyWithImpl<$Res, LnUrlWithdrawResult>;
}

/// @nodoc
class _$LnUrlWithdrawResultCopyWithImpl<$Res, $Val extends LnUrlWithdrawResult>
    implements $LnUrlWithdrawResultCopyWith<$Res> {
  _$LnUrlWithdrawResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LnUrlWithdrawResult_OkImplCopyWith<$Res> {
  factory _$$LnUrlWithdrawResult_OkImplCopyWith(
          _$LnUrlWithdrawResult_OkImpl value, $Res Function(_$LnUrlWithdrawResult_OkImpl) then) =
      __$$LnUrlWithdrawResult_OkImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlWithdrawSuccessData data});
}

/// @nodoc
class __$$LnUrlWithdrawResult_OkImplCopyWithImpl<$Res>
    extends _$LnUrlWithdrawResultCopyWithImpl<$Res, _$LnUrlWithdrawResult_OkImpl>
    implements _$$LnUrlWithdrawResult_OkImplCopyWith<$Res> {
  __$$LnUrlWithdrawResult_OkImplCopyWithImpl(
      _$LnUrlWithdrawResult_OkImpl _value, $Res Function(_$LnUrlWithdrawResult_OkImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$LnUrlWithdrawResult_OkImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LnUrlWithdrawSuccessData,
    ));
  }
}

/// @nodoc

class _$LnUrlWithdrawResult_OkImpl extends LnUrlWithdrawResult_Ok {
  const _$LnUrlWithdrawResult_OkImpl({required this.data}) : super._();

  @override
  final LnUrlWithdrawSuccessData data;

  @override
  String toString() {
    return 'LnUrlWithdrawResult.ok(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LnUrlWithdrawResult_OkImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LnUrlWithdrawResult_OkImplCopyWith<_$LnUrlWithdrawResult_OkImpl> get copyWith =>
      __$$LnUrlWithdrawResult_OkImplCopyWithImpl<_$LnUrlWithdrawResult_OkImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LnUrlWithdrawSuccessData data) ok,
    required TResult Function(LnUrlErrorData data) errorStatus,
  }) {
    return ok(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LnUrlWithdrawSuccessData data)? ok,
    TResult? Function(LnUrlErrorData data)? errorStatus,
  }) {
    return ok?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LnUrlWithdrawSuccessData data)? ok,
    TResult Function(LnUrlErrorData data)? errorStatus,
    required TResult orElse(),
  }) {
    if (ok != null) {
      return ok(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LnUrlWithdrawResult_Ok value) ok,
    required TResult Function(LnUrlWithdrawResult_ErrorStatus value) errorStatus,
  }) {
    return ok(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LnUrlWithdrawResult_Ok value)? ok,
    TResult? Function(LnUrlWithdrawResult_ErrorStatus value)? errorStatus,
  }) {
    return ok?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LnUrlWithdrawResult_Ok value)? ok,
    TResult Function(LnUrlWithdrawResult_ErrorStatus value)? errorStatus,
    required TResult orElse(),
  }) {
    if (ok != null) {
      return ok(this);
    }
    return orElse();
  }
}

abstract class LnUrlWithdrawResult_Ok extends LnUrlWithdrawResult {
  const factory LnUrlWithdrawResult_Ok({required final LnUrlWithdrawSuccessData data}) =
      _$LnUrlWithdrawResult_OkImpl;
  const LnUrlWithdrawResult_Ok._() : super._();

  @override
  LnUrlWithdrawSuccessData get data;
  @JsonKey(ignore: true)
  _$$LnUrlWithdrawResult_OkImplCopyWith<_$LnUrlWithdrawResult_OkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LnUrlWithdrawResult_ErrorStatusImplCopyWith<$Res> {
  factory _$$LnUrlWithdrawResult_ErrorStatusImplCopyWith(_$LnUrlWithdrawResult_ErrorStatusImpl value,
          $Res Function(_$LnUrlWithdrawResult_ErrorStatusImpl) then) =
      __$$LnUrlWithdrawResult_ErrorStatusImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlErrorData data});
}

/// @nodoc
class __$$LnUrlWithdrawResult_ErrorStatusImplCopyWithImpl<$Res>
    extends _$LnUrlWithdrawResultCopyWithImpl<$Res, _$LnUrlWithdrawResult_ErrorStatusImpl>
    implements _$$LnUrlWithdrawResult_ErrorStatusImplCopyWith<$Res> {
  __$$LnUrlWithdrawResult_ErrorStatusImplCopyWithImpl(_$LnUrlWithdrawResult_ErrorStatusImpl _value,
      $Res Function(_$LnUrlWithdrawResult_ErrorStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$LnUrlWithdrawResult_ErrorStatusImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LnUrlErrorData,
    ));
  }
}

/// @nodoc

class _$LnUrlWithdrawResult_ErrorStatusImpl extends LnUrlWithdrawResult_ErrorStatus {
  const _$LnUrlWithdrawResult_ErrorStatusImpl({required this.data}) : super._();

  @override
  final LnUrlErrorData data;

  @override
  String toString() {
    return 'LnUrlWithdrawResult.errorStatus(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LnUrlWithdrawResult_ErrorStatusImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LnUrlWithdrawResult_ErrorStatusImplCopyWith<_$LnUrlWithdrawResult_ErrorStatusImpl> get copyWith =>
      __$$LnUrlWithdrawResult_ErrorStatusImplCopyWithImpl<_$LnUrlWithdrawResult_ErrorStatusImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LnUrlWithdrawSuccessData data) ok,
    required TResult Function(LnUrlErrorData data) errorStatus,
  }) {
    return errorStatus(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LnUrlWithdrawSuccessData data)? ok,
    TResult? Function(LnUrlErrorData data)? errorStatus,
  }) {
    return errorStatus?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LnUrlWithdrawSuccessData data)? ok,
    TResult Function(LnUrlErrorData data)? errorStatus,
    required TResult orElse(),
  }) {
    if (errorStatus != null) {
      return errorStatus(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LnUrlWithdrawResult_Ok value) ok,
    required TResult Function(LnUrlWithdrawResult_ErrorStatus value) errorStatus,
  }) {
    return errorStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LnUrlWithdrawResult_Ok value)? ok,
    TResult? Function(LnUrlWithdrawResult_ErrorStatus value)? errorStatus,
  }) {
    return errorStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LnUrlWithdrawResult_Ok value)? ok,
    TResult Function(LnUrlWithdrawResult_ErrorStatus value)? errorStatus,
    required TResult orElse(),
  }) {
    if (errorStatus != null) {
      return errorStatus(this);
    }
    return orElse();
  }
}

abstract class LnUrlWithdrawResult_ErrorStatus extends LnUrlWithdrawResult {
  const factory LnUrlWithdrawResult_ErrorStatus({required final LnUrlErrorData data}) =
      _$LnUrlWithdrawResult_ErrorStatusImpl;
  const LnUrlWithdrawResult_ErrorStatus._() : super._();

  @override
  LnUrlErrorData get data;
  @JsonKey(ignore: true)
  _$$LnUrlWithdrawResult_ErrorStatusImplCopyWith<_$LnUrlWithdrawResult_ErrorStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NodeConfig {
  GreenlightNodeConfig get config => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GreenlightNodeConfig config) greenlight,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GreenlightNodeConfig config)? greenlight,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GreenlightNodeConfig config)? greenlight,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NodeConfig_Greenlight value) greenlight,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NodeConfig_Greenlight value)? greenlight,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NodeConfig_Greenlight value)? greenlight,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NodeConfigCopyWith<NodeConfig> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeConfigCopyWith<$Res> {
  factory $NodeConfigCopyWith(NodeConfig value, $Res Function(NodeConfig) then) =
      _$NodeConfigCopyWithImpl<$Res, NodeConfig>;
  @useResult
  $Res call({GreenlightNodeConfig config});
}

/// @nodoc
class _$NodeConfigCopyWithImpl<$Res, $Val extends NodeConfig> implements $NodeConfigCopyWith<$Res> {
  _$NodeConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? config = null,
  }) {
    return _then(_value.copyWith(
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as GreenlightNodeConfig,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NodeConfig_GreenlightImplCopyWith<$Res> implements $NodeConfigCopyWith<$Res> {
  factory _$$NodeConfig_GreenlightImplCopyWith(
          _$NodeConfig_GreenlightImpl value, $Res Function(_$NodeConfig_GreenlightImpl) then) =
      __$$NodeConfig_GreenlightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GreenlightNodeConfig config});
}

/// @nodoc
class __$$NodeConfig_GreenlightImplCopyWithImpl<$Res>
    extends _$NodeConfigCopyWithImpl<$Res, _$NodeConfig_GreenlightImpl>
    implements _$$NodeConfig_GreenlightImplCopyWith<$Res> {
  __$$NodeConfig_GreenlightImplCopyWithImpl(
      _$NodeConfig_GreenlightImpl _value, $Res Function(_$NodeConfig_GreenlightImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? config = null,
  }) {
    return _then(_$NodeConfig_GreenlightImpl(
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as GreenlightNodeConfig,
    ));
  }
}

/// @nodoc

class _$NodeConfig_GreenlightImpl extends NodeConfig_Greenlight {
  const _$NodeConfig_GreenlightImpl({required this.config}) : super._();

  @override
  final GreenlightNodeConfig config;

  @override
  String toString() {
    return 'NodeConfig.greenlight(config: $config)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodeConfig_GreenlightImpl &&
            (identical(other.config, config) || other.config == config));
  }

  @override
  int get hashCode => Object.hash(runtimeType, config);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NodeConfig_GreenlightImplCopyWith<_$NodeConfig_GreenlightImpl> get copyWith =>
      __$$NodeConfig_GreenlightImplCopyWithImpl<_$NodeConfig_GreenlightImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GreenlightNodeConfig config) greenlight,
  }) {
    return greenlight(config);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GreenlightNodeConfig config)? greenlight,
  }) {
    return greenlight?.call(config);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GreenlightNodeConfig config)? greenlight,
    required TResult orElse(),
  }) {
    if (greenlight != null) {
      return greenlight(config);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NodeConfig_Greenlight value) greenlight,
  }) {
    return greenlight(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NodeConfig_Greenlight value)? greenlight,
  }) {
    return greenlight?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NodeConfig_Greenlight value)? greenlight,
    required TResult orElse(),
  }) {
    if (greenlight != null) {
      return greenlight(this);
    }
    return orElse();
  }
}

abstract class NodeConfig_Greenlight extends NodeConfig {
  const factory NodeConfig_Greenlight({required final GreenlightNodeConfig config}) =
      _$NodeConfig_GreenlightImpl;
  const NodeConfig_Greenlight._() : super._();

  @override
  GreenlightNodeConfig get config;
  @override
  @JsonKey(ignore: true)
  _$$NodeConfig_GreenlightImplCopyWith<_$NodeConfig_GreenlightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NodeCredentials {
  GreenlightCredentials get credentials => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GreenlightCredentials credentials) greenlight,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GreenlightCredentials credentials)? greenlight,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GreenlightCredentials credentials)? greenlight,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NodeCredentials_Greenlight value) greenlight,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NodeCredentials_Greenlight value)? greenlight,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NodeCredentials_Greenlight value)? greenlight,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NodeCredentialsCopyWith<NodeCredentials> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeCredentialsCopyWith<$Res> {
  factory $NodeCredentialsCopyWith(NodeCredentials value, $Res Function(NodeCredentials) then) =
      _$NodeCredentialsCopyWithImpl<$Res, NodeCredentials>;
  @useResult
  $Res call({GreenlightCredentials credentials});
}

/// @nodoc
class _$NodeCredentialsCopyWithImpl<$Res, $Val extends NodeCredentials>
    implements $NodeCredentialsCopyWith<$Res> {
  _$NodeCredentialsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? credentials = null,
  }) {
    return _then(_value.copyWith(
      credentials: null == credentials
          ? _value.credentials
          : credentials // ignore: cast_nullable_to_non_nullable
              as GreenlightCredentials,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NodeCredentials_GreenlightImplCopyWith<$Res> implements $NodeCredentialsCopyWith<$Res> {
  factory _$$NodeCredentials_GreenlightImplCopyWith(
          _$NodeCredentials_GreenlightImpl value, $Res Function(_$NodeCredentials_GreenlightImpl) then) =
      __$$NodeCredentials_GreenlightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GreenlightCredentials credentials});
}

/// @nodoc
class __$$NodeCredentials_GreenlightImplCopyWithImpl<$Res>
    extends _$NodeCredentialsCopyWithImpl<$Res, _$NodeCredentials_GreenlightImpl>
    implements _$$NodeCredentials_GreenlightImplCopyWith<$Res> {
  __$$NodeCredentials_GreenlightImplCopyWithImpl(
      _$NodeCredentials_GreenlightImpl _value, $Res Function(_$NodeCredentials_GreenlightImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? credentials = null,
  }) {
    return _then(_$NodeCredentials_GreenlightImpl(
      credentials: null == credentials
          ? _value.credentials
          : credentials // ignore: cast_nullable_to_non_nullable
              as GreenlightCredentials,
    ));
  }
}

/// @nodoc

class _$NodeCredentials_GreenlightImpl extends NodeCredentials_Greenlight {
  const _$NodeCredentials_GreenlightImpl({required this.credentials}) : super._();

  @override
  final GreenlightCredentials credentials;

  @override
  String toString() {
    return 'NodeCredentials.greenlight(credentials: $credentials)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodeCredentials_GreenlightImpl &&
            (identical(other.credentials, credentials) || other.credentials == credentials));
  }

  @override
  int get hashCode => Object.hash(runtimeType, credentials);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NodeCredentials_GreenlightImplCopyWith<_$NodeCredentials_GreenlightImpl> get copyWith =>
      __$$NodeCredentials_GreenlightImplCopyWithImpl<_$NodeCredentials_GreenlightImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GreenlightCredentials credentials) greenlight,
  }) {
    return greenlight(credentials);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GreenlightCredentials credentials)? greenlight,
  }) {
    return greenlight?.call(credentials);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GreenlightCredentials credentials)? greenlight,
    required TResult orElse(),
  }) {
    if (greenlight != null) {
      return greenlight(credentials);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NodeCredentials_Greenlight value) greenlight,
  }) {
    return greenlight(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NodeCredentials_Greenlight value)? greenlight,
  }) {
    return greenlight?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NodeCredentials_Greenlight value)? greenlight,
    required TResult orElse(),
  }) {
    if (greenlight != null) {
      return greenlight(this);
    }
    return orElse();
  }
}

abstract class NodeCredentials_Greenlight extends NodeCredentials {
  const factory NodeCredentials_Greenlight({required final GreenlightCredentials credentials}) =
      _$NodeCredentials_GreenlightImpl;
  const NodeCredentials_Greenlight._() : super._();

  @override
  GreenlightCredentials get credentials;
  @override
  @JsonKey(ignore: true)
  _$$NodeCredentials_GreenlightImplCopyWith<_$NodeCredentials_GreenlightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PaymentDetails {
  Object get data => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LnPaymentDetails data) ln,
    required TResult Function(ClosedChannelPaymentDetails data) closedChannel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LnPaymentDetails data)? ln,
    TResult? Function(ClosedChannelPaymentDetails data)? closedChannel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LnPaymentDetails data)? ln,
    TResult Function(ClosedChannelPaymentDetails data)? closedChannel,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentDetails_Ln value) ln,
    required TResult Function(PaymentDetails_ClosedChannel value) closedChannel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentDetails_Ln value)? ln,
    TResult? Function(PaymentDetails_ClosedChannel value)? closedChannel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentDetails_Ln value)? ln,
    TResult Function(PaymentDetails_ClosedChannel value)? closedChannel,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentDetailsCopyWith<$Res> {
  factory $PaymentDetailsCopyWith(PaymentDetails value, $Res Function(PaymentDetails) then) =
      _$PaymentDetailsCopyWithImpl<$Res, PaymentDetails>;
}

/// @nodoc
class _$PaymentDetailsCopyWithImpl<$Res, $Val extends PaymentDetails>
    implements $PaymentDetailsCopyWith<$Res> {
  _$PaymentDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$PaymentDetails_LnImplCopyWith<$Res> {
  factory _$$PaymentDetails_LnImplCopyWith(
          _$PaymentDetails_LnImpl value, $Res Function(_$PaymentDetails_LnImpl) then) =
      __$$PaymentDetails_LnImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LnPaymentDetails data});
}

/// @nodoc
class __$$PaymentDetails_LnImplCopyWithImpl<$Res>
    extends _$PaymentDetailsCopyWithImpl<$Res, _$PaymentDetails_LnImpl>
    implements _$$PaymentDetails_LnImplCopyWith<$Res> {
  __$$PaymentDetails_LnImplCopyWithImpl(
      _$PaymentDetails_LnImpl _value, $Res Function(_$PaymentDetails_LnImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$PaymentDetails_LnImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LnPaymentDetails,
    ));
  }
}

/// @nodoc

class _$PaymentDetails_LnImpl extends PaymentDetails_Ln {
  const _$PaymentDetails_LnImpl({required this.data}) : super._();

  @override
  final LnPaymentDetails data;

  @override
  String toString() {
    return 'PaymentDetails.ln(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentDetails_LnImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentDetails_LnImplCopyWith<_$PaymentDetails_LnImpl> get copyWith =>
      __$$PaymentDetails_LnImplCopyWithImpl<_$PaymentDetails_LnImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LnPaymentDetails data) ln,
    required TResult Function(ClosedChannelPaymentDetails data) closedChannel,
  }) {
    return ln(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LnPaymentDetails data)? ln,
    TResult? Function(ClosedChannelPaymentDetails data)? closedChannel,
  }) {
    return ln?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LnPaymentDetails data)? ln,
    TResult Function(ClosedChannelPaymentDetails data)? closedChannel,
    required TResult orElse(),
  }) {
    if (ln != null) {
      return ln(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentDetails_Ln value) ln,
    required TResult Function(PaymentDetails_ClosedChannel value) closedChannel,
  }) {
    return ln(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentDetails_Ln value)? ln,
    TResult? Function(PaymentDetails_ClosedChannel value)? closedChannel,
  }) {
    return ln?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentDetails_Ln value)? ln,
    TResult Function(PaymentDetails_ClosedChannel value)? closedChannel,
    required TResult orElse(),
  }) {
    if (ln != null) {
      return ln(this);
    }
    return orElse();
  }
}

abstract class PaymentDetails_Ln extends PaymentDetails {
  const factory PaymentDetails_Ln({required final LnPaymentDetails data}) = _$PaymentDetails_LnImpl;
  const PaymentDetails_Ln._() : super._();

  @override
  LnPaymentDetails get data;
  @JsonKey(ignore: true)
  _$$PaymentDetails_LnImplCopyWith<_$PaymentDetails_LnImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PaymentDetails_ClosedChannelImplCopyWith<$Res> {
  factory _$$PaymentDetails_ClosedChannelImplCopyWith(
          _$PaymentDetails_ClosedChannelImpl value, $Res Function(_$PaymentDetails_ClosedChannelImpl) then) =
      __$$PaymentDetails_ClosedChannelImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ClosedChannelPaymentDetails data});
}

/// @nodoc
class __$$PaymentDetails_ClosedChannelImplCopyWithImpl<$Res>
    extends _$PaymentDetailsCopyWithImpl<$Res, _$PaymentDetails_ClosedChannelImpl>
    implements _$$PaymentDetails_ClosedChannelImplCopyWith<$Res> {
  __$$PaymentDetails_ClosedChannelImplCopyWithImpl(
      _$PaymentDetails_ClosedChannelImpl _value, $Res Function(_$PaymentDetails_ClosedChannelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$PaymentDetails_ClosedChannelImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ClosedChannelPaymentDetails,
    ));
  }
}

/// @nodoc

class _$PaymentDetails_ClosedChannelImpl extends PaymentDetails_ClosedChannel {
  const _$PaymentDetails_ClosedChannelImpl({required this.data}) : super._();

  @override
  final ClosedChannelPaymentDetails data;

  @override
  String toString() {
    return 'PaymentDetails.closedChannel(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentDetails_ClosedChannelImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentDetails_ClosedChannelImplCopyWith<_$PaymentDetails_ClosedChannelImpl> get copyWith =>
      __$$PaymentDetails_ClosedChannelImplCopyWithImpl<_$PaymentDetails_ClosedChannelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LnPaymentDetails data) ln,
    required TResult Function(ClosedChannelPaymentDetails data) closedChannel,
  }) {
    return closedChannel(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LnPaymentDetails data)? ln,
    TResult? Function(ClosedChannelPaymentDetails data)? closedChannel,
  }) {
    return closedChannel?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LnPaymentDetails data)? ln,
    TResult Function(ClosedChannelPaymentDetails data)? closedChannel,
    required TResult orElse(),
  }) {
    if (closedChannel != null) {
      return closedChannel(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentDetails_Ln value) ln,
    required TResult Function(PaymentDetails_ClosedChannel value) closedChannel,
  }) {
    return closedChannel(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentDetails_Ln value)? ln,
    TResult? Function(PaymentDetails_ClosedChannel value)? closedChannel,
  }) {
    return closedChannel?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentDetails_Ln value)? ln,
    TResult Function(PaymentDetails_ClosedChannel value)? closedChannel,
    required TResult orElse(),
  }) {
    if (closedChannel != null) {
      return closedChannel(this);
    }
    return orElse();
  }
}

abstract class PaymentDetails_ClosedChannel extends PaymentDetails {
  const factory PaymentDetails_ClosedChannel({required final ClosedChannelPaymentDetails data}) =
      _$PaymentDetails_ClosedChannelImpl;
  const PaymentDetails_ClosedChannel._() : super._();

  @override
  ClosedChannelPaymentDetails get data;
  @JsonKey(ignore: true)
  _$$PaymentDetails_ClosedChannelImplCopyWith<_$PaymentDetails_ClosedChannelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ReportIssueRequest {
  ReportPaymentFailureDetails get data => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ReportPaymentFailureDetails data) paymentFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ReportPaymentFailureDetails data)? paymentFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ReportPaymentFailureDetails data)? paymentFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ReportIssueRequest_PaymentFailure value) paymentFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ReportIssueRequest_PaymentFailure value)? paymentFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ReportIssueRequest_PaymentFailure value)? paymentFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ReportIssueRequestCopyWith<ReportIssueRequest> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportIssueRequestCopyWith<$Res> {
  factory $ReportIssueRequestCopyWith(ReportIssueRequest value, $Res Function(ReportIssueRequest) then) =
      _$ReportIssueRequestCopyWithImpl<$Res, ReportIssueRequest>;
  @useResult
  $Res call({ReportPaymentFailureDetails data});
}

/// @nodoc
class _$ReportIssueRequestCopyWithImpl<$Res, $Val extends ReportIssueRequest>
    implements $ReportIssueRequestCopyWith<$Res> {
  _$ReportIssueRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ReportPaymentFailureDetails,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportIssueRequest_PaymentFailureImplCopyWith<$Res>
    implements $ReportIssueRequestCopyWith<$Res> {
  factory _$$ReportIssueRequest_PaymentFailureImplCopyWith(_$ReportIssueRequest_PaymentFailureImpl value,
          $Res Function(_$ReportIssueRequest_PaymentFailureImpl) then) =
      __$$ReportIssueRequest_PaymentFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ReportPaymentFailureDetails data});
}

/// @nodoc
class __$$ReportIssueRequest_PaymentFailureImplCopyWithImpl<$Res>
    extends _$ReportIssueRequestCopyWithImpl<$Res, _$ReportIssueRequest_PaymentFailureImpl>
    implements _$$ReportIssueRequest_PaymentFailureImplCopyWith<$Res> {
  __$$ReportIssueRequest_PaymentFailureImplCopyWithImpl(_$ReportIssueRequest_PaymentFailureImpl _value,
      $Res Function(_$ReportIssueRequest_PaymentFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$ReportIssueRequest_PaymentFailureImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ReportPaymentFailureDetails,
    ));
  }
}

/// @nodoc

class _$ReportIssueRequest_PaymentFailureImpl extends ReportIssueRequest_PaymentFailure {
  const _$ReportIssueRequest_PaymentFailureImpl({required this.data}) : super._();

  @override
  final ReportPaymentFailureDetails data;

  @override
  String toString() {
    return 'ReportIssueRequest.paymentFailure(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportIssueRequest_PaymentFailureImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportIssueRequest_PaymentFailureImplCopyWith<_$ReportIssueRequest_PaymentFailureImpl> get copyWith =>
      __$$ReportIssueRequest_PaymentFailureImplCopyWithImpl<_$ReportIssueRequest_PaymentFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ReportPaymentFailureDetails data) paymentFailure,
  }) {
    return paymentFailure(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ReportPaymentFailureDetails data)? paymentFailure,
  }) {
    return paymentFailure?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ReportPaymentFailureDetails data)? paymentFailure,
    required TResult orElse(),
  }) {
    if (paymentFailure != null) {
      return paymentFailure(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ReportIssueRequest_PaymentFailure value) paymentFailure,
  }) {
    return paymentFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ReportIssueRequest_PaymentFailure value)? paymentFailure,
  }) {
    return paymentFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ReportIssueRequest_PaymentFailure value)? paymentFailure,
    required TResult orElse(),
  }) {
    if (paymentFailure != null) {
      return paymentFailure(this);
    }
    return orElse();
  }
}

abstract class ReportIssueRequest_PaymentFailure extends ReportIssueRequest {
  const factory ReportIssueRequest_PaymentFailure({required final ReportPaymentFailureDetails data}) =
      _$ReportIssueRequest_PaymentFailureImpl;
  const ReportIssueRequest_PaymentFailure._() : super._();

  @override
  ReportPaymentFailureDetails get data;
  @override
  @JsonKey(ignore: true)
  _$$ReportIssueRequest_PaymentFailureImplCopyWith<_$ReportIssueRequest_PaymentFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
