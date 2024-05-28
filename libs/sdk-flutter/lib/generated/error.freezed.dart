// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ConnectError {
  String get err => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String err) generic,
    required TResult Function(String err) restoreOnly,
    required TResult Function(String err) serviceConnectivity,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String err)? generic,
    TResult? Function(String err)? restoreOnly,
    TResult? Function(String err)? serviceConnectivity,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String err)? generic,
    TResult Function(String err)? restoreOnly,
    TResult Function(String err)? serviceConnectivity,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConnectError_Generic value) generic,
    required TResult Function(ConnectError_RestoreOnly value) restoreOnly,
    required TResult Function(ConnectError_ServiceConnectivity value) serviceConnectivity,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConnectError_Generic value)? generic,
    TResult? Function(ConnectError_RestoreOnly value)? restoreOnly,
    TResult? Function(ConnectError_ServiceConnectivity value)? serviceConnectivity,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConnectError_Generic value)? generic,
    TResult Function(ConnectError_RestoreOnly value)? restoreOnly,
    TResult Function(ConnectError_ServiceConnectivity value)? serviceConnectivity,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConnectErrorCopyWith<ConnectError> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectErrorCopyWith<$Res> {
  factory $ConnectErrorCopyWith(ConnectError value, $Res Function(ConnectError) then) =
      _$ConnectErrorCopyWithImpl<$Res, ConnectError>;
  @useResult
  $Res call({String err});
}

/// @nodoc
class _$ConnectErrorCopyWithImpl<$Res, $Val extends ConnectError> implements $ConnectErrorCopyWith<$Res> {
  _$ConnectErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? err = null,
  }) {
    return _then(_value.copyWith(
      err: null == err
          ? _value.err
          : err // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConnectError_GenericImplCopyWith<$Res> implements $ConnectErrorCopyWith<$Res> {
  factory _$$ConnectError_GenericImplCopyWith(
          _$ConnectError_GenericImpl value, $Res Function(_$ConnectError_GenericImpl) then) =
      __$$ConnectError_GenericImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String err});
}

/// @nodoc
class __$$ConnectError_GenericImplCopyWithImpl<$Res>
    extends _$ConnectErrorCopyWithImpl<$Res, _$ConnectError_GenericImpl>
    implements _$$ConnectError_GenericImplCopyWith<$Res> {
  __$$ConnectError_GenericImplCopyWithImpl(
      _$ConnectError_GenericImpl _value, $Res Function(_$ConnectError_GenericImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? err = null,
  }) {
    return _then(_$ConnectError_GenericImpl(
      err: null == err
          ? _value.err
          : err // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ConnectError_GenericImpl extends ConnectError_Generic {
  const _$ConnectError_GenericImpl({required this.err}) : super._();

  @override
  final String err;

  @override
  String toString() {
    return 'ConnectError.generic(err: $err)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectError_GenericImpl &&
            (identical(other.err, err) || other.err == err));
  }

  @override
  int get hashCode => Object.hash(runtimeType, err);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectError_GenericImplCopyWith<_$ConnectError_GenericImpl> get copyWith =>
      __$$ConnectError_GenericImplCopyWithImpl<_$ConnectError_GenericImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String err) generic,
    required TResult Function(String err) restoreOnly,
    required TResult Function(String err) serviceConnectivity,
  }) {
    return generic(err);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String err)? generic,
    TResult? Function(String err)? restoreOnly,
    TResult? Function(String err)? serviceConnectivity,
  }) {
    return generic?.call(err);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String err)? generic,
    TResult Function(String err)? restoreOnly,
    TResult Function(String err)? serviceConnectivity,
    required TResult orElse(),
  }) {
    if (generic != null) {
      return generic(err);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConnectError_Generic value) generic,
    required TResult Function(ConnectError_RestoreOnly value) restoreOnly,
    required TResult Function(ConnectError_ServiceConnectivity value) serviceConnectivity,
  }) {
    return generic(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConnectError_Generic value)? generic,
    TResult? Function(ConnectError_RestoreOnly value)? restoreOnly,
    TResult? Function(ConnectError_ServiceConnectivity value)? serviceConnectivity,
  }) {
    return generic?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConnectError_Generic value)? generic,
    TResult Function(ConnectError_RestoreOnly value)? restoreOnly,
    TResult Function(ConnectError_ServiceConnectivity value)? serviceConnectivity,
    required TResult orElse(),
  }) {
    if (generic != null) {
      return generic(this);
    }
    return orElse();
  }
}

abstract class ConnectError_Generic extends ConnectError {
  const factory ConnectError_Generic({required final String err}) = _$ConnectError_GenericImpl;
  const ConnectError_Generic._() : super._();

  @override
  String get err;
  @override
  @JsonKey(ignore: true)
  _$$ConnectError_GenericImplCopyWith<_$ConnectError_GenericImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConnectError_RestoreOnlyImplCopyWith<$Res> implements $ConnectErrorCopyWith<$Res> {
  factory _$$ConnectError_RestoreOnlyImplCopyWith(
          _$ConnectError_RestoreOnlyImpl value, $Res Function(_$ConnectError_RestoreOnlyImpl) then) =
      __$$ConnectError_RestoreOnlyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String err});
}

/// @nodoc
class __$$ConnectError_RestoreOnlyImplCopyWithImpl<$Res>
    extends _$ConnectErrorCopyWithImpl<$Res, _$ConnectError_RestoreOnlyImpl>
    implements _$$ConnectError_RestoreOnlyImplCopyWith<$Res> {
  __$$ConnectError_RestoreOnlyImplCopyWithImpl(
      _$ConnectError_RestoreOnlyImpl _value, $Res Function(_$ConnectError_RestoreOnlyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? err = null,
  }) {
    return _then(_$ConnectError_RestoreOnlyImpl(
      err: null == err
          ? _value.err
          : err // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ConnectError_RestoreOnlyImpl extends ConnectError_RestoreOnly {
  const _$ConnectError_RestoreOnlyImpl({required this.err}) : super._();

  @override
  final String err;

  @override
  String toString() {
    return 'ConnectError.restoreOnly(err: $err)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectError_RestoreOnlyImpl &&
            (identical(other.err, err) || other.err == err));
  }

  @override
  int get hashCode => Object.hash(runtimeType, err);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectError_RestoreOnlyImplCopyWith<_$ConnectError_RestoreOnlyImpl> get copyWith =>
      __$$ConnectError_RestoreOnlyImplCopyWithImpl<_$ConnectError_RestoreOnlyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String err) generic,
    required TResult Function(String err) restoreOnly,
    required TResult Function(String err) serviceConnectivity,
  }) {
    return restoreOnly(err);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String err)? generic,
    TResult? Function(String err)? restoreOnly,
    TResult? Function(String err)? serviceConnectivity,
  }) {
    return restoreOnly?.call(err);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String err)? generic,
    TResult Function(String err)? restoreOnly,
    TResult Function(String err)? serviceConnectivity,
    required TResult orElse(),
  }) {
    if (restoreOnly != null) {
      return restoreOnly(err);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConnectError_Generic value) generic,
    required TResult Function(ConnectError_RestoreOnly value) restoreOnly,
    required TResult Function(ConnectError_ServiceConnectivity value) serviceConnectivity,
  }) {
    return restoreOnly(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConnectError_Generic value)? generic,
    TResult? Function(ConnectError_RestoreOnly value)? restoreOnly,
    TResult? Function(ConnectError_ServiceConnectivity value)? serviceConnectivity,
  }) {
    return restoreOnly?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConnectError_Generic value)? generic,
    TResult Function(ConnectError_RestoreOnly value)? restoreOnly,
    TResult Function(ConnectError_ServiceConnectivity value)? serviceConnectivity,
    required TResult orElse(),
  }) {
    if (restoreOnly != null) {
      return restoreOnly(this);
    }
    return orElse();
  }
}

abstract class ConnectError_RestoreOnly extends ConnectError {
  const factory ConnectError_RestoreOnly({required final String err}) = _$ConnectError_RestoreOnlyImpl;
  const ConnectError_RestoreOnly._() : super._();

  @override
  String get err;
  @override
  @JsonKey(ignore: true)
  _$$ConnectError_RestoreOnlyImplCopyWith<_$ConnectError_RestoreOnlyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConnectError_ServiceConnectivityImplCopyWith<$Res> implements $ConnectErrorCopyWith<$Res> {
  factory _$$ConnectError_ServiceConnectivityImplCopyWith(_$ConnectError_ServiceConnectivityImpl value,
          $Res Function(_$ConnectError_ServiceConnectivityImpl) then) =
      __$$ConnectError_ServiceConnectivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String err});
}

/// @nodoc
class __$$ConnectError_ServiceConnectivityImplCopyWithImpl<$Res>
    extends _$ConnectErrorCopyWithImpl<$Res, _$ConnectError_ServiceConnectivityImpl>
    implements _$$ConnectError_ServiceConnectivityImplCopyWith<$Res> {
  __$$ConnectError_ServiceConnectivityImplCopyWithImpl(_$ConnectError_ServiceConnectivityImpl _value,
      $Res Function(_$ConnectError_ServiceConnectivityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? err = null,
  }) {
    return _then(_$ConnectError_ServiceConnectivityImpl(
      err: null == err
          ? _value.err
          : err // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ConnectError_ServiceConnectivityImpl extends ConnectError_ServiceConnectivity {
  const _$ConnectError_ServiceConnectivityImpl({required this.err}) : super._();

  @override
  final String err;

  @override
  String toString() {
    return 'ConnectError.serviceConnectivity(err: $err)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectError_ServiceConnectivityImpl &&
            (identical(other.err, err) || other.err == err));
  }

  @override
  int get hashCode => Object.hash(runtimeType, err);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectError_ServiceConnectivityImplCopyWith<_$ConnectError_ServiceConnectivityImpl> get copyWith =>
      __$$ConnectError_ServiceConnectivityImplCopyWithImpl<_$ConnectError_ServiceConnectivityImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String err) generic,
    required TResult Function(String err) restoreOnly,
    required TResult Function(String err) serviceConnectivity,
  }) {
    return serviceConnectivity(err);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String err)? generic,
    TResult? Function(String err)? restoreOnly,
    TResult? Function(String err)? serviceConnectivity,
  }) {
    return serviceConnectivity?.call(err);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String err)? generic,
    TResult Function(String err)? restoreOnly,
    TResult Function(String err)? serviceConnectivity,
    required TResult orElse(),
  }) {
    if (serviceConnectivity != null) {
      return serviceConnectivity(err);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConnectError_Generic value) generic,
    required TResult Function(ConnectError_RestoreOnly value) restoreOnly,
    required TResult Function(ConnectError_ServiceConnectivity value) serviceConnectivity,
  }) {
    return serviceConnectivity(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConnectError_Generic value)? generic,
    TResult? Function(ConnectError_RestoreOnly value)? restoreOnly,
    TResult? Function(ConnectError_ServiceConnectivity value)? serviceConnectivity,
  }) {
    return serviceConnectivity?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConnectError_Generic value)? generic,
    TResult Function(ConnectError_RestoreOnly value)? restoreOnly,
    TResult Function(ConnectError_ServiceConnectivity value)? serviceConnectivity,
    required TResult orElse(),
  }) {
    if (serviceConnectivity != null) {
      return serviceConnectivity(this);
    }
    return orElse();
  }
}

abstract class ConnectError_ServiceConnectivity extends ConnectError {
  const factory ConnectError_ServiceConnectivity({required final String err}) =
      _$ConnectError_ServiceConnectivityImpl;
  const ConnectError_ServiceConnectivity._() : super._();

  @override
  String get err;
  @override
  @JsonKey(ignore: true)
  _$$ConnectError_ServiceConnectivityImplCopyWith<_$ConnectError_ServiceConnectivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
