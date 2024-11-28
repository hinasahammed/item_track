import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:item_track/model/productModel/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllProductView extends StatefulWidget {
  const AllProductView({super.key});

  @override
  State<AllProductView> createState() => _AllProductViewState();
}

class _AllProductViewState extends State<AllProductView> {
  TextEditingController searchController = TextEditingController();
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    final pref = await SharedPreferences.getInstance();
    var list = pref.getStringList("testing_product") ?? [];
    allProducts = list.map((e) => ProductModel.fromJson(e)).toList();
    setState(() {
      filteredProducts = allProducts;
    });
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = allProducts.where((product) {
        return product.productname!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            product.barcode!.toString().contains(query);
      }).toList();
    });
  }

  Future<void> updateProduct(ProductModel product) async {
    final pref = await SharedPreferences.getInstance();
    List<String> productList = pref.getStringList("testing_product") ?? [];

    for (int i = 0; i < productList.length; i++) {
      if (ProductModel.fromJson(productList[i]).barcode == product.barcode) {
        productList[i] = product.toJson();
        break;
      }
    }
    await pref.setStringList("testing_product", productList);
    setState(() {
      fetchProduct();
    });
  }

  Future<void> deleteProduct(ProductModel product) async {
    final pref = await SharedPreferences.getInstance();
    List<String> productList = pref.getStringList("testing_product") ?? [];

    productList.removeWhere(
        (item) => ProductModel.fromJson(item).barcode == product.barcode);

    await pref.setStringList("testing_product", productList);
    setState(() {
      fetchProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                filterProducts(query);
              },
              decoration: InputDecoration(
                labelText: 'Search by Name or Barcode',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: filteredProducts.isEmpty
          ? const Center(child: Text("No product found"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.production_quantity_limits,
                          size: 30,
                        ),
                        const Gap(20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productname ?? '',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Quantity: ${product.quantity ?? ''}",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Price: ₹${product.price ?? ''} / Product",
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              "Shelf: ${product.shelf ?? ''}",
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              "Total Amount: ₹${(double.tryParse(product.quantity ?? '0') ?? 0) * (double.tryParse(product.price ?? '0') ?? 0)}",
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
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
                                  // Delete product
                                  deleteProduct(product);
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
                                  // Edit product (navigate to edit screen)
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Edit Product"),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              TextField(
                                                controller:
                                                    TextEditingController(
                                                        text: product
                                                            .productname),
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Product Name',
                                                ),
                                                onChanged: (value) {
                                                  product.productname = value;
                                                },
                                              ),
                                              TextField(
                                                controller:
                                                    TextEditingController(
                                                        text: product.price),
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Price',
                                                ),
                                                onChanged: (value) {
                                                  product.price = value;
                                                },
                                              ),
                                              TextField(
                                                controller:
                                                    TextEditingController(
                                                        text: product.quantity),
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Quantity',
                                                ),
                                                onChanged: (value) {
                                                  product.quantity = value;
                                                },
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Update the product
                                                  updateProduct(product);
                                                  Navigator.of(context).pop();
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
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
