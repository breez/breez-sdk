// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bridge_generated.dart';

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

class _$AesSuccessActionDataResult_DecryptedImpl implements AesSuccessActionDataResult_Decrypted {
  const _$AesSuccessActionDataResult_DecryptedImpl({required this.data});

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

abstract class AesSuccessActionDataResult_Decrypted implements AesSuccessActionDataResult {
  const factory AesSuccessActionDataResult_Decrypted({required final AesSuccessActionDataDecrypted data}) =
      _$AesSuccessActionDataResult_DecryptedImpl;

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

class _$AesSuccessActionDataResult_ErrorStatusImpl implements AesSuccessActionDataResult_ErrorStatus {
  const _$AesSuccessActionDataResult_ErrorStatusImpl({required this.reason});

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

abstract class AesSuccessActionDataResult_ErrorStatus implements AesSuccessActionDataResult {
  const factory AesSuccessActionDataResult_ErrorStatus({required final String reason}) =
      _$AesSuccessActionDataResult_ErrorStatusImpl;

  String get reason;
  @JsonKey(ignore: true)
  _$$AesSuccessActionDataResult_ErrorStatusImplCopyWith<_$AesSuccessActionDataResult_ErrorStatusImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BreezEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int block) newBlock,
    required TResult Function(InvoicePaidDetails details) invoicePaid,
    required TResult Function() synced,
    required TResult Function(Payment details) paymentStarted,
    required TResult Function(Payment details) paymentSucceed,
    required TResult Function(PaymentFailedData details) paymentFailed,
    required TResult Function() backupStarted,
    required TResult Function() backupSucceeded,
    required TResult Function(BackupFailedData details) backupFailed,
    required TResult Function(SwapInfo details) swapUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int block)? newBlock,
    TResult? Function(InvoicePaidDetails details)? invoicePaid,
    TResult? Function()? synced,
    TResult? Function(Payment details)? paymentStarted,
    TResult? Function(Payment details)? paymentSucceed,
    TResult? Function(PaymentFailedData details)? paymentFailed,
    TResult? Function()? backupStarted,
    TResult? Function()? backupSucceeded,
    TResult? Function(BackupFailedData details)? backupFailed,
    TResult? Function(SwapInfo details)? swapUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int block)? newBlock,
    TResult Function(InvoicePaidDetails details)? invoicePaid,
    TResult Function()? synced,
    TResult Function(Payment details)? paymentStarted,
    TResult Function(Payment details)? paymentSucceed,
    TResult Function(PaymentFailedData details)? paymentFailed,
    TResult Function()? backupStarted,
    TResult Function()? backupSucceeded,
    TResult Function(BackupFailedData details)? backupFailed,
    TResult Function(SwapInfo details)? swapUpdated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BreezEvent_NewBlock value) newBlock,
    required TResult Function(BreezEvent_InvoicePaid value) invoicePaid,
    required TResult Function(BreezEvent_Synced value) synced,
    required TResult Function(BreezEvent_PaymentStarted value) paymentStarted,
    required TResult Function(BreezEvent_PaymentSucceed value) paymentSucceed,
    required TResult Function(BreezEvent_PaymentFailed value) paymentFailed,
    required TResult Function(BreezEvent_BackupStarted value) backupStarted,
    required TResult Function(BreezEvent_BackupSucceeded value) backupSucceeded,
    required TResult Function(BreezEvent_BackupFailed value) backupFailed,
    required TResult Function(BreezEvent_SwapUpdated value) swapUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BreezEvent_NewBlock value)? newBlock,
    TResult? Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult? Function(BreezEvent_Synced value)? synced,
    TResult? Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult? Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult? Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult? Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult? Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult? Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult? Function(BreezEvent_SwapUpdated value)? swapUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BreezEvent_NewBlock value)? newBlock,
    TResult Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult Function(BreezEvent_Synced value)? synced,
    TResult Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult Function(BreezEvent_SwapUpdated value)? swapUpdated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreezEventCopyWith<$Res> {
  factory $BreezEventCopyWith(BreezEvent value, $Res Function(BreezEvent) then) =
      _$BreezEventCopyWithImpl<$Res, BreezEvent>;
}

/// @nodoc
class _$BreezEventCopyWithImpl<$Res, $Val extends BreezEvent> implements $BreezEventCopyWith<$Res> {
  _$BreezEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$BreezEvent_NewBlockImplCopyWith<$Res> {
  factory _$$BreezEvent_NewBlockImplCopyWith(
          _$BreezEvent_NewBlockImpl value, $Res Function(_$BreezEvent_NewBlockImpl) then) =
      __$$BreezEvent_NewBlockImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int block});
}

/// @nodoc
class __$$BreezEvent_NewBlockImplCopyWithImpl<$Res>
    extends _$BreezEventCopyWithImpl<$Res, _$BreezEvent_NewBlockImpl>
    implements _$$BreezEvent_NewBlockImplCopyWith<$Res> {
  __$$BreezEvent_NewBlockImplCopyWithImpl(
      _$BreezEvent_NewBlockImpl _value, $Res Function(_$BreezEvent_NewBlockImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? block = null,
  }) {
    return _then(_$BreezEvent_NewBlockImpl(
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$BreezEvent_NewBlockImpl implements BreezEvent_NewBlock {
  const _$BreezEvent_NewBlockImpl({required this.block});

  @override
  final int block;

  @override
  String toString() {
    return 'BreezEvent.newBlock(block: $block)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreezEvent_NewBlockImpl &&
            (identical(other.block, block) || other.block == block));
  }

  @override
  int get hashCode => Object.hash(runtimeType, block);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreezEvent_NewBlockImplCopyWith<_$BreezEvent_NewBlockImpl> get copyWith =>
      __$$BreezEvent_NewBlockImplCopyWithImpl<_$BreezEvent_NewBlockImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int block) newBlock,
    required TResult Function(InvoicePaidDetails details) invoicePaid,
    required TResult Function() synced,
    required TResult Function(Payment details) paymentStarted,
    required TResult Function(Payment details) paymentSucceed,
    required TResult Function(PaymentFailedData details) paymentFailed,
    required TResult Function() backupStarted,
    required TResult Function() backupSucceeded,
    required TResult Function(BackupFailedData details) backupFailed,
    required TResult Function(SwapInfo details) swapUpdated,
  }) {
    return newBlock(block);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int block)? newBlock,
    TResult? Function(InvoicePaidDetails details)? invoicePaid,
    TResult? Function()? synced,
    TResult? Function(Payment details)? paymentStarted,
    TResult? Function(Payment details)? paymentSucceed,
    TResult? Function(PaymentFailedData details)? paymentFailed,
    TResult? Function()? backupStarted,
    TResult? Function()? backupSucceeded,
    TResult? Function(BackupFailedData details)? backupFailed,
    TResult? Function(SwapInfo details)? swapUpdated,
  }) {
    return newBlock?.call(block);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int block)? newBlock,
    TResult Function(InvoicePaidDetails details)? invoicePaid,
    TResult Function()? synced,
    TResult Function(Payment details)? paymentStarted,
    TResult Function(Payment details)? paymentSucceed,
    TResult Function(PaymentFailedData details)? paymentFailed,
    TResult Function()? backupStarted,
    TResult Function()? backupSucceeded,
    TResult Function(BackupFailedData details)? backupFailed,
    TResult Function(SwapInfo details)? swapUpdated,
    required TResult orElse(),
  }) {
    if (newBlock != null) {
      return newBlock(block);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BreezEvent_NewBlock value) newBlock,
    required TResult Function(BreezEvent_InvoicePaid value) invoicePaid,
    required TResult Function(BreezEvent_Synced value) synced,
    required TResult Function(BreezEvent_PaymentStarted value) paymentStarted,
    required TResult Function(BreezEvent_PaymentSucceed value) paymentSucceed,
    required TResult Function(BreezEvent_PaymentFailed value) paymentFailed,
    required TResult Function(BreezEvent_BackupStarted value) backupStarted,
    required TResult Function(BreezEvent_BackupSucceeded value) backupSucceeded,
    required TResult Function(BreezEvent_BackupFailed value) backupFailed,
    required TResult Function(BreezEvent_SwapUpdated value) swapUpdated,
  }) {
    return newBlock(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BreezEvent_NewBlock value)? newBlock,
    TResult? Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult? Function(BreezEvent_Synced value)? synced,
    TResult? Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult? Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult? Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult? Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult? Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult? Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult? Function(BreezEvent_SwapUpdated value)? swapUpdated,
  }) {
    return newBlock?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BreezEvent_NewBlock value)? newBlock,
    TResult Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult Function(BreezEvent_Synced value)? synced,
    TResult Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult Function(BreezEvent_SwapUpdated value)? swapUpdated,
    required TResult orElse(),
  }) {
    if (newBlock != null) {
      return newBlock(this);
    }
    return orElse();
  }
}

abstract class BreezEvent_NewBlock implements BreezEvent {
  const factory BreezEvent_NewBlock({required final int block}) = _$BreezEvent_NewBlockImpl;

  int get block;
  @JsonKey(ignore: true)
  _$$BreezEvent_NewBlockImplCopyWith<_$BreezEvent_NewBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BreezEvent_InvoicePaidImplCopyWith<$Res> {
  factory _$$BreezEvent_InvoicePaidImplCopyWith(
          _$BreezEvent_InvoicePaidImpl value, $Res Function(_$BreezEvent_InvoicePaidImpl) then) =
      __$$BreezEvent_InvoicePaidImplCopyWithImpl<$Res>;
  @useResult
  $Res call({InvoicePaidDetails details});
}

/// @nodoc
class __$$BreezEvent_InvoicePaidImplCopyWithImpl<$Res>
    extends _$BreezEventCopyWithImpl<$Res, _$BreezEvent_InvoicePaidImpl>
    implements _$$BreezEvent_InvoicePaidImplCopyWith<$Res> {
  __$$BreezEvent_InvoicePaidImplCopyWithImpl(
      _$BreezEvent_InvoicePaidImpl _value, $Res Function(_$BreezEvent_InvoicePaidImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? details = null,
  }) {
    return _then(_$BreezEvent_InvoicePaidImpl(
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as InvoicePaidDetails,
    ));
  }
}

/// @nodoc

class _$BreezEvent_InvoicePaidImpl implements BreezEvent_InvoicePaid {
  const _$BreezEvent_InvoicePaidImpl({required this.details});

  @override
  final InvoicePaidDetails details;

  @override
  String toString() {
    return 'BreezEvent.invoicePaid(details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreezEvent_InvoicePaidImpl &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreezEvent_InvoicePaidImplCopyWith<_$BreezEvent_InvoicePaidImpl> get copyWith =>
      __$$BreezEvent_InvoicePaidImplCopyWithImpl<_$BreezEvent_InvoicePaidImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int block) newBlock,
    required TResult Function(InvoicePaidDetails details) invoicePaid,
    required TResult Function() synced,
    required TResult Function(Payment details) paymentStarted,
    required TResult Function(Payment details) paymentSucceed,
    required TResult Function(PaymentFailedData details) paymentFailed,
    required TResult Function() backupStarted,
    required TResult Function() backupSucceeded,
    required TResult Function(BackupFailedData details) backupFailed,
    required TResult Function(SwapInfo details) swapUpdated,
  }) {
    return invoicePaid(details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int block)? newBlock,
    TResult? Function(InvoicePaidDetails details)? invoicePaid,
    TResult? Function()? synced,
    TResult? Function(Payment details)? paymentStarted,
    TResult? Function(Payment details)? paymentSucceed,
    TResult? Function(PaymentFailedData details)? paymentFailed,
    TResult? Function()? backupStarted,
    TResult? Function()? backupSucceeded,
    TResult? Function(BackupFailedData details)? backupFailed,
    TResult? Function(SwapInfo details)? swapUpdated,
  }) {
    return invoicePaid?.call(details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int block)? newBlock,
    TResult Function(InvoicePaidDetails details)? invoicePaid,
    TResult Function()? synced,
    TResult Function(Payment details)? paymentStarted,
    TResult Function(Payment details)? paymentSucceed,
    TResult Function(PaymentFailedData details)? paymentFailed,
    TResult Function()? backupStarted,
    TResult Function()? backupSucceeded,
    TResult Function(BackupFailedData details)? backupFailed,
    TResult Function(SwapInfo details)? swapUpdated,
    required TResult orElse(),
  }) {
    if (invoicePaid != null) {
      return invoicePaid(details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BreezEvent_NewBlock value) newBlock,
    required TResult Function(BreezEvent_InvoicePaid value) invoicePaid,
    required TResult Function(BreezEvent_Synced value) synced,
    required TResult Function(BreezEvent_PaymentStarted value) paymentStarted,
    required TResult Function(BreezEvent_PaymentSucceed value) paymentSucceed,
    required TResult Function(BreezEvent_PaymentFailed value) paymentFailed,
    required TResult Function(BreezEvent_BackupStarted value) backupStarted,
    required TResult Function(BreezEvent_BackupSucceeded value) backupSucceeded,
    required TResult Function(BreezEvent_BackupFailed value) backupFailed,
    required TResult Function(BreezEvent_SwapUpdated value) swapUpdated,
  }) {
    return invoicePaid(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BreezEvent_NewBlock value)? newBlock,
    TResult? Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult? Function(BreezEvent_Synced value)? synced,
    TResult? Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult? Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult? Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult? Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult? Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult? Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult? Function(BreezEvent_SwapUpdated value)? swapUpdated,
  }) {
    return invoicePaid?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BreezEvent_NewBlock value)? newBlock,
    TResult Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult Function(BreezEvent_Synced value)? synced,
    TResult Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult Function(BreezEvent_SwapUpdated value)? swapUpdated,
    required TResult orElse(),
  }) {
    if (invoicePaid != null) {
      return invoicePaid(this);
    }
    return orElse();
  }
}

abstract class BreezEvent_InvoicePaid implements BreezEvent {
  const factory BreezEvent_InvoicePaid({required final InvoicePaidDetails details}) =
      _$BreezEvent_InvoicePaidImpl;

  InvoicePaidDetails get details;
  @JsonKey(ignore: true)
  _$$BreezEvent_InvoicePaidImplCopyWith<_$BreezEvent_InvoicePaidImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BreezEvent_SyncedImplCopyWith<$Res> {
  factory _$$BreezEvent_SyncedImplCopyWith(
          _$BreezEvent_SyncedImpl value, $Res Function(_$BreezEvent_SyncedImpl) then) =
      __$$BreezEvent_SyncedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BreezEvent_SyncedImplCopyWithImpl<$Res>
    extends _$BreezEventCopyWithImpl<$Res, _$BreezEvent_SyncedImpl>
    implements _$$BreezEvent_SyncedImplCopyWith<$Res> {
  __$$BreezEvent_SyncedImplCopyWithImpl(
      _$BreezEvent_SyncedImpl _value, $Res Function(_$BreezEvent_SyncedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$BreezEvent_SyncedImpl implements BreezEvent_Synced {
  const _$BreezEvent_SyncedImpl();

  @override
  String toString() {
    return 'BreezEvent.synced()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is _$BreezEvent_SyncedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int block) newBlock,
    required TResult Function(InvoicePaidDetails details) invoicePaid,
    required TResult Function() synced,
    required TResult Function(Payment details) paymentStarted,
    required TResult Function(Payment details) paymentSucceed,
    required TResult Function(PaymentFailedData details) paymentFailed,
    required TResult Function() backupStarted,
    required TResult Function() backupSucceeded,
    required TResult Function(BackupFailedData details) backupFailed,
    required TResult Function(SwapInfo details) swapUpdated,
  }) {
    return synced();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int block)? newBlock,
    TResult? Function(InvoicePaidDetails details)? invoicePaid,
    TResult? Function()? synced,
    TResult? Function(Payment details)? paymentStarted,
    TResult? Function(Payment details)? paymentSucceed,
    TResult? Function(PaymentFailedData details)? paymentFailed,
    TResult? Function()? backupStarted,
    TResult? Function()? backupSucceeded,
    TResult? Function(BackupFailedData details)? backupFailed,
    TResult? Function(SwapInfo details)? swapUpdated,
  }) {
    return synced?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int block)? newBlock,
    TResult Function(InvoicePaidDetails details)? invoicePaid,
    TResult Function()? synced,
    TResult Function(Payment details)? paymentStarted,
    TResult Function(Payment details)? paymentSucceed,
    TResult Function(PaymentFailedData details)? paymentFailed,
    TResult Function()? backupStarted,
    TResult Function()? backupSucceeded,
    TResult Function(BackupFailedData details)? backupFailed,
    TResult Function(SwapInfo details)? swapUpdated,
    required TResult orElse(),
  }) {
    if (synced != null) {
      return synced();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BreezEvent_NewBlock value) newBlock,
    required TResult Function(BreezEvent_InvoicePaid value) invoicePaid,
    required TResult Function(BreezEvent_Synced value) synced,
    required TResult Function(BreezEvent_PaymentStarted value) paymentStarted,
    required TResult Function(BreezEvent_PaymentSucceed value) paymentSucceed,
    required TResult Function(BreezEvent_PaymentFailed value) paymentFailed,
    required TResult Function(BreezEvent_BackupStarted value) backupStarted,
    required TResult Function(BreezEvent_BackupSucceeded value) backupSucceeded,
    required TResult Function(BreezEvent_BackupFailed value) backupFailed,
    required TResult Function(BreezEvent_SwapUpdated value) swapUpdated,
  }) {
    return synced(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BreezEvent_NewBlock value)? newBlock,
    TResult? Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult? Function(BreezEvent_Synced value)? synced,
    TResult? Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult? Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult? Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult? Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult? Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult? Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult? Function(BreezEvent_SwapUpdated value)? swapUpdated,
  }) {
    return synced?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BreezEvent_NewBlock value)? newBlock,
    TResult Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult Function(BreezEvent_Synced value)? synced,
    TResult Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult Function(BreezEvent_SwapUpdated value)? swapUpdated,
    required TResult orElse(),
  }) {
    if (synced != null) {
      return synced(this);
    }
    return orElse();
  }
}

abstract class BreezEvent_Synced implements BreezEvent {
  const factory BreezEvent_Synced() = _$BreezEvent_SyncedImpl;
}

/// @nodoc
abstract class _$$BreezEvent_PaymentStartedImplCopyWith<$Res> {
  factory _$$BreezEvent_PaymentStartedImplCopyWith(
          _$BreezEvent_PaymentStartedImpl value, $Res Function(_$BreezEvent_PaymentStartedImpl) then) =
      __$$BreezEvent_PaymentStartedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Payment details});
}

/// @nodoc
class __$$BreezEvent_PaymentStartedImplCopyWithImpl<$Res>
    extends _$BreezEventCopyWithImpl<$Res, _$BreezEvent_PaymentStartedImpl>
    implements _$$BreezEvent_PaymentStartedImplCopyWith<$Res> {
  __$$BreezEvent_PaymentStartedImplCopyWithImpl(
      _$BreezEvent_PaymentStartedImpl _value, $Res Function(_$BreezEvent_PaymentStartedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? details = null,
  }) {
    return _then(_$BreezEvent_PaymentStartedImpl(
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as Payment,
    ));
  }
}

/// @nodoc

class _$BreezEvent_PaymentStartedImpl implements BreezEvent_PaymentStarted {
  const _$BreezEvent_PaymentStartedImpl({required this.details});

  @override
  final Payment details;

  @override
  String toString() {
    return 'BreezEvent.paymentStarted(details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreezEvent_PaymentStartedImpl &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreezEvent_PaymentStartedImplCopyWith<_$BreezEvent_PaymentStartedImpl> get copyWith =>
      __$$BreezEvent_PaymentStartedImplCopyWithImpl<_$BreezEvent_PaymentStartedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int block) newBlock,
    required TResult Function(InvoicePaidDetails details) invoicePaid,
    required TResult Function() synced,
    required TResult Function(Payment details) paymentStarted,
    required TResult Function(Payment details) paymentSucceed,
    required TResult Function(PaymentFailedData details) paymentFailed,
    required TResult Function() backupStarted,
    required TResult Function() backupSucceeded,
    required TResult Function(BackupFailedData details) backupFailed,
    required TResult Function(SwapInfo details) swapUpdated,
  }) {
    return paymentStarted(details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int block)? newBlock,
    TResult? Function(InvoicePaidDetails details)? invoicePaid,
    TResult? Function()? synced,
    TResult? Function(Payment details)? paymentStarted,
    TResult? Function(Payment details)? paymentSucceed,
    TResult? Function(PaymentFailedData details)? paymentFailed,
    TResult? Function()? backupStarted,
    TResult? Function()? backupSucceeded,
    TResult? Function(BackupFailedData details)? backupFailed,
    TResult? Function(SwapInfo details)? swapUpdated,
  }) {
    return paymentStarted?.call(details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int block)? newBlock,
    TResult Function(InvoicePaidDetails details)? invoicePaid,
    TResult Function()? synced,
    TResult Function(Payment details)? paymentStarted,
    TResult Function(Payment details)? paymentSucceed,
    TResult Function(PaymentFailedData details)? paymentFailed,
    TResult Function()? backupStarted,
    TResult Function()? backupSucceeded,
    TResult Function(BackupFailedData details)? backupFailed,
    TResult Function(SwapInfo details)? swapUpdated,
    required TResult orElse(),
  }) {
    if (paymentStarted != null) {
      return paymentStarted(details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BreezEvent_NewBlock value) newBlock,
    required TResult Function(BreezEvent_InvoicePaid value) invoicePaid,
    required TResult Function(BreezEvent_Synced value) synced,
    required TResult Function(BreezEvent_PaymentStarted value) paymentStarted,
    required TResult Function(BreezEvent_PaymentSucceed value) paymentSucceed,
    required TResult Function(BreezEvent_PaymentFailed value) paymentFailed,
    required TResult Function(BreezEvent_BackupStarted value) backupStarted,
    required TResult Function(BreezEvent_BackupSucceeded value) backupSucceeded,
    required TResult Function(BreezEvent_BackupFailed value) backupFailed,
    required TResult Function(BreezEvent_SwapUpdated value) swapUpdated,
  }) {
    return paymentStarted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BreezEvent_NewBlock value)? newBlock,
    TResult? Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult? Function(BreezEvent_Synced value)? synced,
    TResult? Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult? Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult? Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult? Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult? Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult? Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult? Function(BreezEvent_SwapUpdated value)? swapUpdated,
  }) {
    return paymentStarted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BreezEvent_NewBlock value)? newBlock,
    TResult Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult Function(BreezEvent_Synced value)? synced,
    TResult Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult Function(BreezEvent_SwapUpdated value)? swapUpdated,
    required TResult orElse(),
  }) {
    if (paymentStarted != null) {
      return paymentStarted(this);
    }
    return orElse();
  }
}

abstract class BreezEvent_PaymentStarted implements BreezEvent {
  const factory BreezEvent_PaymentStarted({required final Payment details}) = _$BreezEvent_PaymentStartedImpl;

  Payment get details;
  @JsonKey(ignore: true)
  _$$BreezEvent_PaymentStartedImplCopyWith<_$BreezEvent_PaymentStartedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BreezEvent_PaymentSucceedImplCopyWith<$Res> {
  factory _$$BreezEvent_PaymentSucceedImplCopyWith(
          _$BreezEvent_PaymentSucceedImpl value, $Res Function(_$BreezEvent_PaymentSucceedImpl) then) =
      __$$BreezEvent_PaymentSucceedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Payment details});
}

/// @nodoc
class __$$BreezEvent_PaymentSucceedImplCopyWithImpl<$Res>
    extends _$BreezEventCopyWithImpl<$Res, _$BreezEvent_PaymentSucceedImpl>
    implements _$$BreezEvent_PaymentSucceedImplCopyWith<$Res> {
  __$$BreezEvent_PaymentSucceedImplCopyWithImpl(
      _$BreezEvent_PaymentSucceedImpl _value, $Res Function(_$BreezEvent_PaymentSucceedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? details = null,
  }) {
    return _then(_$BreezEvent_PaymentSucceedImpl(
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as Payment,
    ));
  }
}

/// @nodoc

class _$BreezEvent_PaymentSucceedImpl implements BreezEvent_PaymentSucceed {
  const _$BreezEvent_PaymentSucceedImpl({required this.details});

  @override
  final Payment details;

  @override
  String toString() {
    return 'BreezEvent.paymentSucceed(details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreezEvent_PaymentSucceedImpl &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreezEvent_PaymentSucceedImplCopyWith<_$BreezEvent_PaymentSucceedImpl> get copyWith =>
      __$$BreezEvent_PaymentSucceedImplCopyWithImpl<_$BreezEvent_PaymentSucceedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int block) newBlock,
    required TResult Function(InvoicePaidDetails details) invoicePaid,
    required TResult Function() synced,
    required TResult Function(Payment details) paymentStarted,
    required TResult Function(Payment details) paymentSucceed,
    required TResult Function(PaymentFailedData details) paymentFailed,
    required TResult Function() backupStarted,
    required TResult Function() backupSucceeded,
    required TResult Function(BackupFailedData details) backupFailed,
    required TResult Function(SwapInfo details) swapUpdated,
  }) {
    return paymentSucceed(details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int block)? newBlock,
    TResult? Function(InvoicePaidDetails details)? invoicePaid,
    TResult? Function()? synced,
    TResult? Function(Payment details)? paymentStarted,
    TResult? Function(Payment details)? paymentSucceed,
    TResult? Function(PaymentFailedData details)? paymentFailed,
    TResult? Function()? backupStarted,
    TResult? Function()? backupSucceeded,
    TResult? Function(BackupFailedData details)? backupFailed,
    TResult? Function(SwapInfo details)? swapUpdated,
  }) {
    return paymentSucceed?.call(details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int block)? newBlock,
    TResult Function(InvoicePaidDetails details)? invoicePaid,
    TResult Function()? synced,
    TResult Function(Payment details)? paymentStarted,
    TResult Function(Payment details)? paymentSucceed,
    TResult Function(PaymentFailedData details)? paymentFailed,
    TResult Function()? backupStarted,
    TResult Function()? backupSucceeded,
    TResult Function(BackupFailedData details)? backupFailed,
    TResult Function(SwapInfo details)? swapUpdated,
    required TResult orElse(),
  }) {
    if (paymentSucceed != null) {
      return paymentSucceed(details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BreezEvent_NewBlock value) newBlock,
    required TResult Function(BreezEvent_InvoicePaid value) invoicePaid,
    required TResult Function(BreezEvent_Synced value) synced,
    required TResult Function(BreezEvent_PaymentStarted value) paymentStarted,
    required TResult Function(BreezEvent_PaymentSucceed value) paymentSucceed,
    required TResult Function(BreezEvent_PaymentFailed value) paymentFailed,
    required TResult Function(BreezEvent_BackupStarted value) backupStarted,
    required TResult Function(BreezEvent_BackupSucceeded value) backupSucceeded,
    required TResult Function(BreezEvent_BackupFailed value) backupFailed,
    required TResult Function(BreezEvent_SwapUpdated value) swapUpdated,
  }) {
    return paymentSucceed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BreezEvent_NewBlock value)? newBlock,
    TResult? Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult? Function(BreezEvent_Synced value)? synced,
    TResult? Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult? Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult? Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult? Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult? Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult? Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult? Function(BreezEvent_SwapUpdated value)? swapUpdated,
  }) {
    return paymentSucceed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BreezEvent_NewBlock value)? newBlock,
    TResult Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult Function(BreezEvent_Synced value)? synced,
    TResult Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult Function(BreezEvent_SwapUpdated value)? swapUpdated,
    required TResult orElse(),
  }) {
    if (paymentSucceed != null) {
      return paymentSucceed(this);
    }
    return orElse();
  }
}

abstract class BreezEvent_PaymentSucceed implements BreezEvent {
  const factory BreezEvent_PaymentSucceed({required final Payment details}) = _$BreezEvent_PaymentSucceedImpl;

  Payment get details;
  @JsonKey(ignore: true)
  _$$BreezEvent_PaymentSucceedImplCopyWith<_$BreezEvent_PaymentSucceedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BreezEvent_PaymentFailedImplCopyWith<$Res> {
  factory _$$BreezEvent_PaymentFailedImplCopyWith(
          _$BreezEvent_PaymentFailedImpl value, $Res Function(_$BreezEvent_PaymentFailedImpl) then) =
      __$$BreezEvent_PaymentFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PaymentFailedData details});
}

/// @nodoc
class __$$BreezEvent_PaymentFailedImplCopyWithImpl<$Res>
    extends _$BreezEventCopyWithImpl<$Res, _$BreezEvent_PaymentFailedImpl>
    implements _$$BreezEvent_PaymentFailedImplCopyWith<$Res> {
  __$$BreezEvent_PaymentFailedImplCopyWithImpl(
      _$BreezEvent_PaymentFailedImpl _value, $Res Function(_$BreezEvent_PaymentFailedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? details = null,
  }) {
    return _then(_$BreezEvent_PaymentFailedImpl(
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as PaymentFailedData,
    ));
  }
}

/// @nodoc

class _$BreezEvent_PaymentFailedImpl implements BreezEvent_PaymentFailed {
  const _$BreezEvent_PaymentFailedImpl({required this.details});

  @override
  final PaymentFailedData details;

  @override
  String toString() {
    return 'BreezEvent.paymentFailed(details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreezEvent_PaymentFailedImpl &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreezEvent_PaymentFailedImplCopyWith<_$BreezEvent_PaymentFailedImpl> get copyWith =>
      __$$BreezEvent_PaymentFailedImplCopyWithImpl<_$BreezEvent_PaymentFailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int block) newBlock,
    required TResult Function(InvoicePaidDetails details) invoicePaid,
    required TResult Function() synced,
    required TResult Function(Payment details) paymentStarted,
    required TResult Function(Payment details) paymentSucceed,
    required TResult Function(PaymentFailedData details) paymentFailed,
    required TResult Function() backupStarted,
    required TResult Function() backupSucceeded,
    required TResult Function(BackupFailedData details) backupFailed,
    required TResult Function(SwapInfo details) swapUpdated,
  }) {
    return paymentFailed(details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int block)? newBlock,
    TResult? Function(InvoicePaidDetails details)? invoicePaid,
    TResult? Function()? synced,
    TResult? Function(Payment details)? paymentStarted,
    TResult? Function(Payment details)? paymentSucceed,
    TResult? Function(PaymentFailedData details)? paymentFailed,
    TResult? Function()? backupStarted,
    TResult? Function()? backupSucceeded,
    TResult? Function(BackupFailedData details)? backupFailed,
    TResult? Function(SwapInfo details)? swapUpdated,
  }) {
    return paymentFailed?.call(details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int block)? newBlock,
    TResult Function(InvoicePaidDetails details)? invoicePaid,
    TResult Function()? synced,
    TResult Function(Payment details)? paymentStarted,
    TResult Function(Payment details)? paymentSucceed,
    TResult Function(PaymentFailedData details)? paymentFailed,
    TResult Function()? backupStarted,
    TResult Function()? backupSucceeded,
    TResult Function(BackupFailedData details)? backupFailed,
    TResult Function(SwapInfo details)? swapUpdated,
    required TResult orElse(),
  }) {
    if (paymentFailed != null) {
      return paymentFailed(details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BreezEvent_NewBlock value) newBlock,
    required TResult Function(BreezEvent_InvoicePaid value) invoicePaid,
    required TResult Function(BreezEvent_Synced value) synced,
    required TResult Function(BreezEvent_PaymentStarted value) paymentStarted,
    required TResult Function(BreezEvent_PaymentSucceed value) paymentSucceed,
    required TResult Function(BreezEvent_PaymentFailed value) paymentFailed,
    required TResult Function(BreezEvent_BackupStarted value) backupStarted,
    required TResult Function(BreezEvent_BackupSucceeded value) backupSucceeded,
    required TResult Function(BreezEvent_BackupFailed value) backupFailed,
    required TResult Function(BreezEvent_SwapUpdated value) swapUpdated,
  }) {
    return paymentFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BreezEvent_NewBlock value)? newBlock,
    TResult? Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult? Function(BreezEvent_Synced value)? synced,
    TResult? Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult? Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult? Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult? Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult? Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult? Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult? Function(BreezEvent_SwapUpdated value)? swapUpdated,
  }) {
    return paymentFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BreezEvent_NewBlock value)? newBlock,
    TResult Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult Function(BreezEvent_Synced value)? synced,
    TResult Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult Function(BreezEvent_SwapUpdated value)? swapUpdated,
    required TResult orElse(),
  }) {
    if (paymentFailed != null) {
      return paymentFailed(this);
    }
    return orElse();
  }
}

abstract class BreezEvent_PaymentFailed implements BreezEvent {
  const factory BreezEvent_PaymentFailed({required final PaymentFailedData details}) =
      _$BreezEvent_PaymentFailedImpl;

  PaymentFailedData get details;
  @JsonKey(ignore: true)
  _$$BreezEvent_PaymentFailedImplCopyWith<_$BreezEvent_PaymentFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BreezEvent_BackupStartedImplCopyWith<$Res> {
  factory _$$BreezEvent_BackupStartedImplCopyWith(
          _$BreezEvent_BackupStartedImpl value, $Res Function(_$BreezEvent_BackupStartedImpl) then) =
      __$$BreezEvent_BackupStartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BreezEvent_BackupStartedImplCopyWithImpl<$Res>
    extends _$BreezEventCopyWithImpl<$Res, _$BreezEvent_BackupStartedImpl>
    implements _$$BreezEvent_BackupStartedImplCopyWith<$Res> {
  __$$BreezEvent_BackupStartedImplCopyWithImpl(
      _$BreezEvent_BackupStartedImpl _value, $Res Function(_$BreezEvent_BackupStartedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$BreezEvent_BackupStartedImpl implements BreezEvent_BackupStarted {
  const _$BreezEvent_BackupStartedImpl();

  @override
  String toString() {
    return 'BreezEvent.backupStarted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BreezEvent_BackupStartedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int block) newBlock,
    required TResult Function(InvoicePaidDetails details) invoicePaid,
    required TResult Function() synced,
    required TResult Function(Payment details) paymentStarted,
    required TResult Function(Payment details) paymentSucceed,
    required TResult Function(PaymentFailedData details) paymentFailed,
    required TResult Function() backupStarted,
    required TResult Function() backupSucceeded,
    required TResult Function(BackupFailedData details) backupFailed,
    required TResult Function(SwapInfo details) swapUpdated,
  }) {
    return backupStarted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int block)? newBlock,
    TResult? Function(InvoicePaidDetails details)? invoicePaid,
    TResult? Function()? synced,
    TResult? Function(Payment details)? paymentStarted,
    TResult? Function(Payment details)? paymentSucceed,
    TResult? Function(PaymentFailedData details)? paymentFailed,
    TResult? Function()? backupStarted,
    TResult? Function()? backupSucceeded,
    TResult? Function(BackupFailedData details)? backupFailed,
    TResult? Function(SwapInfo details)? swapUpdated,
  }) {
    return backupStarted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int block)? newBlock,
    TResult Function(InvoicePaidDetails details)? invoicePaid,
    TResult Function()? synced,
    TResult Function(Payment details)? paymentStarted,
    TResult Function(Payment details)? paymentSucceed,
    TResult Function(PaymentFailedData details)? paymentFailed,
    TResult Function()? backupStarted,
    TResult Function()? backupSucceeded,
    TResult Function(BackupFailedData details)? backupFailed,
    TResult Function(SwapInfo details)? swapUpdated,
    required TResult orElse(),
  }) {
    if (backupStarted != null) {
      return backupStarted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BreezEvent_NewBlock value) newBlock,
    required TResult Function(BreezEvent_InvoicePaid value) invoicePaid,
    required TResult Function(BreezEvent_Synced value) synced,
    required TResult Function(BreezEvent_PaymentStarted value) paymentStarted,
    required TResult Function(BreezEvent_PaymentSucceed value) paymentSucceed,
    required TResult Function(BreezEvent_PaymentFailed value) paymentFailed,
    required TResult Function(BreezEvent_BackupStarted value) backupStarted,
    required TResult Function(BreezEvent_BackupSucceeded value) backupSucceeded,
    required TResult Function(BreezEvent_BackupFailed value) backupFailed,
    required TResult Function(BreezEvent_SwapUpdated value) swapUpdated,
  }) {
    return backupStarted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BreezEvent_NewBlock value)? newBlock,
    TResult? Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult? Function(BreezEvent_Synced value)? synced,
    TResult? Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult? Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult? Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult? Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult? Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult? Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult? Function(BreezEvent_SwapUpdated value)? swapUpdated,
  }) {
    return backupStarted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BreezEvent_NewBlock value)? newBlock,
    TResult Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult Function(BreezEvent_Synced value)? synced,
    TResult Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult Function(BreezEvent_SwapUpdated value)? swapUpdated,
    required TResult orElse(),
  }) {
    if (backupStarted != null) {
      return backupStarted(this);
    }
    return orElse();
  }
}

abstract class BreezEvent_BackupStarted implements BreezEvent {
  const factory BreezEvent_BackupStarted() = _$BreezEvent_BackupStartedImpl;
}

/// @nodoc
abstract class _$$BreezEvent_BackupSucceededImplCopyWith<$Res> {
  factory _$$BreezEvent_BackupSucceededImplCopyWith(
          _$BreezEvent_BackupSucceededImpl value, $Res Function(_$BreezEvent_BackupSucceededImpl) then) =
      __$$BreezEvent_BackupSucceededImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BreezEvent_BackupSucceededImplCopyWithImpl<$Res>
    extends _$BreezEventCopyWithImpl<$Res, _$BreezEvent_BackupSucceededImpl>
    implements _$$BreezEvent_BackupSucceededImplCopyWith<$Res> {
  __$$BreezEvent_BackupSucceededImplCopyWithImpl(
      _$BreezEvent_BackupSucceededImpl _value, $Res Function(_$BreezEvent_BackupSucceededImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$BreezEvent_BackupSucceededImpl implements BreezEvent_BackupSucceeded {
  const _$BreezEvent_BackupSucceededImpl();

  @override
  String toString() {
    return 'BreezEvent.backupSucceeded()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BreezEvent_BackupSucceededImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int block) newBlock,
    required TResult Function(InvoicePaidDetails details) invoicePaid,
    required TResult Function() synced,
    required TResult Function(Payment details) paymentStarted,
    required TResult Function(Payment details) paymentSucceed,
    required TResult Function(PaymentFailedData details) paymentFailed,
    required TResult Function() backupStarted,
    required TResult Function() backupSucceeded,
    required TResult Function(BackupFailedData details) backupFailed,
    required TResult Function(SwapInfo details) swapUpdated,
  }) {
    return backupSucceeded();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int block)? newBlock,
    TResult? Function(InvoicePaidDetails details)? invoicePaid,
    TResult? Function()? synced,
    TResult? Function(Payment details)? paymentStarted,
    TResult? Function(Payment details)? paymentSucceed,
    TResult? Function(PaymentFailedData details)? paymentFailed,
    TResult? Function()? backupStarted,
    TResult? Function()? backupSucceeded,
    TResult? Function(BackupFailedData details)? backupFailed,
    TResult? Function(SwapInfo details)? swapUpdated,
  }) {
    return backupSucceeded?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int block)? newBlock,
    TResult Function(InvoicePaidDetails details)? invoicePaid,
    TResult Function()? synced,
    TResult Function(Payment details)? paymentStarted,
    TResult Function(Payment details)? paymentSucceed,
    TResult Function(PaymentFailedData details)? paymentFailed,
    TResult Function()? backupStarted,
    TResult Function()? backupSucceeded,
    TResult Function(BackupFailedData details)? backupFailed,
    TResult Function(SwapInfo details)? swapUpdated,
    required TResult orElse(),
  }) {
    if (backupSucceeded != null) {
      return backupSucceeded();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BreezEvent_NewBlock value) newBlock,
    required TResult Function(BreezEvent_InvoicePaid value) invoicePaid,
    required TResult Function(BreezEvent_Synced value) synced,
    required TResult Function(BreezEvent_PaymentStarted value) paymentStarted,
    required TResult Function(BreezEvent_PaymentSucceed value) paymentSucceed,
    required TResult Function(BreezEvent_PaymentFailed value) paymentFailed,
    required TResult Function(BreezEvent_BackupStarted value) backupStarted,
    required TResult Function(BreezEvent_BackupSucceeded value) backupSucceeded,
    required TResult Function(BreezEvent_BackupFailed value) backupFailed,
    required TResult Function(BreezEvent_SwapUpdated value) swapUpdated,
  }) {
    return backupSucceeded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BreezEvent_NewBlock value)? newBlock,
    TResult? Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult? Function(BreezEvent_Synced value)? synced,
    TResult? Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult? Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult? Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult? Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult? Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult? Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult? Function(BreezEvent_SwapUpdated value)? swapUpdated,
  }) {
    return backupSucceeded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BreezEvent_NewBlock value)? newBlock,
    TResult Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult Function(BreezEvent_Synced value)? synced,
    TResult Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult Function(BreezEvent_SwapUpdated value)? swapUpdated,
    required TResult orElse(),
  }) {
    if (backupSucceeded != null) {
      return backupSucceeded(this);
    }
    return orElse();
  }
}

abstract class BreezEvent_BackupSucceeded implements BreezEvent {
  const factory BreezEvent_BackupSucceeded() = _$BreezEvent_BackupSucceededImpl;
}

/// @nodoc
abstract class _$$BreezEvent_BackupFailedImplCopyWith<$Res> {
  factory _$$BreezEvent_BackupFailedImplCopyWith(
          _$BreezEvent_BackupFailedImpl value, $Res Function(_$BreezEvent_BackupFailedImpl) then) =
      __$$BreezEvent_BackupFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BackupFailedData details});
}

/// @nodoc
class __$$BreezEvent_BackupFailedImplCopyWithImpl<$Res>
    extends _$BreezEventCopyWithImpl<$Res, _$BreezEvent_BackupFailedImpl>
    implements _$$BreezEvent_BackupFailedImplCopyWith<$Res> {
  __$$BreezEvent_BackupFailedImplCopyWithImpl(
      _$BreezEvent_BackupFailedImpl _value, $Res Function(_$BreezEvent_BackupFailedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? details = null,
  }) {
    return _then(_$BreezEvent_BackupFailedImpl(
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as BackupFailedData,
    ));
  }
}

/// @nodoc

class _$BreezEvent_BackupFailedImpl implements BreezEvent_BackupFailed {
  const _$BreezEvent_BackupFailedImpl({required this.details});

  @override
  final BackupFailedData details;

  @override
  String toString() {
    return 'BreezEvent.backupFailed(details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreezEvent_BackupFailedImpl &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreezEvent_BackupFailedImplCopyWith<_$BreezEvent_BackupFailedImpl> get copyWith =>
      __$$BreezEvent_BackupFailedImplCopyWithImpl<_$BreezEvent_BackupFailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int block) newBlock,
    required TResult Function(InvoicePaidDetails details) invoicePaid,
    required TResult Function() synced,
    required TResult Function(Payment details) paymentStarted,
    required TResult Function(Payment details) paymentSucceed,
    required TResult Function(PaymentFailedData details) paymentFailed,
    required TResult Function() backupStarted,
    required TResult Function() backupSucceeded,
    required TResult Function(BackupFailedData details) backupFailed,
    required TResult Function(SwapInfo details) swapUpdated,
  }) {
    return backupFailed(details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int block)? newBlock,
    TResult? Function(InvoicePaidDetails details)? invoicePaid,
    TResult? Function()? synced,
    TResult? Function(Payment details)? paymentStarted,
    TResult? Function(Payment details)? paymentSucceed,
    TResult? Function(PaymentFailedData details)? paymentFailed,
    TResult? Function()? backupStarted,
    TResult? Function()? backupSucceeded,
    TResult? Function(BackupFailedData details)? backupFailed,
    TResult? Function(SwapInfo details)? swapUpdated,
  }) {
    return backupFailed?.call(details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int block)? newBlock,
    TResult Function(InvoicePaidDetails details)? invoicePaid,
    TResult Function()? synced,
    TResult Function(Payment details)? paymentStarted,
    TResult Function(Payment details)? paymentSucceed,
    TResult Function(PaymentFailedData details)? paymentFailed,
    TResult Function()? backupStarted,
    TResult Function()? backupSucceeded,
    TResult Function(BackupFailedData details)? backupFailed,
    TResult Function(SwapInfo details)? swapUpdated,
    required TResult orElse(),
  }) {
    if (backupFailed != null) {
      return backupFailed(details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BreezEvent_NewBlock value) newBlock,
    required TResult Function(BreezEvent_InvoicePaid value) invoicePaid,
    required TResult Function(BreezEvent_Synced value) synced,
    required TResult Function(BreezEvent_PaymentStarted value) paymentStarted,
    required TResult Function(BreezEvent_PaymentSucceed value) paymentSucceed,
    required TResult Function(BreezEvent_PaymentFailed value) paymentFailed,
    required TResult Function(BreezEvent_BackupStarted value) backupStarted,
    required TResult Function(BreezEvent_BackupSucceeded value) backupSucceeded,
    required TResult Function(BreezEvent_BackupFailed value) backupFailed,
    required TResult Function(BreezEvent_SwapUpdated value) swapUpdated,
  }) {
    return backupFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BreezEvent_NewBlock value)? newBlock,
    TResult? Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult? Function(BreezEvent_Synced value)? synced,
    TResult? Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult? Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult? Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult? Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult? Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult? Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult? Function(BreezEvent_SwapUpdated value)? swapUpdated,
  }) {
    return backupFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BreezEvent_NewBlock value)? newBlock,
    TResult Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult Function(BreezEvent_Synced value)? synced,
    TResult Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult Function(BreezEvent_SwapUpdated value)? swapUpdated,
    required TResult orElse(),
  }) {
    if (backupFailed != null) {
      return backupFailed(this);
    }
    return orElse();
  }
}

abstract class BreezEvent_BackupFailed implements BreezEvent {
  const factory BreezEvent_BackupFailed({required final BackupFailedData details}) =
      _$BreezEvent_BackupFailedImpl;

  BackupFailedData get details;
  @JsonKey(ignore: true)
  _$$BreezEvent_BackupFailedImplCopyWith<_$BreezEvent_BackupFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BreezEvent_SwapUpdatedImplCopyWith<$Res> {
  factory _$$BreezEvent_SwapUpdatedImplCopyWith(
          _$BreezEvent_SwapUpdatedImpl value, $Res Function(_$BreezEvent_SwapUpdatedImpl) then) =
      __$$BreezEvent_SwapUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SwapInfo details});
}

/// @nodoc
class __$$BreezEvent_SwapUpdatedImplCopyWithImpl<$Res>
    extends _$BreezEventCopyWithImpl<$Res, _$BreezEvent_SwapUpdatedImpl>
    implements _$$BreezEvent_SwapUpdatedImplCopyWith<$Res> {
  __$$BreezEvent_SwapUpdatedImplCopyWithImpl(
      _$BreezEvent_SwapUpdatedImpl _value, $Res Function(_$BreezEvent_SwapUpdatedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? details = null,
  }) {
    return _then(_$BreezEvent_SwapUpdatedImpl(
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as SwapInfo,
    ));
  }
}

/// @nodoc

class _$BreezEvent_SwapUpdatedImpl implements BreezEvent_SwapUpdated {
  const _$BreezEvent_SwapUpdatedImpl({required this.details});

  @override
  final SwapInfo details;

  @override
  String toString() {
    return 'BreezEvent.swapUpdated(details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreezEvent_SwapUpdatedImpl &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreezEvent_SwapUpdatedImplCopyWith<_$BreezEvent_SwapUpdatedImpl> get copyWith =>
      __$$BreezEvent_SwapUpdatedImplCopyWithImpl<_$BreezEvent_SwapUpdatedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int block) newBlock,
    required TResult Function(InvoicePaidDetails details) invoicePaid,
    required TResult Function() synced,
    required TResult Function(Payment details) paymentStarted,
    required TResult Function(Payment details) paymentSucceed,
    required TResult Function(PaymentFailedData details) paymentFailed,
    required TResult Function() backupStarted,
    required TResult Function() backupSucceeded,
    required TResult Function(BackupFailedData details) backupFailed,
    required TResult Function(SwapInfo details) swapUpdated,
  }) {
    return swapUpdated(details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int block)? newBlock,
    TResult? Function(InvoicePaidDetails details)? invoicePaid,
    TResult? Function()? synced,
    TResult? Function(Payment details)? paymentStarted,
    TResult? Function(Payment details)? paymentSucceed,
    TResult? Function(PaymentFailedData details)? paymentFailed,
    TResult? Function()? backupStarted,
    TResult? Function()? backupSucceeded,
    TResult? Function(BackupFailedData details)? backupFailed,
    TResult? Function(SwapInfo details)? swapUpdated,
  }) {
    return swapUpdated?.call(details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int block)? newBlock,
    TResult Function(InvoicePaidDetails details)? invoicePaid,
    TResult Function()? synced,
    TResult Function(Payment details)? paymentStarted,
    TResult Function(Payment details)? paymentSucceed,
    TResult Function(PaymentFailedData details)? paymentFailed,
    TResult Function()? backupStarted,
    TResult Function()? backupSucceeded,
    TResult Function(BackupFailedData details)? backupFailed,
    TResult Function(SwapInfo details)? swapUpdated,
    required TResult orElse(),
  }) {
    if (swapUpdated != null) {
      return swapUpdated(details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BreezEvent_NewBlock value) newBlock,
    required TResult Function(BreezEvent_InvoicePaid value) invoicePaid,
    required TResult Function(BreezEvent_Synced value) synced,
    required TResult Function(BreezEvent_PaymentStarted value) paymentStarted,
    required TResult Function(BreezEvent_PaymentSucceed value) paymentSucceed,
    required TResult Function(BreezEvent_PaymentFailed value) paymentFailed,
    required TResult Function(BreezEvent_BackupStarted value) backupStarted,
    required TResult Function(BreezEvent_BackupSucceeded value) backupSucceeded,
    required TResult Function(BreezEvent_BackupFailed value) backupFailed,
    required TResult Function(BreezEvent_SwapUpdated value) swapUpdated,
  }) {
    return swapUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BreezEvent_NewBlock value)? newBlock,
    TResult? Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult? Function(BreezEvent_Synced value)? synced,
    TResult? Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult? Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult? Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult? Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult? Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult? Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult? Function(BreezEvent_SwapUpdated value)? swapUpdated,
  }) {
    return swapUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BreezEvent_NewBlock value)? newBlock,
    TResult Function(BreezEvent_InvoicePaid value)? invoicePaid,
    TResult Function(BreezEvent_Synced value)? synced,
    TResult Function(BreezEvent_PaymentStarted value)? paymentStarted,
    TResult Function(BreezEvent_PaymentSucceed value)? paymentSucceed,
    TResult Function(BreezEvent_PaymentFailed value)? paymentFailed,
    TResult Function(BreezEvent_BackupStarted value)? backupStarted,
    TResult Function(BreezEvent_BackupSucceeded value)? backupSucceeded,
    TResult Function(BreezEvent_BackupFailed value)? backupFailed,
    TResult Function(BreezEvent_SwapUpdated value)? swapUpdated,
    required TResult orElse(),
  }) {
    if (swapUpdated != null) {
      return swapUpdated(this);
    }
    return orElse();
  }
}

abstract class BreezEvent_SwapUpdated implements BreezEvent {
  const factory BreezEvent_SwapUpdated({required final SwapInfo details}) = _$BreezEvent_SwapUpdatedImpl;

  SwapInfo get details;
  @JsonKey(ignore: true)
  _$$BreezEvent_SwapUpdatedImplCopyWith<_$BreezEvent_SwapUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InputType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
    required TResult Function(InputType_LnUrlError value) lnUrlError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InputTypeCopyWith<$Res> {
  factory $InputTypeCopyWith(InputType value, $Res Function(InputType) then) =
      _$InputTypeCopyWithImpl<$Res, InputType>;
}

/// @nodoc
class _$InputTypeCopyWithImpl<$Res, $Val extends InputType> implements $InputTypeCopyWith<$Res> {
  _$InputTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InputType_BitcoinAddressImplCopyWith<$Res> {
  factory _$$InputType_BitcoinAddressImplCopyWith(
          _$InputType_BitcoinAddressImpl value, $Res Function(_$InputType_BitcoinAddressImpl) then) =
      __$$InputType_BitcoinAddressImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BitcoinAddressData address});
}

/// @nodoc
class __$$InputType_BitcoinAddressImplCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res, _$InputType_BitcoinAddressImpl>
    implements _$$InputType_BitcoinAddressImplCopyWith<$Res> {
  __$$InputType_BitcoinAddressImplCopyWithImpl(
      _$InputType_BitcoinAddressImpl _value, $Res Function(_$InputType_BitcoinAddressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
  }) {
    return _then(_$InputType_BitcoinAddressImpl(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as BitcoinAddressData,
    ));
  }
}

/// @nodoc

class _$InputType_BitcoinAddressImpl implements InputType_BitcoinAddress {
  const _$InputType_BitcoinAddressImpl({required this.address});

  @override
  final BitcoinAddressData address;

  @override
  String toString() {
    return 'InputType.bitcoinAddress(address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_BitcoinAddressImpl &&
            (identical(other.address, address) || other.address == address));
  }

  @override
  int get hashCode => Object.hash(runtimeType, address);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_BitcoinAddressImplCopyWith<_$InputType_BitcoinAddressImpl> get copyWith =>
      __$$InputType_BitcoinAddressImplCopyWithImpl<_$InputType_BitcoinAddressImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return bitcoinAddress(address);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return bitcoinAddress?.call(address);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (bitcoinAddress != null) {
      return bitcoinAddress(address);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
    required TResult Function(InputType_LnUrlError value) lnUrlError,
  }) {
    return bitcoinAddress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
  }) {
    return bitcoinAddress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (bitcoinAddress != null) {
      return bitcoinAddress(this);
    }
    return orElse();
  }
}

abstract class InputType_BitcoinAddress implements InputType {
  const factory InputType_BitcoinAddress({required final BitcoinAddressData address}) =
      _$InputType_BitcoinAddressImpl;

  BitcoinAddressData get address;
  @JsonKey(ignore: true)
  _$$InputType_BitcoinAddressImplCopyWith<_$InputType_BitcoinAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_Bolt11ImplCopyWith<$Res> {
  factory _$$InputType_Bolt11ImplCopyWith(
          _$InputType_Bolt11Impl value, $Res Function(_$InputType_Bolt11Impl) then) =
      __$$InputType_Bolt11ImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LNInvoice invoice});
}

/// @nodoc
class __$$InputType_Bolt11ImplCopyWithImpl<$Res> extends _$InputTypeCopyWithImpl<$Res, _$InputType_Bolt11Impl>
    implements _$$InputType_Bolt11ImplCopyWith<$Res> {
  __$$InputType_Bolt11ImplCopyWithImpl(
      _$InputType_Bolt11Impl _value, $Res Function(_$InputType_Bolt11Impl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invoice = null,
  }) {
    return _then(_$InputType_Bolt11Impl(
      invoice: null == invoice
          ? _value.invoice
          : invoice // ignore: cast_nullable_to_non_nullable
              as LNInvoice,
    ));
  }
}

/// @nodoc

class _$InputType_Bolt11Impl implements InputType_Bolt11 {
  const _$InputType_Bolt11Impl({required this.invoice});

  @override
  final LNInvoice invoice;

  @override
  String toString() {
    return 'InputType.bolt11(invoice: $invoice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_Bolt11Impl &&
            (identical(other.invoice, invoice) || other.invoice == invoice));
  }

  @override
  int get hashCode => Object.hash(runtimeType, invoice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_Bolt11ImplCopyWith<_$InputType_Bolt11Impl> get copyWith =>
      __$$InputType_Bolt11ImplCopyWithImpl<_$InputType_Bolt11Impl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return bolt11(invoice);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return bolt11?.call(invoice);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (bolt11 != null) {
      return bolt11(invoice);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
    required TResult Function(InputType_LnUrlError value) lnUrlError,
  }) {
    return bolt11(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
  }) {
    return bolt11?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (bolt11 != null) {
      return bolt11(this);
    }
    return orElse();
  }
}

abstract class InputType_Bolt11 implements InputType {
  const factory InputType_Bolt11({required final LNInvoice invoice}) = _$InputType_Bolt11Impl;

  LNInvoice get invoice;
  @JsonKey(ignore: true)
  _$$InputType_Bolt11ImplCopyWith<_$InputType_Bolt11Impl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_NodeIdImplCopyWith<$Res> {
  factory _$$InputType_NodeIdImplCopyWith(
          _$InputType_NodeIdImpl value, $Res Function(_$InputType_NodeIdImpl) then) =
      __$$InputType_NodeIdImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String nodeId});
}

/// @nodoc
class __$$InputType_NodeIdImplCopyWithImpl<$Res> extends _$InputTypeCopyWithImpl<$Res, _$InputType_NodeIdImpl>
    implements _$$InputType_NodeIdImplCopyWith<$Res> {
  __$$InputType_NodeIdImplCopyWithImpl(
      _$InputType_NodeIdImpl _value, $Res Function(_$InputType_NodeIdImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodeId = null,
  }) {
    return _then(_$InputType_NodeIdImpl(
      nodeId: null == nodeId
          ? _value.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InputType_NodeIdImpl implements InputType_NodeId {
  const _$InputType_NodeIdImpl({required this.nodeId});

  @override
  final String nodeId;

  @override
  String toString() {
    return 'InputType.nodeId(nodeId: $nodeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_NodeIdImpl &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, nodeId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_NodeIdImplCopyWith<_$InputType_NodeIdImpl> get copyWith =>
      __$$InputType_NodeIdImplCopyWithImpl<_$InputType_NodeIdImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return nodeId(this.nodeId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return nodeId?.call(this.nodeId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (nodeId != null) {
      return nodeId(this.nodeId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
    required TResult Function(InputType_LnUrlError value) lnUrlError,
  }) {
    return nodeId(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
  }) {
    return nodeId?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (nodeId != null) {
      return nodeId(this);
    }
    return orElse();
  }
}

abstract class InputType_NodeId implements InputType {
  const factory InputType_NodeId({required final String nodeId}) = _$InputType_NodeIdImpl;

  String get nodeId;
  @JsonKey(ignore: true)
  _$$InputType_NodeIdImplCopyWith<_$InputType_NodeIdImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_UrlImplCopyWith<$Res> {
  factory _$$InputType_UrlImplCopyWith(_$InputType_UrlImpl value, $Res Function(_$InputType_UrlImpl) then) =
      __$$InputType_UrlImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String url});
}

/// @nodoc
class __$$InputType_UrlImplCopyWithImpl<$Res> extends _$InputTypeCopyWithImpl<$Res, _$InputType_UrlImpl>
    implements _$$InputType_UrlImplCopyWith<$Res> {
  __$$InputType_UrlImplCopyWithImpl(_$InputType_UrlImpl _value, $Res Function(_$InputType_UrlImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
  }) {
    return _then(_$InputType_UrlImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InputType_UrlImpl implements InputType_Url {
  const _$InputType_UrlImpl({required this.url});

  @override
  final String url;

  @override
  String toString() {
    return 'InputType.url(url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_UrlImpl &&
            (identical(other.url, url) || other.url == url));
  }

  @override
  int get hashCode => Object.hash(runtimeType, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_UrlImplCopyWith<_$InputType_UrlImpl> get copyWith =>
      __$$InputType_UrlImplCopyWithImpl<_$InputType_UrlImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return url(this.url);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return url?.call(this.url);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (url != null) {
      return url(this.url);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
    required TResult Function(InputType_LnUrlError value) lnUrlError,
  }) {
    return url(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
  }) {
    return url?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (url != null) {
      return url(this);
    }
    return orElse();
  }
}

abstract class InputType_Url implements InputType {
  const factory InputType_Url({required final String url}) = _$InputType_UrlImpl;

  String get url;
  @JsonKey(ignore: true)
  _$$InputType_UrlImplCopyWith<_$InputType_UrlImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_LnUrlPayImplCopyWith<$Res> {
  factory _$$InputType_LnUrlPayImplCopyWith(
          _$InputType_LnUrlPayImpl value, $Res Function(_$InputType_LnUrlPayImpl) then) =
      __$$InputType_LnUrlPayImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlPayRequestData data});
}

/// @nodoc
class __$$InputType_LnUrlPayImplCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res, _$InputType_LnUrlPayImpl>
    implements _$$InputType_LnUrlPayImplCopyWith<$Res> {
  __$$InputType_LnUrlPayImplCopyWithImpl(
      _$InputType_LnUrlPayImpl _value, $Res Function(_$InputType_LnUrlPayImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$InputType_LnUrlPayImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LnUrlPayRequestData,
    ));
  }
}

/// @nodoc

class _$InputType_LnUrlPayImpl implements InputType_LnUrlPay {
  const _$InputType_LnUrlPayImpl({required this.data});

  @override
  final LnUrlPayRequestData data;

  @override
  String toString() {
    return 'InputType.lnUrlPay(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_LnUrlPayImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_LnUrlPayImplCopyWith<_$InputType_LnUrlPayImpl> get copyWith =>
      __$$InputType_LnUrlPayImplCopyWithImpl<_$InputType_LnUrlPayImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return lnUrlPay(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return lnUrlPay?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlPay != null) {
      return lnUrlPay(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
    required TResult Function(InputType_LnUrlError value) lnUrlError,
  }) {
    return lnUrlPay(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
  }) {
    return lnUrlPay?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlPay != null) {
      return lnUrlPay(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrlPay implements InputType {
  const factory InputType_LnUrlPay({required final LnUrlPayRequestData data}) = _$InputType_LnUrlPayImpl;

  LnUrlPayRequestData get data;
  @JsonKey(ignore: true)
  _$$InputType_LnUrlPayImplCopyWith<_$InputType_LnUrlPayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_LnUrlWithdrawImplCopyWith<$Res> {
  factory _$$InputType_LnUrlWithdrawImplCopyWith(
          _$InputType_LnUrlWithdrawImpl value, $Res Function(_$InputType_LnUrlWithdrawImpl) then) =
      __$$InputType_LnUrlWithdrawImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlWithdrawRequestData data});
}

/// @nodoc
class __$$InputType_LnUrlWithdrawImplCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res, _$InputType_LnUrlWithdrawImpl>
    implements _$$InputType_LnUrlWithdrawImplCopyWith<$Res> {
  __$$InputType_LnUrlWithdrawImplCopyWithImpl(
      _$InputType_LnUrlWithdrawImpl _value, $Res Function(_$InputType_LnUrlWithdrawImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$InputType_LnUrlWithdrawImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LnUrlWithdrawRequestData,
    ));
  }
}

/// @nodoc

class _$InputType_LnUrlWithdrawImpl implements InputType_LnUrlWithdraw {
  const _$InputType_LnUrlWithdrawImpl({required this.data});

  @override
  final LnUrlWithdrawRequestData data;

  @override
  String toString() {
    return 'InputType.lnUrlWithdraw(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_LnUrlWithdrawImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_LnUrlWithdrawImplCopyWith<_$InputType_LnUrlWithdrawImpl> get copyWith =>
      __$$InputType_LnUrlWithdrawImplCopyWithImpl<_$InputType_LnUrlWithdrawImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return lnUrlWithdraw(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return lnUrlWithdraw?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlWithdraw != null) {
      return lnUrlWithdraw(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
    required TResult Function(InputType_LnUrlError value) lnUrlError,
  }) {
    return lnUrlWithdraw(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
  }) {
    return lnUrlWithdraw?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlWithdraw != null) {
      return lnUrlWithdraw(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrlWithdraw implements InputType {
  const factory InputType_LnUrlWithdraw({required final LnUrlWithdrawRequestData data}) =
      _$InputType_LnUrlWithdrawImpl;

  LnUrlWithdrawRequestData get data;
  @JsonKey(ignore: true)
  _$$InputType_LnUrlWithdrawImplCopyWith<_$InputType_LnUrlWithdrawImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_LnUrlAuthImplCopyWith<$Res> {
  factory _$$InputType_LnUrlAuthImplCopyWith(
          _$InputType_LnUrlAuthImpl value, $Res Function(_$InputType_LnUrlAuthImpl) then) =
      __$$InputType_LnUrlAuthImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlAuthRequestData data});
}

/// @nodoc
class __$$InputType_LnUrlAuthImplCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res, _$InputType_LnUrlAuthImpl>
    implements _$$InputType_LnUrlAuthImplCopyWith<$Res> {
  __$$InputType_LnUrlAuthImplCopyWithImpl(
      _$InputType_LnUrlAuthImpl _value, $Res Function(_$InputType_LnUrlAuthImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$InputType_LnUrlAuthImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LnUrlAuthRequestData,
    ));
  }
}

/// @nodoc

class _$InputType_LnUrlAuthImpl implements InputType_LnUrlAuth {
  const _$InputType_LnUrlAuthImpl({required this.data});

  @override
  final LnUrlAuthRequestData data;

  @override
  String toString() {
    return 'InputType.lnUrlAuth(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_LnUrlAuthImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_LnUrlAuthImplCopyWith<_$InputType_LnUrlAuthImpl> get copyWith =>
      __$$InputType_LnUrlAuthImplCopyWithImpl<_$InputType_LnUrlAuthImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return lnUrlAuth(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return lnUrlAuth?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlAuth != null) {
      return lnUrlAuth(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
    required TResult Function(InputType_LnUrlError value) lnUrlError,
  }) {
    return lnUrlAuth(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
  }) {
    return lnUrlAuth?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlAuth != null) {
      return lnUrlAuth(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrlAuth implements InputType {
  const factory InputType_LnUrlAuth({required final LnUrlAuthRequestData data}) = _$InputType_LnUrlAuthImpl;

  LnUrlAuthRequestData get data;
  @JsonKey(ignore: true)
  _$$InputType_LnUrlAuthImplCopyWith<_$InputType_LnUrlAuthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_LnUrlErrorImplCopyWith<$Res> {
  factory _$$InputType_LnUrlErrorImplCopyWith(
          _$InputType_LnUrlErrorImpl value, $Res Function(_$InputType_LnUrlErrorImpl) then) =
      __$$InputType_LnUrlErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlErrorData data});
}

/// @nodoc
class __$$InputType_LnUrlErrorImplCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res, _$InputType_LnUrlErrorImpl>
    implements _$$InputType_LnUrlErrorImplCopyWith<$Res> {
  __$$InputType_LnUrlErrorImplCopyWithImpl(
      _$InputType_LnUrlErrorImpl _value, $Res Function(_$InputType_LnUrlErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$InputType_LnUrlErrorImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LnUrlErrorData,
    ));
  }
}

/// @nodoc

class _$InputType_LnUrlErrorImpl implements InputType_LnUrlError {
  const _$InputType_LnUrlErrorImpl({required this.data});

  @override
  final LnUrlErrorData data;

  @override
  String toString() {
    return 'InputType.lnUrlError(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_LnUrlErrorImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_LnUrlErrorImplCopyWith<_$InputType_LnUrlErrorImpl> get copyWith =>
      __$$InputType_LnUrlErrorImplCopyWithImpl<_$InputType_LnUrlErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return lnUrlError(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return lnUrlError?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlError != null) {
      return lnUrlError(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
    required TResult Function(InputType_LnUrlError value) lnUrlError,
  }) {
    return lnUrlError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
  }) {
    return lnUrlError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlError != null) {
      return lnUrlError(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrlError implements InputType {
  const factory InputType_LnUrlError({required final LnUrlErrorData data}) = _$InputType_LnUrlErrorImpl;

  LnUrlErrorData get data;
  @JsonKey(ignore: true)
  _$$InputType_LnUrlErrorImplCopyWith<_$InputType_LnUrlErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

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

class _$LnUrlCallbackStatus_OkImpl implements LnUrlCallbackStatus_Ok {
  const _$LnUrlCallbackStatus_OkImpl();

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

abstract class LnUrlCallbackStatus_Ok implements LnUrlCallbackStatus {
  const factory LnUrlCallbackStatus_Ok() = _$LnUrlCallbackStatus_OkImpl;
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

class _$LnUrlCallbackStatus_ErrorStatusImpl implements LnUrlCallbackStatus_ErrorStatus {
  const _$LnUrlCallbackStatus_ErrorStatusImpl({required this.data});

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

abstract class LnUrlCallbackStatus_ErrorStatus implements LnUrlCallbackStatus {
  const factory LnUrlCallbackStatus_ErrorStatus({required final LnUrlErrorData data}) =
      _$LnUrlCallbackStatus_ErrorStatusImpl;

  LnUrlErrorData get data;
  @JsonKey(ignore: true)
  _$$LnUrlCallbackStatus_ErrorStatusImplCopyWith<_$LnUrlCallbackStatus_ErrorStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
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

class _$LnUrlPayResult_EndpointSuccessImpl implements LnUrlPayResult_EndpointSuccess {
  const _$LnUrlPayResult_EndpointSuccessImpl({required this.data});

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

abstract class LnUrlPayResult_EndpointSuccess implements LnUrlPayResult {
  const factory LnUrlPayResult_EndpointSuccess({required final LnUrlPaySuccessData data}) =
      _$LnUrlPayResult_EndpointSuccessImpl;

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

class _$LnUrlPayResult_EndpointErrorImpl implements LnUrlPayResult_EndpointError {
  const _$LnUrlPayResult_EndpointErrorImpl({required this.data});

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

abstract class LnUrlPayResult_EndpointError implements LnUrlPayResult {
  const factory LnUrlPayResult_EndpointError({required final LnUrlErrorData data}) =
      _$LnUrlPayResult_EndpointErrorImpl;

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

class _$LnUrlPayResult_PayErrorImpl implements LnUrlPayResult_PayError {
  const _$LnUrlPayResult_PayErrorImpl({required this.data});

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

abstract class LnUrlPayResult_PayError implements LnUrlPayResult {
  const factory LnUrlPayResult_PayError({required final LnUrlPayErrorData data}) =
      _$LnUrlPayResult_PayErrorImpl;

  @override
  LnUrlPayErrorData get data;
  @JsonKey(ignore: true)
  _$$LnUrlPayResult_PayErrorImplCopyWith<_$LnUrlPayResult_PayErrorImpl> get copyWith =>
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

class _$LnUrlWithdrawResult_OkImpl implements LnUrlWithdrawResult_Ok {
  const _$LnUrlWithdrawResult_OkImpl({required this.data});

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

abstract class LnUrlWithdrawResult_Ok implements LnUrlWithdrawResult {
  const factory LnUrlWithdrawResult_Ok({required final LnUrlWithdrawSuccessData data}) =
      _$LnUrlWithdrawResult_OkImpl;

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

class _$LnUrlWithdrawResult_ErrorStatusImpl implements LnUrlWithdrawResult_ErrorStatus {
  const _$LnUrlWithdrawResult_ErrorStatusImpl({required this.data});

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

abstract class LnUrlWithdrawResult_ErrorStatus implements LnUrlWithdrawResult {
  const factory LnUrlWithdrawResult_ErrorStatus({required final LnUrlErrorData data}) =
      _$LnUrlWithdrawResult_ErrorStatusImpl;

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

class _$NodeConfig_GreenlightImpl implements NodeConfig_Greenlight {
  const _$NodeConfig_GreenlightImpl({required this.config});

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

abstract class NodeConfig_Greenlight implements NodeConfig {
  const factory NodeConfig_Greenlight({required final GreenlightNodeConfig config}) =
      _$NodeConfig_GreenlightImpl;

  @override
  GreenlightNodeConfig get config;
  @override
  @JsonKey(ignore: true)
  _$$NodeConfig_GreenlightImplCopyWith<_$NodeConfig_GreenlightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NodeCredentials {
  GreenlightDeviceCredentials get credentials => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GreenlightDeviceCredentials credentials) greenlight,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GreenlightDeviceCredentials credentials)? greenlight,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GreenlightDeviceCredentials credentials)? greenlight,
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
  $Res call({GreenlightDeviceCredentials credentials});
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
              as GreenlightDeviceCredentials,
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
  $Res call({GreenlightDeviceCredentials credentials});
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
              as GreenlightDeviceCredentials,
    ));
  }
}

/// @nodoc

class _$NodeCredentials_GreenlightImpl implements NodeCredentials_Greenlight {
  const _$NodeCredentials_GreenlightImpl({required this.credentials});

  @override
  final GreenlightDeviceCredentials credentials;

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
    required TResult Function(GreenlightDeviceCredentials credentials) greenlight,
  }) {
    return greenlight(credentials);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GreenlightDeviceCredentials credentials)? greenlight,
  }) {
    return greenlight?.call(credentials);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GreenlightDeviceCredentials credentials)? greenlight,
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

abstract class NodeCredentials_Greenlight implements NodeCredentials {
  const factory NodeCredentials_Greenlight({required final GreenlightDeviceCredentials credentials}) =
      _$NodeCredentials_GreenlightImpl;

  @override
  GreenlightDeviceCredentials get credentials;
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

class _$PaymentDetails_LnImpl implements PaymentDetails_Ln {
  const _$PaymentDetails_LnImpl({required this.data});

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

abstract class PaymentDetails_Ln implements PaymentDetails {
  const factory PaymentDetails_Ln({required final LnPaymentDetails data}) = _$PaymentDetails_LnImpl;

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

class _$PaymentDetails_ClosedChannelImpl implements PaymentDetails_ClosedChannel {
  const _$PaymentDetails_ClosedChannelImpl({required this.data});

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

abstract class PaymentDetails_ClosedChannel implements PaymentDetails {
  const factory PaymentDetails_ClosedChannel({required final ClosedChannelPaymentDetails data}) =
      _$PaymentDetails_ClosedChannelImpl;

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

class _$ReportIssueRequest_PaymentFailureImpl implements ReportIssueRequest_PaymentFailure {
  const _$ReportIssueRequest_PaymentFailureImpl({required this.data});

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

abstract class ReportIssueRequest_PaymentFailure implements ReportIssueRequest {
  const factory ReportIssueRequest_PaymentFailure({required final ReportPaymentFailureDetails data}) =
      _$ReportIssueRequest_PaymentFailureImpl;

  @override
  ReportPaymentFailureDetails get data;
  @override
  @JsonKey(ignore: true)
  _$$ReportIssueRequest_PaymentFailureImplCopyWith<_$ReportIssueRequest_PaymentFailureImpl> get copyWith =>
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

class _$SuccessActionProcessed_AesImpl implements SuccessActionProcessed_Aes {
  const _$SuccessActionProcessed_AesImpl({required this.result});

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

abstract class SuccessActionProcessed_Aes implements SuccessActionProcessed {
  const factory SuccessActionProcessed_Aes({required final AesSuccessActionDataResult result}) =
      _$SuccessActionProcessed_AesImpl;

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

class _$SuccessActionProcessed_MessageImpl implements SuccessActionProcessed_Message {
  const _$SuccessActionProcessed_MessageImpl({required this.data});

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

abstract class SuccessActionProcessed_Message implements SuccessActionProcessed {
  const factory SuccessActionProcessed_Message({required final MessageSuccessActionData data}) =
      _$SuccessActionProcessed_MessageImpl;

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

class _$SuccessActionProcessed_UrlImpl implements SuccessActionProcessed_Url {
  const _$SuccessActionProcessed_UrlImpl({required this.data});

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

abstract class SuccessActionProcessed_Url implements SuccessActionProcessed {
  const factory SuccessActionProcessed_Url({required final UrlSuccessActionData data}) =
      _$SuccessActionProcessed_UrlImpl;

  UrlSuccessActionData get data;
  @JsonKey(ignore: true)
  _$$SuccessActionProcessed_UrlImplCopyWith<_$SuccessActionProcessed_UrlImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
