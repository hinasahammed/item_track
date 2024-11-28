// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductModel {

    ProductModel({
    this.id,
    this.barcode,
    this.productname,
    this.price,
    this.shelf,
    this.quantity,
  });
  
  String? id;
	String? barcode;
	String? productname;
	String? price;
	String? shelf;
	String? quantity;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'barcode': barcode,
      'productname': productname,
      'price': price,
      'shelf': shelf,
      'quantity': quantity,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] != null ? map['id'] as String : null,
      barcode: map['barcode'] != null ? map['barcode'] as String : null,
      productname: map['productname'] != null ? map['productname'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      shelf: map['shelf'] != null ? map['shelf'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
