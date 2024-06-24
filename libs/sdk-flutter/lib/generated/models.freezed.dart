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

class _$NodeCredentials_GreenlightImpl extends NodeCredentials_Greenlight {
  const _$NodeCredentials_GreenlightImpl({required this.credentials}) : super._();

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

abstract class NodeCredentials_Greenlight extends NodeCredentials {
  const factory NodeCredentials_Greenlight({required final GreenlightDeviceCredentials credentials}) =
      _$NodeCredentials_GreenlightImpl;
  const NodeCredentials_Greenlight._() : super._();

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
