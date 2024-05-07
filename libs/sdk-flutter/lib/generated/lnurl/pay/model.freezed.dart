// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AesSuccessActionDataResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AesSuccessActionDataDecrypted data) decrypted,
    required TResult Function(String reason) errorStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AesSuccessActionDataDecrypted data)? decrypted,
    TResult? Function(String reason)? errorStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AesSuccessActionDataDecrypted data)? decrypted,
    TResult Function(String reason)? errorStatus,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AesSuccessActionDataResult_Decrypted value) decrypted,
    required TResult Function(AesSuccessActionDataResult_ErrorStatus value) errorStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AesSuccessActionDataResult_Decrypted value)? decrypted,
    TResult? Function(AesSuccessActionDataResult_ErrorStatus value)? errorStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AesSuccessActionDataResult_Decrypted value)? decrypted,
    TResult Function(AesSuccessActionDataResult_ErrorStatus value)? errorStatus,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AesSuccessActionDataResultCopyWith<$Res> {
  factory $AesSuccessActionDataResultCopyWith(
          AesSuccessActionDataResult value, $Res Function(AesSuccessActionDataResult) then) =
      _$AesSuccessActionDataResultCopyWithImpl<$Res, AesSuccessActionDataResult>;
}

/// @nodoc
class _$AesSuccessActionDataResultCopyWithImpl<$Res, $Val extends AesSuccessActionDataResult>
    implements $AesSuccessActionDataResultCopyWith<$Res> {
  _$AesSuccessActionDataResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AesSuccessActionDataResult_DecryptedImplCopyWith<$Res> {
  factory _$$AesSuccessActionDataResult_DecryptedImplCopyWith(
          _$AesSuccessActionDataResult_DecryptedImpl value,
          $Res Function(_$AesSuccessActionDataResult_DecryptedImpl) then) =
      __$$AesSuccessActionDataResult_DecryptedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AesSuccessActionDataDecrypted data});
}

/// @nodoc
class __$$AesSuccessActionDataResult_DecryptedImplCopyWithImpl<$Res>
    extends _$AesSuccessActionDataResultCopyWithImpl<$Res, _$AesSuccessActionDataResult_DecryptedImpl>
    implements _$$AesSuccessActionDataResult_DecryptedImplCopyWith<$Res> {
  __$$AesSuccessActionDataResult_DecryptedImplCopyWithImpl(_$AesSuccessActionDataResult_DecryptedImpl _value,
      $Res Function(_$AesSuccessActionDataResult_DecryptedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$AesSuccessActionDataResult_DecryptedImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as AesSuccessActionDataDecrypted,
    ));
  }
}

/// @nodoc

class _$AesSuccessActionDataResult_DecryptedImpl extends AesSuccessActionDataResult_Decrypted {
  const _$AesSuccessActionDataResult_DecryptedImpl({required this.data}) : super._();

  @override
  final AesSuccessActionDataDecrypted data;

  @override
  String toString() {
    return 'AesSuccessActionDataResult.decrypted(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AesSuccessActionDataResult_DecryptedImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AesSuccessActionDataResult_DecryptedImplCopyWith<_$AesSuccessActionDataResult_DecryptedImpl>
      get copyWith => __$$AesSuccessActionDataResult_DecryptedImplCopyWithImpl<
          _$AesSuccessActionDataResult_DecryptedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AesSuccessActionDataDecrypted data) decrypted,
    required TResult Function(String reason) errorStatus,
  }) {
    return decrypted(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AesSuccessActionDataDecrypted data)? decrypted,
    TResult? Function(String reason)? errorStatus,
  }) {
    return decrypted?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AesSuccessActionDataDecrypted data)? decrypted,
    TResult Function(String reason)? errorStatus,
    required TResult orElse(),
  }) {
    if (decrypted != null) {
      return decrypted(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AesSuccessActionDataResult_Decrypted value) decrypted,
    required TResult Function(AesSuccessActionDataResult_ErrorStatus value) errorStatus,
  }) {
    return decrypted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AesSuccessActionDataResult_Decrypted value)? decrypted,
    TResult? Function(AesSuccessActionDataResult_ErrorStatus value)? errorStatus,
  }) {
    return decrypted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AesSuccessActionDataResult_Decrypted value)? decrypted,
    TResult Function(AesSuccessActionDataResult_ErrorStatus value)? errorStatus,
    required TResult orElse(),
  }) {
    if (decrypted != null) {
      return decrypted(this);
    }
    return orElse();
  }
}

abstract class AesSuccessActionDataResult_Decrypted extends AesSuccessActionDataResult {
  const factory AesSuccessActionDataResult_Decrypted({required final AesSuccessActionDataDecrypted data}) =
      _$AesSuccessActionDataResult_DecryptedImpl;
  const AesSuccessActionDataResult_Decrypted._() : super._();

  AesSuccessActionDataDecrypted get data;
  @JsonKey(ignore: true)
  _$$AesSuccessActionDataResult_DecryptedImplCopyWith<_$AesSuccessActionDataResult_DecryptedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AesSuccessActionDataResult_ErrorStatusImplCopyWith<$Res> {
  factory _$$AesSuccessActionDataResult_ErrorStatusImplCopyWith(
          _$AesSuccessActionDataResult_ErrorStatusImpl value,
          $Res Function(_$AesSuccessActionDataResult_ErrorStatusImpl) then) =
      __$$AesSuccessActionDataResult_ErrorStatusImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reason});
}

/// @nodoc
class __$$AesSuccessActionDataResult_ErrorStatusImplCopyWithImpl<$Res>
    extends _$AesSuccessActionDataResultCopyWithImpl<$Res, _$AesSuccessActionDataResult_ErrorStatusImpl>
    implements _$$AesSuccessActionDataResult_ErrorStatusImplCopyWith<$Res> {
  __$$AesSuccessActionDataResult_ErrorStatusImplCopyWithImpl(
      _$AesSuccessActionDataResult_ErrorStatusImpl _value,
      $Res Function(_$AesSuccessActionDataResult_ErrorStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
  }) {
    return _then(_$AesSuccessActionDataResult_ErrorStatusImpl(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AesSuccessActionDataResult_ErrorStatusImpl extends AesSuccessActionDataResult_ErrorStatus {
  const _$AesSuccessActionDataResult_ErrorStatusImpl({required this.reason}) : super._();

  @override
  final String reason;

  @override
  String toString() {
    return 'AesSuccessActionDataResult.errorStatus(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AesSuccessActionDataResult_ErrorStatusImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AesSuccessActionDataResult_ErrorStatusImplCopyWith<_$AesSuccessActionDataResult_ErrorStatusImpl>
      get copyWith => __$$AesSuccessActionDataResult_ErrorStatusImplCopyWithImpl<
          _$AesSuccessActionDataResult_ErrorStatusImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AesSuccessActionDataDecrypted data) decrypted,
    required TResult Function(String reason) errorStatus,
  }) {
    return errorStatus(reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AesSuccessActionDataDecrypted data)? decrypted,
    TResult? Function(String reason)? errorStatus,
  }) {
    return errorStatus?.call(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AesSuccessActionDataDecrypted data)? decrypted,
    TResult Function(String reason)? errorStatus,
    required TResult orElse(),
  }) {
    if (errorStatus != null) {
      return errorStatus(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AesSuccessActionDataResult_Decrypted value) decrypted,
    required TResult Function(AesSuccessActionDataResult_ErrorStatus value) errorStatus,
  }) {
    return errorStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AesSuccessActionDataResult_Decrypted value)? decrypted,
    TResult? Function(AesSuccessActionDataResult_ErrorStatus value)? errorStatus,
  }) {
    return errorStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AesSuccessActionDataResult_Decrypted value)? decrypted,
    TResult Function(AesSuccessActionDataResult_ErrorStatus value)? errorStatus,
    required TResult orElse(),
  }) {
    if (errorStatus != null) {
      return errorStatus(this);
    }
    return orElse();
  }
}

abstract class AesSuccessActionDataResult_ErrorStatus extends AesSuccessActionDataResult {
  const factory AesSuccessActionDataResult_ErrorStatus({required final String reason}) =
      _$AesSuccessActionDataResult_ErrorStatusImpl;
  const AesSuccessActionDataResult_ErrorStatus._() : super._();

  String get reason;
  @JsonKey(ignore: true)
  _$$AesSuccessActionDataResult_ErrorStatusImplCopyWith<_$AesSuccessActionDataResult_ErrorStatusImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LnUrlPayResult {
  Object get data => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LnUrlPaySuccessData data) endpointSuccess,
    required TResult Function(LnUrlErrorData data) endpointError,
    required TResult Function(LnUrlPayErrorData data) payError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LnUrlPaySuccessData data)? endpointSuccess,
    TResult? Function(LnUrlErrorData data)? endpointError,
    TResult? Function(LnUrlPayErrorData data)? payError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LnUrlPaySuccessData data)? endpointSuccess,
    TResult Function(LnUrlErrorData data)? endpointError,
    TResult Function(LnUrlPayErrorData data)? payError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LnUrlPayResult_EndpointSuccess value) endpointSuccess,
    required TResult Function(LnUrlPayResult_EndpointError value) endpointError,
    required TResult Function(LnUrlPayResult_PayError value) payError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LnUrlPayResult_EndpointSuccess value)? endpointSuccess,
    TResult? Function(LnUrlPayResult_EndpointError value)? endpointError,
    TResult? Function(LnUrlPayResult_PayError value)? payError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LnUrlPayResult_EndpointSuccess value)? endpointSuccess,
    TResult Function(LnUrlPayResult_EndpointError value)? endpointError,
    TResult Function(LnUrlPayResult_PayError value)? payError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LnUrlPayResultCopyWith<$Res> {
  factory $LnUrlPayResultCopyWith(LnUrlPayResult value, $Res Function(LnUrlPayResult) then) =
      _$LnUrlPayResultCopyWithImpl<$Res, LnUrlPayResult>;
}

/// @nodoc
class _$LnUrlPayResultCopyWithImpl<$Res, $Val extends LnUrlPayResult>
    implements $LnUrlPayResultCopyWith<$Res> {
  _$LnUrlPayResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LnUrlPayResult_EndpointSuccessImplCopyWith<$Res> {
  factory _$$LnUrlPayResult_EndpointSuccessImplCopyWith(_$LnUrlPayResult_EndpointSuccessImpl value,
          $Res Function(_$LnUrlPayResult_EndpointSuccessImpl) then) =
      __$$LnUrlPayResult_EndpointSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlPaySuccessData data});
}

/// @nodoc
class __$$LnUrlPayResult_EndpointSuccessImplCopyWithImpl<$Res>
    extends _$LnUrlPayResultCopyWithImpl<$Res, _$LnUrlPayResult_EndpointSuccessImpl>
    implements _$$LnUrlPayResult_EndpointSuccessImplCopyWith<$Res> {
  __$$LnUrlPayResult_EndpointSuccessImplCopyWithImpl(
      _$LnUrlPayResult_EndpointSuccessImpl _value, $Res Function(_$LnUrlPayResult_EndpointSuccessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$LnUrlPayResult_EndpointSuccessImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LnUrlPaySuccessData,
    ));
  }
}

/// @nodoc

class _$LnUrlPayResult_EndpointSuccessImpl extends LnUrlPayResult_EndpointSuccess {
  const _$LnUrlPayResult_EndpointSuccessImpl({required this.data}) : super._();

  @override
  final LnUrlPaySuccessData data;

  @override
  String toString() {
    return 'LnUrlPayResult.endpointSuccess(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LnUrlPayResult_EndpointSuccessImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LnUrlPayResult_EndpointSuccessImplCopyWith<_$LnUrlPayResult_EndpointSuccessImpl> get copyWith =>
      __$$LnUrlPayResult_EndpointSuccessImplCopyWithImpl<_$LnUrlPayResult_EndpointSuccessImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LnUrlPaySuccessData data) endpointSuccess,
    required TResult Function(LnUrlErrorData data) endpointError,
    required TResult Function(LnUrlPayErrorData data) payError,
  }) {
    return endpointSuccess(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LnUrlPaySuccessData data)? endpointSuccess,
    TResult? Function(LnUrlErrorData data)? endpointError,
    TResult? Function(LnUrlPayErrorData data)? payError,
  }) {
    return endpointSuccess?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LnUrlPaySuccessData data)? endpointSuccess,
    TResult Function(LnUrlErrorData data)? endpointError,
    TResult Function(LnUrlPayErrorData data)? payError,
    required TResult orElse(),
  }) {
    if (endpointSuccess != null) {
      return endpointSuccess(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LnUrlPayResult_EndpointSuccess value) endpointSuccess,
    required TResult Function(LnUrlPayResult_EndpointError value) endpointError,
    required TResult Function(LnUrlPayResult_PayError value) payError,
  }) {
    return endpointSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LnUrlPayResult_EndpointSuccess value)? endpointSuccess,
    TResult? Function(LnUrlPayResult_EndpointError value)? endpointError,
    TResult? Function(LnUrlPayResult_PayError value)? payError,
  }) {
    return endpointSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LnUrlPayResult_EndpointSuccess value)? endpointSuccess,
    TResult Function(LnUrlPayResult_EndpointError value)? endpointError,
    TResult Function(LnUrlPayResult_PayError value)? payError,
    required TResult orElse(),
  }) {
    if (endpointSuccess != null) {
      return endpointSuccess(this);
    }
    return orElse();
  }
}

abstract class LnUrlPayResult_EndpointSuccess extends LnUrlPayResult {
  const factory LnUrlPayResult_EndpointSuccess({required final LnUrlPaySuccessData data}) =
      _$LnUrlPayResult_EndpointSuccessImpl;
  const LnUrlPayResult_EndpointSuccess._() : super._();

  @override
  LnUrlPaySuccessData get data;
  @JsonKey(ignore: true)
  _$$LnUrlPayResult_EndpointSuccessImplCopyWith<_$LnUrlPayResult_EndpointSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LnUrlPayResult_EndpointErrorImplCopyWith<$Res> {
  factory _$$LnUrlPayResult_EndpointErrorImplCopyWith(
          _$LnUrlPayResult_EndpointErrorImpl value, $Res Function(_$LnUrlPayResult_EndpointErrorImpl) then) =
      __$$LnUrlPayResult_EndpointErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlErrorData data});
}

/// @nodoc
class __$$LnUrlPayResult_EndpointErrorImplCopyWithImpl<$Res>
    extends _$LnUrlPayResultCopyWithImpl<$Res, _$LnUrlPayResult_EndpointErrorImpl>
    implements _$$LnUrlPayResult_EndpointErrorImplCopyWith<$Res> {
  __$$LnUrlPayResult_EndpointErrorImplCopyWithImpl(
      _$LnUrlPayResult_EndpointErrorImpl _value, $Res Function(_$LnUrlPayResult_EndpointErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$LnUrlPayResult_EndpointErrorImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LnUrlErrorData,
    ));
  }
}

/// @nodoc

class _$LnUrlPayResult_EndpointErrorImpl extends LnUrlPayResult_EndpointError {
  const _$LnUrlPayResult_EndpointErrorImpl({required this.data}) : super._();

  @override
  final LnUrlErrorData data;

  @override
  String toString() {
    return 'LnUrlPayResult.endpointError(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LnUrlPayResult_EndpointErrorImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LnUrlPayResult_EndpointErrorImplCopyWith<_$LnUrlPayResult_EndpointErrorImpl> get copyWith =>
      __$$LnUrlPayResult_EndpointErrorImplCopyWithImpl<_$LnUrlPayResult_EndpointErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LnUrlPaySuccessData data) endpointSuccess,
    required TResult Function(LnUrlErrorData data) endpointError,
    required TResult Function(LnUrlPayErrorData data) payError,
  }) {
    return endpointError(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LnUrlPaySuccessData data)? endpointSuccess,
    TResult? Function(LnUrlErrorData data)? endpointError,
    TResult? Function(LnUrlPayErrorData data)? payError,
  }) {
    return endpointError?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LnUrlPaySuccessData data)? endpointSuccess,
    TResult Function(LnUrlErrorData data)? endpointError,
    TResult Function(LnUrlPayErrorData data)? payError,
    required TResult orElse(),
  }) {
    if (endpointError != null) {
      return endpointError(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LnUrlPayResult_EndpointSuccess value) endpointSuccess,
    required TResult Function(LnUrlPayResult_EndpointError value) endpointError,
    required TResult Function(LnUrlPayResult_PayError value) payError,
  }) {
    return endpointError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LnUrlPayResult_EndpointSuccess value)? endpointSuccess,
    TResult? Function(LnUrlPayResult_EndpointError value)? endpointError,
    TResult? Function(LnUrlPayResult_PayError value)? payError,
  }) {
    return endpointError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LnUrlPayResult_EndpointSuccess value)? endpointSuccess,
    TResult Function(LnUrlPayResult_EndpointError value)? endpointError,
    TResult Function(LnUrlPayResult_PayError value)? payError,
    required TResult orElse(),
  }) {
    if (endpointError != null) {
      return endpointError(this);
    }
    return orElse();
  }
}

abstract class LnUrlPayResult_EndpointError extends LnUrlPayResult {
  const factory LnUrlPayResult_EndpointError({required final LnUrlErrorData data}) =
      _$LnUrlPayResult_EndpointErrorImpl;
  const LnUrlPayResult_EndpointError._() : super._();

  @override
  LnUrlErrorData get data;
  @JsonKey(ignore: true)
  _$$LnUrlPayResult_EndpointErrorImplCopyWith<_$LnUrlPayResult_EndpointErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LnUrlPayResult_PayErrorImplCopyWith<$Res> {
  factory _$$LnUrlPayResult_PayErrorImplCopyWith(
          _$LnUrlPayResult_PayErrorImpl value, $Res Function(_$LnUrlPayResult_PayErrorImpl) then) =
      __$$LnUrlPayResult_PayErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlPayErrorData data});
}

/// @nodoc
class __$$LnUrlPayResult_PayErrorImplCopyWithImpl<$Res>
    extends _$LnUrlPayResultCopyWithImpl<$Res, _$LnUrlPayResult_PayErrorImpl>
    implements _$$LnUrlPayResult_PayErrorImplCopyWith<$Res> {
  __$$LnUrlPayResult_PayErrorImplCopyWithImpl(
      _$LnUrlPayResult_PayErrorImpl _value, $Res Function(_$LnUrlPayResult_PayErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$LnUrlPayResult_PayErrorImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LnUrlPayErrorData,
    ));
  }
}

/// @nodoc

class _$LnUrlPayResult_PayErrorImpl extends LnUrlPayResult_PayError {
  const _$LnUrlPayResult_PayErrorImpl({required this.data}) : super._();

  @override
  final LnUrlPayErrorData data;

  @override
  String toString() {
    return 'LnUrlPayResult.payError(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LnUrlPayResult_PayErrorImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LnUrlPayResult_PayErrorImplCopyWith<_$LnUrlPayResult_PayErrorImpl> get copyWith =>
      __$$LnUrlPayResult_PayErrorImplCopyWithImpl<_$LnUrlPayResult_PayErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LnUrlPaySuccessData data) endpointSuccess,
    required TResult Function(LnUrlErrorData data) endpointError,
    required TResult Function(LnUrlPayErrorData data) payError,
  }) {
    return payError(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LnUrlPaySuccessData data)? endpointSuccess,
    TResult? Function(LnUrlErrorData data)? endpointError,
    TResult? Function(LnUrlPayErrorData data)? payError,
  }) {
    return payError?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LnUrlPaySuccessData data)? endpointSuccess,
    TResult Function(LnUrlErrorData data)? endpointError,
    TResult Function(LnUrlPayErrorData data)? payError,
    required TResult orElse(),
  }) {
    if (payError != null) {
      return payError(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LnUrlPayResult_EndpointSuccess value) endpointSuccess,
    required TResult Function(LnUrlPayResult_EndpointError value) endpointError,
    required TResult Function(LnUrlPayResult_PayError value) payError,
  }) {
    return payError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LnUrlPayResult_EndpointSuccess value)? endpointSuccess,
    TResult? Function(LnUrlPayResult_EndpointError value)? endpointError,
    TResult? Function(LnUrlPayResult_PayError value)? payError,
  }) {
    return payError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LnUrlPayResult_EndpointSuccess value)? endpointSuccess,
    TResult Function(LnUrlPayResult_EndpointError value)? endpointError,
    TResult Function(LnUrlPayResult_PayError value)? payError,
    required TResult orElse(),
  }) {
    if (payError != null) {
      return payError(this);
    }
    return orElse();
  }
}

abstract class LnUrlPayResult_PayError extends LnUrlPayResult {
  const factory LnUrlPayResult_PayError({required final LnUrlPayErrorData data}) =
      _$LnUrlPayResult_PayErrorImpl;
  const LnUrlPayResult_PayError._() : super._();

  @override
  LnUrlPayErrorData get data;
  @JsonKey(ignore: true)
  _$$LnUrlPayResult_PayErrorImplCopyWith<_$LnUrlPayResult_PayErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SuccessActionProcessed {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AesSuccessActionDataResult result) aes,
    required TResult Function(MessageSuccessActionData data) message,
    required TResult Function(UrlSuccessActionData data) url,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AesSuccessActionDataResult result)? aes,
    TResult? Function(MessageSuccessActionData data)? message,
    TResult? Function(UrlSuccessActionData data)? url,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AesSuccessActionDataResult result)? aes,
    TResult Function(MessageSuccessActionData data)? message,
    TResult Function(UrlSuccessActionData data)? url,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SuccessActionProcessed_Aes value) aes,
    required TResult Function(SuccessActionProcessed_Message value) message,
    required TResult Function(SuccessActionProcessed_Url value) url,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SuccessActionProcessed_Aes value)? aes,
    TResult? Function(SuccessActionProcessed_Message value)? message,
    TResult? Function(SuccessActionProcessed_Url value)? url,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SuccessActionProcessed_Aes value)? aes,
    TResult Function(SuccessActionProcessed_Message value)? message,
    TResult Function(SuccessActionProcessed_Url value)? url,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuccessActionProcessedCopyWith<$Res> {
  factory $SuccessActionProcessedCopyWith(
          SuccessActionProcessed value, $Res Function(SuccessActionProcessed) then) =
      _$SuccessActionProcessedCopyWithImpl<$Res, SuccessActionProcessed>;
}

/// @nodoc
class _$SuccessActionProcessedCopyWithImpl<$Res, $Val extends SuccessActionProcessed>
    implements $SuccessActionProcessedCopyWith<$Res> {
  _$SuccessActionProcessedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SuccessActionProcessed_AesImplCopyWith<$Res> {
  factory _$$SuccessActionProcessed_AesImplCopyWith(
          _$SuccessActionProcessed_AesImpl value, $Res Function(_$SuccessActionProcessed_AesImpl) then) =
      __$$SuccessActionProcessed_AesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AesSuccessActionDataResult result});

  $AesSuccessActionDataResultCopyWith<$Res> get result;
}

/// @nodoc
class __$$SuccessActionProcessed_AesImplCopyWithImpl<$Res>
    extends _$SuccessActionProcessedCopyWithImpl<$Res, _$SuccessActionProcessed_AesImpl>
    implements _$$SuccessActionProcessed_AesImplCopyWith<$Res> {
  __$$SuccessActionProcessed_AesImplCopyWithImpl(
      _$SuccessActionProcessed_AesImpl _value, $Res Function(_$SuccessActionProcessed_AesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
  }) {
    return _then(_$SuccessActionProcessed_AesImpl(
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as AesSuccessActionDataResult,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $AesSuccessActionDataResultCopyWith<$Res> get result {
    return $AesSuccessActionDataResultCopyWith<$Res>(_value.result, (value) {
      return _then(_value.copyWith(result: value));
    });
  }
}

/// @nodoc

class _$SuccessActionProcessed_AesImpl extends SuccessActionProcessed_Aes {
  const _$SuccessActionProcessed_AesImpl({required this.result}) : super._();

  @override
  final AesSuccessActionDataResult result;

  @override
  String toString() {
    return 'SuccessActionProcessed.aes(result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessActionProcessed_AesImpl &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessActionProcessed_AesImplCopyWith<_$SuccessActionProcessed_AesImpl> get copyWith =>
      __$$SuccessActionProcessed_AesImplCopyWithImpl<_$SuccessActionProcessed_AesImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AesSuccessActionDataResult result) aes,
    required TResult Function(MessageSuccessActionData data) message,
    required TResult Function(UrlSuccessActionData data) url,
  }) {
    return aes(result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AesSuccessActionDataResult result)? aes,
    TResult? Function(MessageSuccessActionData data)? message,
    TResult? Function(UrlSuccessActionData data)? url,
  }) {
    return aes?.call(result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AesSuccessActionDataResult result)? aes,
    TResult Function(MessageSuccessActionData data)? message,
    TResult Function(UrlSuccessActionData data)? url,
    required TResult orElse(),
  }) {
    if (aes != null) {
      return aes(result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SuccessActionProcessed_Aes value) aes,
    required TResult Function(SuccessActionProcessed_Message value) message,
    required TResult Function(SuccessActionProcessed_Url value) url,
  }) {
    return aes(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SuccessActionProcessed_Aes value)? aes,
    TResult? Function(SuccessActionProcessed_Message value)? message,
    TResult? Function(SuccessActionProcessed_Url value)? url,
  }) {
    return aes?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SuccessActionProcessed_Aes value)? aes,
    TResult Function(SuccessActionProcessed_Message value)? message,
    TResult Function(SuccessActionProcessed_Url value)? url,
    required TResult orElse(),
  }) {
    if (aes != null) {
      return aes(this);
    }
    return orElse();
  }
}

abstract class SuccessActionProcessed_Aes extends SuccessActionProcessed {
  const factory SuccessActionProcessed_Aes({required final AesSuccessActionDataResult result}) =
      _$SuccessActionProcessed_AesImpl;
  const SuccessActionProcessed_Aes._() : super._();

  AesSuccessActionDataResult get result;
  @JsonKey(ignore: true)
  _$$SuccessActionProcessed_AesImplCopyWith<_$SuccessActionProcessed_AesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SuccessActionProcessed_MessageImplCopyWith<$Res> {
  factory _$$SuccessActionProcessed_MessageImplCopyWith(_$SuccessActionProcessed_MessageImpl value,
          $Res Function(_$SuccessActionProcessed_MessageImpl) then) =
      __$$SuccessActionProcessed_MessageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({MessageSuccessActionData data});
}

/// @nodoc
class __$$SuccessActionProcessed_MessageImplCopyWithImpl<$Res>
    extends _$SuccessActionProcessedCopyWithImpl<$Res, _$SuccessActionProcessed_MessageImpl>
    implements _$$SuccessActionProcessed_MessageImplCopyWith<$Res> {
  __$$SuccessActionProcessed_MessageImplCopyWithImpl(
      _$SuccessActionProcessed_MessageImpl _value, $Res Function(_$SuccessActionProcessed_MessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$SuccessActionProcessed_MessageImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as MessageSuccessActionData,
    ));
  }
}

/// @nodoc

class _$SuccessActionProcessed_MessageImpl extends SuccessActionProcessed_Message {
  const _$SuccessActionProcessed_MessageImpl({required this.data}) : super._();

  @override
  final MessageSuccessActionData data;

  @override
  String toString() {
    return 'SuccessActionProcessed.message(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessActionProcessed_MessageImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessActionProcessed_MessageImplCopyWith<_$SuccessActionProcessed_MessageImpl> get copyWith =>
      __$$SuccessActionProcessed_MessageImplCopyWithImpl<_$SuccessActionProcessed_MessageImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AesSuccessActionDataResult result) aes,
    required TResult Function(MessageSuccessActionData data) message,
    required TResult Function(UrlSuccessActionData data) url,
  }) {
    return message(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AesSuccessActionDataResult result)? aes,
    TResult? Function(MessageSuccessActionData data)? message,
    TResult? Function(UrlSuccessActionData data)? url,
  }) {
    return message?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AesSuccessActionDataResult result)? aes,
    TResult Function(MessageSuccessActionData data)? message,
    TResult Function(UrlSuccessActionData data)? url,
    required TResult orElse(),
  }) {
    if (message != null) {
      return message(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SuccessActionProcessed_Aes value) aes,
    required TResult Function(SuccessActionProcessed_Message value) message,
    required TResult Function(SuccessActionProcessed_Url value) url,
  }) {
    return message(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SuccessActionProcessed_Aes value)? aes,
    TResult? Function(SuccessActionProcessed_Message value)? message,
    TResult? Function(SuccessActionProcessed_Url value)? url,
  }) {
    return message?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SuccessActionProcessed_Aes value)? aes,
    TResult Function(SuccessActionProcessed_Message value)? message,
    TResult Function(SuccessActionProcessed_Url value)? url,
    required TResult orElse(),
  }) {
    if (message != null) {
      return message(this);
    }
    return orElse();
  }
}

abstract class SuccessActionProcessed_Message extends SuccessActionProcessed {
  const factory SuccessActionProcessed_Message({required final MessageSuccessActionData data}) =
      _$SuccessActionProcessed_MessageImpl;
  const SuccessActionProcessed_Message._() : super._();

  MessageSuccessActionData get data;
  @JsonKey(ignore: true)
  _$$SuccessActionProcessed_MessageImplCopyWith<_$SuccessActionProcessed_MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SuccessActionProcessed_UrlImplCopyWith<$Res> {
  factory _$$SuccessActionProcessed_UrlImplCopyWith(
          _$SuccessActionProcessed_UrlImpl value, $Res Function(_$SuccessActionProcessed_UrlImpl) then) =
      __$$SuccessActionProcessed_UrlImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UrlSuccessActionData data});
}

/// @nodoc
class __$$SuccessActionProcessed_UrlImplCopyWithImpl<$Res>
    extends _$SuccessActionProcessedCopyWithImpl<$Res, _$SuccessActionProcessed_UrlImpl>
    implements _$$SuccessActionProcessed_UrlImplCopyWith<$Res> {
  __$$SuccessActionProcessed_UrlImplCopyWithImpl(
      _$SuccessActionProcessed_UrlImpl _value, $Res Function(_$SuccessActionProcessed_UrlImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$SuccessActionProcessed_UrlImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as UrlSuccessActionData,
    ));
  }
}

/// @nodoc

class _$SuccessActionProcessed_UrlImpl extends SuccessActionProcessed_Url {
  const _$SuccessActionProcessed_UrlImpl({required this.data}) : super._();

  @override
  final UrlSuccessActionData data;

  @override
  String toString() {
    return 'SuccessActionProcessed.url(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessActionProcessed_UrlImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessActionProcessed_UrlImplCopyWith<_$SuccessActionProcessed_UrlImpl> get copyWith =>
      __$$SuccessActionProcessed_UrlImplCopyWithImpl<_$SuccessActionProcessed_UrlImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AesSuccessActionDataResult result) aes,
    required TResult Function(MessageSuccessActionData data) message,
    required TResult Function(UrlSuccessActionData data) url,
  }) {
    return url(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AesSuccessActionDataResult result)? aes,
    TResult? Function(MessageSuccessActionData data)? message,
    TResult? Function(UrlSuccessActionData data)? url,
  }) {
    return url?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AesSuccessActionDataResult result)? aes,
    TResult Function(MessageSuccessActionData data)? message,
    TResult Function(UrlSuccessActionData data)? url,
    required TResult orElse(),
  }) {
    if (url != null) {
      return url(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SuccessActionProcessed_Aes value) aes,
    required TResult Function(SuccessActionProcessed_Message value) message,
    required TResult Function(SuccessActionProcessed_Url value) url,
  }) {
    return url(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SuccessActionProcessed_Aes value)? aes,
    TResult? Function(SuccessActionProcessed_Message value)? message,
    TResult? Function(SuccessActionProcessed_Url value)? url,
  }) {
    return url?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SuccessActionProcessed_Aes value)? aes,
    TResult Function(SuccessActionProcessed_Message value)? message,
    TResult Function(SuccessActionProcessed_Url value)? url,
    required TResult orElse(),
  }) {
    if (url != null) {
      return url(this);
    }
    return orElse();
  }
}

abstract class SuccessActionProcessed_Url extends SuccessActionProcessed {
  const factory SuccessActionProcessed_Url({required final UrlSuccessActionData data}) =
      _$SuccessActionProcessed_UrlImpl;
  const SuccessActionProcessed_Url._() : super._();

  UrlSuccessActionData get data;
  @JsonKey(ignore: true)
  _$$SuccessActionProcessed_UrlImplCopyWith<_$SuccessActionProcessed_UrlImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
