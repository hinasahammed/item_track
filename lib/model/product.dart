import 'package:hive/hive.dart';
part 'product.g.dart';


@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String barcode;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  double price;

  @HiveField(4)
  String shelf;

  Product({
    required this.name,
    required this.barcode,
    required this.quantity,
    required this.price,
    required this.shelf,
  });
}
