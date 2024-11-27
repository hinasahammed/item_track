// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      productId: json['product_id'] as String?,
      barCode: json['bar_code'] as String?,
      productName: json['product_name'] as String?,
      price: json['price'] as String?,
      shelf: json['shelf'] as String?,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'bar_code': instance.barCode,
      'product_name': instance.productName,
      'price': instance.price,
      'shelf': instance.shelf,
    };
