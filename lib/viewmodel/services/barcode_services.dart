import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:item_track/view/reportProduct/add_report_product_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:item_track/model/productModel/product_model.dart';

const productkeyTesting = "testing_product";

class BarcodeScannerService {
  // Function to scan the barcode and return the scanned value
  Future<String?> scanBarcode(BuildContext context) async {
    try {
      var scanResult = await BarcodeScanner.scan();
      return scanResult.rawContent; // Returns the scanned barcode string
    } catch (e) {
      log("Error scanning barcode: $e");
      return null;
    }
  }

  // Function to add or update product based on scanned barcode
  Future<void> addProduct(BuildContext context, String barcode) async {
    const productkeyTesting = "testing_product";
    const reportedkeytest = "report_pro1";
    final pref = await SharedPreferences.getInstance();
    List<ProductModel> products =
        await fetchProductsFromPrefs(pref, productkeyTesting);

    List<ProductModel> reportedProducts =
        await fetchProductsFromPrefs(pref, reportedkeytest);

    var val = products.where(
        (element) => element.barcode == double.parse(barcode).toString());
    if (val.isNotEmpty) {
      var productToUpdate = val.first;
      int currentQuantity = int.tryParse(productToUpdate.quantity ?? '0') ?? 0;
      int addedQuantity = 1;
      productToUpdate.quantity = (currentQuantity + addedQuantity).toString();

      await pref.setStringList(
          productkeyTesting, products.map((e) => e.toJson()).toList());

      Fluttertoast.showToast(msg: "Product added successfully!");
    } else {
      var checkItContain = reportedProducts.where(
          (element) => element.barcode == double.parse(barcode).toString());

      if (checkItContain.isNotEmpty) {
        var reportedUpdate = checkItContain.first;
        int currentQuantity = int.tryParse(reportedUpdate.quantity ?? '0') ?? 0;
        int addedQuantity = 1;
        reportedUpdate.quantity = (currentQuantity + addedQuantity).toString();

        await pref.setStringList(
            reportedkeytest, reportedProducts.map((e) => e.toJson()).toList());

        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Reported Product"),
              content: const Text(
                  "This product is already reported and its quantity has been updated."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      } else {
        if (context.mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddReportProductView(
                  barcode: barcode,
                ),
              ));
        }
      }
    }
  }

  Future<List<ProductModel>> fetchProductsFromPrefs(
      SharedPreferences pref, String key) async {
    List<ProductModel> productList = [];
    var list = pref.getStringList(key) ?? [];
    for (var item in list) {
      productList.add(ProductModel.fromJson(item));
    }
    return productList;
  }

  Future<void> saveProductsToPrefs(
      SharedPreferences pref, List<ProductModel> products) async {
    List<String> productStrings =
        products.map((product) => product.toJson()).toList();
    await pref.setStringList("testing_product", productStrings);
  }
}
