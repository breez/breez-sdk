// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'binding.dart';

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

class _$InputType_BitcoinAddressImpl extends InputType_BitcoinAddress {
  const _$InputType_BitcoinAddressImpl({required this.address}) : super._();

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

abstract class InputType_BitcoinAddress extends InputType {
  const factory InputType_BitcoinAddress({required final BitcoinAddressData address}) =
      _$InputType_BitcoinAddressImpl;
  const InputType_BitcoinAddress._() : super._();

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

class _$InputType_Bolt11Impl extends InputType_Bolt11 {
  const _$InputType_Bolt11Impl({required this.invoice}) : super._();

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

abstract class InputType_Bolt11 extends InputType {
  const factory InputType_Bolt11({required final LNInvoice invoice}) = _$InputType_Bolt11Impl;
  const InputType_Bolt11._() : super._();

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

class _$InputType_NodeIdImpl extends InputType_NodeId {
  const _$InputType_NodeIdImpl({required this.nodeId}) : super._();

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

abstract class InputType_NodeId extends InputType {
  const factory InputType_NodeId({required final String nodeId}) = _$InputType_NodeIdImpl;
  const InputType_NodeId._() : super._();

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

class _$InputType_UrlImpl extends InputType_Url {
  const _$InputType_UrlImpl({required this.url}) : super._();

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

abstract class InputType_Url extends InputType {
  const factory InputType_Url({required final String url}) = _$InputType_UrlImpl;
  const InputType_Url._() : super._();

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

class _$InputType_LnUrlPayImpl extends InputType_LnUrlPay {
  const _$InputType_LnUrlPayImpl({required this.data}) : super._();

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

abstract class InputType_LnUrlPay extends InputType {
  const factory InputType_LnUrlPay({required final LnUrlPayRequestData data}) = _$InputType_LnUrlPayImpl;
  const InputType_LnUrlPay._() : super._();

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

class _$InputType_LnUrlWithdrawImpl extends InputType_LnUrlWithdraw {
  const _$InputType_LnUrlWithdrawImpl({required this.data}) : super._();

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

abstract class InputType_LnUrlWithdraw extends InputType {
  const factory InputType_LnUrlWithdraw({required final LnUrlWithdrawRequestData data}) =
      _$InputType_LnUrlWithdrawImpl;
  const InputType_LnUrlWithdraw._() : super._();

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

class _$InputType_LnUrlAuthImpl extends InputType_LnUrlAuth {
  const _$InputType_LnUrlAuthImpl({required this.data}) : super._();

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

abstract class InputType_LnUrlAuth extends InputType {
  const factory InputType_LnUrlAuth({required final LnUrlAuthRequestData data}) = _$InputType_LnUrlAuthImpl;
  const InputType_LnUrlAuth._() : super._();

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

class _$InputType_LnUrlErrorImpl extends InputType_LnUrlError {
  const _$InputType_LnUrlErrorImpl({required this.data}) : super._();

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

abstract class InputType_LnUrlError extends InputType {
  const factory InputType_LnUrlError({required final LnUrlErrorData data}) = _$InputType_LnUrlErrorImpl;
  const InputType_LnUrlError._() : super._();

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
