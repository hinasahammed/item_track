import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:item_track/model/product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Product>('products').listenable(),
        builder: (context, Box<Product> box, _) {
          if (box.isEmpty) return const Center(child: Text("No Products"));

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final product = box.getAt(index);
              return ListTile(
                title: Text(product!.name),
                subtitle: Text(
                    "Quantity: ${product.quantity}, Price: ${product.price}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await product.delete();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
