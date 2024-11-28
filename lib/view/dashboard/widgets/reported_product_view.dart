import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:item_track/model/productModel/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const reportedkeytest = "report_pro1";

class ReportedProductView extends StatefulWidget {
  const ReportedProductView({super.key});

  @override
  State<ReportedProductView> createState() => _ReportedProductViewState();
}

class _ReportedProductViewState extends State<ReportedProductView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reported Products"),
      ),
      body: FutureBuilder(
        future: fetchProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.data == null ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No Reported Products Found!"),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];
                return Card(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        const Icon(Icons.report),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.productname ?? '',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("Barcode: ${data.barcode ?? ''}"),
                            Text("Price: ${data.price ?? ''}"),
                            Text("Quantity: ${data.quantity ?? ''}"),
                            Text("Shelf: ${data.shelf ?? ''}"),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.colorScheme.error,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  deleteProduct(data);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: theme.colorScheme.onError,
                                ),
                              ),
                            ),
                            const Gap(10),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.colorScheme.primaryContainer,
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      final nameController =
                                          TextEditingController(
                                              text: data.productname);
                                      final priceController =
                                          TextEditingController(
                                              text: data.price);
                                      final quantityController =
                                          TextEditingController(
                                              text: data.quantity);

                                      return AlertDialog(
                                        title: const Text("Edit Product"),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              TextField(
                                                controller: nameController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Product Name',
                                                ),
                                              ),
                                              TextField(
                                                controller: priceController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Price',
                                                ),
                                              ),
                                              TextField(
                                                controller: quantityController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Quantity',
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  updateProduct(
                                                      data,
                                                      nameController.text,
                                                      priceController.text,
                                                      quantityController.text);
                                                  Navigator.pop(context);
                                                },
                                                child:
                                                    const Text("Save Changes"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<ProductModel>> fetchProduct() async {
    List<ProductModel> allProducts = [];
    final pref = await SharedPreferences.getInstance();
    var list = pref.getStringList(reportedkeytest) ?? [];
    allProducts = list.map((e) => ProductModel.fromJson(e)).toList();
    return allProducts;
  }

  Future<void> deleteProduct(ProductModel product) async {
    final pref = await SharedPreferences.getInstance();
    var list = pref.getStringList(reportedkeytest) ?? [];
    list.removeWhere((item) =>
        ProductModel.fromJson(item).id ==
        product.id); 
    await pref.setStringList(reportedkeytest, list);
    setState(() {});
  }

  Future<void> updateProduct(ProductModel product, String newName,
      String newPrice, String newQuantity) async {
    final pref = await SharedPreferences.getInstance();
    var list = pref.getStringList(reportedkeytest) ?? [];

    for (var i = 0; i < list.length; i++) {
      var currentProduct = ProductModel.fromJson(list[i]);
      if (currentProduct.id == product.id) {
        currentProduct.productname = newName;
        currentProduct.price = newPrice;
        currentProduct.quantity = newQuantity;

        list[i] = currentProduct.toJson();
        break;
      }
    }
    await pref.setStringList(reportedkeytest, list);
    setState(() {});
  }
}
