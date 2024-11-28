import 'package:flutter/material.dart';
import 'package:item_track/model/productModel/product_model.dart';
import 'package:item_track/view/reportProduct/add_report_product_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShelfDetails extends StatefulWidget {
  const ShelfDetails({super.key, required this.shelfName});
  final String shelfName;

  @override
  State<ShelfDetails> createState() => _ShelfDetailsState();
}

class _ShelfDetailsState extends State<ShelfDetails> {
  List<ProductModel> filteredProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAndFilterProducts();
  }

  Future<void> fetchAndFilterProducts() async {
    const productKey = "testing_product";
    final prefs = await SharedPreferences.getInstance();

    List<ProductModel> allProducts = [];
    List<String> productStrings = prefs.getStringList(productKey) ?? [];
    List<String> reportedProductStrings =
        prefs.getStringList(reportedkeytest) ?? [];

    for (var productString in productStrings) {
      allProducts.add(ProductModel.fromJson(productString));
    }

    for (var productString in reportedProductStrings) {
      allProducts.add(ProductModel.fromJson(productString));
    }

    setState(() {
      filteredProducts = allProducts
          .where((product) =>
              product.shelf?.toLowerCase() == widget.shelfName.toLowerCase())
          .toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shelf: ${widget.shelfName}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredProducts.isEmpty
              ? const Center(child: Text('No products found for this shelf.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return Card(
                      color: theme.colorScheme.primaryContainer,
                      child: ListTile(
                        title: Text(
                          product.productname ?? 'Unnamed Product',
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        subtitle: Text(
                            'Barcode: ${product.barcode}\nQuantity: ${product.quantity}'),
                        trailing: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Price: \$${product.price}'),
                        )),
                      ),
                    );
                  },
                ),
    );
  }
}
