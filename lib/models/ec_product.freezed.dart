// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ec_product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EcProduct _$EcProductFromJson(Map<String, dynamic> json) {
  return _EcProduct.fromJson(json);
}

/// @nodoc
mixin _$EcProduct {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  String get avatar => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EcProductCopyWith<EcProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EcProductCopyWith<$Res> {
  factory $EcProductCopyWith(EcProduct value, $Res Function(EcProduct) then) =
      _$EcProductCopyWithImpl<$Res, EcProduct>;
  @useResult
  $Res call({int id, String name, int price, String avatar});
}

/// @nodoc
class _$EcProductCopyWithImpl<$Res, $Val extends EcProduct>
    implements $EcProductCopyWith<$Res> {
  _$EcProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? avatar = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EcProductImplCopyWith<$Res>
    implements $EcProductCopyWith<$Res> {
  factory _$$EcProductImplCopyWith(
          _$EcProductImpl value, $Res Function(_$EcProductImpl) then) =
      __$$EcProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, int price, String avatar});
}

/// @nodoc
class __$$EcProductImplCopyWithImpl<$Res>
    extends _$EcProductCopyWithImpl<$Res, _$EcProductImpl>
    implements _$$EcProductImplCopyWith<$Res> {
  __$$EcProductImplCopyWithImpl(
      _$EcProductImpl _value, $Res Function(_$EcProductImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? avatar = null,
  }) {
    return _then(_$EcProductImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EcProductImpl implements _EcProduct {
  const _$EcProductImpl(
      {required this.id,
      required this.name,
      required this.price,
      required this.avatar});

  factory _$EcProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$EcProductImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int price;
  @override
  final String avatar;

  @override
  String toString() {
    return 'EcProduct(id: $id, name: $name, price: $price, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EcProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, price, avatar);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EcProductImplCopyWith<_$EcProductImpl> get copyWith =>
      __$$EcProductImplCopyWithImpl<_$EcProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EcProductImplToJson(
      this,
    );
  }
}

abstract class _EcProduct implements EcProduct {
  const factory _EcProduct(
      {required final int id,
      required final String name,
      required final int price,
      required final String avatar}) = _$EcProductImpl;

  factory _EcProduct.fromJson(Map<String, dynamic> json) =
      _$EcProductImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int get price;
  @override
  String get avatar;
  @override
  @JsonKey(ignore: true)
  _$$EcProductImplCopyWith<_$EcProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
