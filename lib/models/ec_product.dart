import 'package:freezed_annotation/freezed_annotation.dart';

part 'ec_product.freezed.dart';
part 'ec_product.g.dart';

@freezed
class EcProduct with _$EcProduct {
  const factory EcProduct({required int id, required String name, required int price, required String avatar}) =
      _EcProduct;

  factory EcProduct.fromJson(Map<String, dynamic> json) => _$EcProductFromJson(json);
}
