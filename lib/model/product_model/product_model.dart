import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
	@JsonKey(name: 'product_id') 
	String? productId;
	@JsonKey(name: 'bar_code') 
	String? barCode;
	@JsonKey(name: 'product_name') 
	String? productName;
	String? price;
	String? shelf;

	ProductModel({
		this.productId, 
		this.barCode, 
		this.productName, 
		this.price, 
		this.shelf, 
	});

	factory ProductModel.fromJson(Map<String, dynamic> json) {
		return _$ProductModelFromJson(json);
	}

	Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
