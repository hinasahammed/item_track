import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:item_track/viewmodel/services/barcode_services.dart';
import 'package:item_track/model/productModel/product_model.dart';
import 'package:item_track/view/dashboard/widgets/shelf_details.dart';
import 'package:item_track/view/reportProduct/add_report_product_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShelfView extends StatefulWidget {
  const ShelfView({super.key});

  @override
  State<ShelfView> createState() => _ShelfViewState();
}

class _ShelfViewState extends State<ShelfView> {
  List<String> shelf = [];

  Future<List<ProductModel>> fetchProduct() async {
    List<String> shelftemp = [];
    List<ProductModel> reportedProducts = [];
    List<ProductModel> allProducts = [];
    final pref = await SharedPreferences.getInstance();

    var reportedlist = pref.getStringList(reportedkeytest) ?? [];
    reportedProducts =
        reportedlist.map((e) => ProductModel.fromJson(e)).toList();

    var list = pref.getStringList(productkeyTesting) ?? [];
    allProducts = list.map((e) => ProductModel.fromJson(e)).toList();

    for (var i in allProducts) {
      if (!shelftemp.contains(i.shelf)) {
        shelftemp.add(i.shelf ?? '');
      }
    }
    for (var i in reportedProducts) {
      if (!shelftemp.contains(i.shelf)) {
        shelftemp.add(i.shelf ?? '');
      }
    }
    setState(() {
      shelf = shelftemp;
    });
    return allProducts;
  }

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Shelves"),
        ),
        body: shelf.isEmpty
            ? const Center(
                child: Text("No Shelf found"),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 150,
                ),
                itemCount: shelf.length,
                itemBuilder: (context, index) {
                  final data = shelf[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShelfDetails(
                              shelfName: data,
                            ),
                          ));
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.shelves,
                              size: 50,
                            ),
                            const Gap(10),
                            Text(
                              "Shelf: $data",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}
