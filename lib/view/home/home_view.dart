import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:item_track/model/productModel/product_model.dart';
import 'package:item_track/view/addProduct/add_product_view.dart';
import 'package:item_track/view/allProdcutView/all_product_view.dart';
import 'package:item_track/view/home/widget/product_card.dart';
import 'package:item_track/view/home/widget/stock_card.dart';
import 'package:item_track/view/uploadExcel/upload_excel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Stock",
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(20),
            Row(
              children: [
                Expanded(
                  child: StockCard(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddProductView()),
                      );
                      if (result == true) {
                        setState(() {});
                      }
                    },
                    imageUrl: "assets/images/add_product.png",
                    title: "Add Product",
                  ),
                ),
                Expanded(
                  child: StockCard(
                    onTap: () async{
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllProductView()),
                      );
                      if (result == true) {
                        setState(() {});
                      }
                    },
                    imageUrl: "assets/images/view_product.png",
                    title: "View Product",
                  ),
                ),
                Expanded(
                  child: StockCard(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UploadExcel()),
                      );
                      if (result == true) {
                        setState(() {});
                      }
                    },
                    imageUrl: "assets/images/view_product.png",
                    title: "Upload Excel",
                  ),
                )
              ],
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Products",
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllProductView(),
                        ));
                  },
                  child: Text(
                    "See all",
                    style: theme.textTheme.labelLarge!.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            const Gap(20),
            FutureBuilder(
              future: fetchProduct(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.data == null ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No products found!"),
                  );
                } else {
                  return ProductCard(productList: snapshot.data!);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<List<ProductModel>> fetchProduct() async {
    List<ProductModel> allProducts = [];
    final pref = await SharedPreferences.getInstance();
    var list = pref.getStringList("testing_product") ?? [];
    allProducts = list.map((e) => ProductModel.fromJson(e)).toList();
    return allProducts;
  }
}
