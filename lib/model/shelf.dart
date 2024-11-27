import 'package:hive/hive.dart';

part 'shelf.g.dart';

@HiveType(typeId: 1)
class Shelf extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double stockPercentage;

  Shelf({
    required this.name,
    required this.stockPercentage,
  });
}
