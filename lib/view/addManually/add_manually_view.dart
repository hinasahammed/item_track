import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:item_track/model/productModel/product_model.dart';
import 'package:item_track/res/components/common/custom_button.dart';
import 'package:item_track/res/components/common/custom_textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddManuallyView extends StatefulWidget {
  const AddManuallyView({super.key});

  @override
  State<AddManuallyView> createState() => _AddManuallyViewState();
}

class _AddManuallyViewState extends State<AddManuallyView> {
  final nameController = TextEditingController();
  final barcodeController = TextEditingController();
  final quantityController = TextEditingController(text: "1");
  final priceController = TextEditingController();
  final shelfController = TextEditingController();
  final uuid = const Uuid();


  bool notFound = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Manually"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: notFound
            ? buildProductInputForm(theme)
            : buildBarcodeInputForm(theme),
      ),
    );
  }

  Widget buildProductInputForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInputField("Product name", nameController, theme),
        buildInputField("Barcode", barcodeController, theme),
        buildInputField("Quantity", quantityController, theme),
        buildInputField("Price", priceController, theme),
        buildInputField("Shelf", shelfController, theme),
        const Gap(40),
        buildSubmitButton(),
      ],
    );
  }

  Widget buildBarcodeInputForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInputField("Barcode", barcodeController, theme),
        buildInputField("Quantity", quantityController, theme),
        const Gap(40),
        buildSubmitButton(),
      ],
    );
  }

  Widget buildInputField(
      String label, TextEditingController controller, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Gap(10),
        CustomTextFormfield(
          controller: controller,
          fieldTitle: label,
        ),
        const Gap(20),
      ],
    );
  }

  Widget buildSubmitButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: CustomButton(
        onPressed: () {
          addProduct(context);
        },
        btnText: "Add Product",
      ),
    );
  }

  List<ProductModel> parseProducts(List<String> jsonList) {
    return jsonList
        .map((jsonString) {
          try {
            return ProductModel.fromJson(jsonString);
          } catch (e) {
            log("Invalid product data: $jsonString");
            return null;
          }
        })
        .where((product) => product != null)
        .cast<ProductModel>()
        .toList();
  }

  Future addProduct(BuildContext context) async {
    const productkeyTesting = "testing_product";
    const reportedkeytest = "report_pro1";
    const uuid = Uuid();

    final pref = await SharedPreferences.getInstance();
    var allProduct = pref.getStringList(productkeyTesting) ?? [];
    log("before adding product${allProduct.toString()}");

    List<ProductModel> listProduct = parseProducts(allProduct);

    var val = listProduct.where((element) =>
        element.barcode ==
        double.parse(barcodeController.text.trim()).toString());

    if (val.isNotEmpty) {
      // Update quantity in `testing_product`
      var productToUpdate = val.first;
      int currentQuantity = int.tryParse(productToUpdate.quantity ?? '0') ?? 0;
      int addedQuantity = int.tryParse(quantityController.text.trim()) ?? 0;
      productToUpdate.quantity = (currentQuantity + addedQuantity).toString();

      await pref.setStringList(
          productkeyTesting, listProduct.map((e) => e.toJson()).toList());

      Fluttertoast.showToast(msg: "Product added successfully!");
      clearFields();
    } else {
      // Product not found in `testing_product`
      setState(() {
        notFound = true;
      });

      var oldData = pref.getStringList(reportedkeytest) ?? [];
      log("before adding reported product${oldData.toString()}");
      List<ProductModel> productList = parseProducts(oldData);

      var checkItContain = productList.where((element) =>
          element.barcode ==
          double.parse(barcodeController.text.trim()).toString());

      log("Containing reported list ${checkItContain.toString()}");

      if (checkItContain.isNotEmpty) {
        // Update quantity in `report_pro1`
        var reportedUpdate = checkItContain.first;
        int currentQuantity = int.tryParse(reportedUpdate.quantity ?? '0') ?? 0;
        int addedQuantity = int.tryParse(quantityController.text.trim()) ?? 0;
        reportedUpdate.quantity = (currentQuantity + addedQuantity).toString();

        await pref.setStringList(
            reportedkeytest, productList.map((e) => e.toJson()).toList());

        // Notify the user about the reported product
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

        clearFields();
        setState(() {
          notFound = false;
        });
      } else {
        // Report new product
        if (nameController.text.trim().isEmpty ||
            priceController.text.trim().isEmpty ||
            shelfController.text.trim().isEmpty) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      "This product not found in the database! Please fill all required fields.")),
            );
          }
          return;
        }

        var product = ProductModel(
          id: uuid.v4(),
          barcode: double.parse(barcodeController.text.trim()).toString(),
          productname: nameController.text.trim(),
          price: priceController.text.trim(),
          shelf: shelfController.text.trim(),
          quantity: quantityController.text.trim(),
        );

        await pref.setStringList(
          reportedkeytest,
          [...oldData, product.toJson()],
        );

        Fluttertoast.showToast(msg: "Product reported successfully!");
        clearFields();
        setState(() {
          notFound = false;
        });
      }
    }
  }

  /// Clears all input fields
  void clearFields() {
    nameController.clear();
    barcodeController.clear();
    quantityController.text = "1";
    priceController.clear();
    shelfController.clear();
  }
}
