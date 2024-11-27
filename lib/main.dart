import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:item_track/model/product.dart';
import 'package:item_track/model/shelf.dart';
import 'package:item_track/view/login/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter()); 
  Hive.registerAdapter(ShelfAdapter());

   await Hive.openBox<Product>('products');
  await Hive.openBox<Shelf>('shelves');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Item Track',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginView(),
    );
  }
}
