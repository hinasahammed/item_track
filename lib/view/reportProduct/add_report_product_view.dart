import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:item_track/model/productModel/product_model.dart';
import 'package:item_track/res/components/common/custom_button.dart';
import 'package:item_track/res/components/common/custom_textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
const reportedkeytest = "report_pro1";

class AddReportProductView extends StatefulWidget {
  const AddReportProductView({super.key, required this.barcode});
  final String barcode;
  @override
  State<AddReportProductView> createState() => _AddReportProductViewState();
}

class _AddReportProductViewState extends State<AddReportProductView> {
  final nameController = TextEditingController();
  late final TextEditingController barcodeController;
  final quantityController = TextEditingController(text: "1");
  final priceController = TextEditingController();
  final shelfController = TextEditingController();

  @override
  void initState() {
    super.initState();
    barcodeController = TextEditingController(text: widget.barcode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report product"),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: buildProductInputForm(theme)),
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
        SizedBox(
          height: 50,
          width: double.infinity,
          child: CustomButton(
            onPressed: () {
              addProduct(context);
            },
            btnText: "Add Product",
          ),
        )
      ],
    );
  }

  Future addProduct(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    var oldData = pref.getStringList(reportedkeytest) ?? [];
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
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  List<ProductModel> parseProducts(List<String> jsonList) {
    return jsonList
        .map((jsonString) {
          try {
            return ProductModel.fromJson(jsonString);
          } catch (e) {
            return null;
          }
        })
        .where((product) => product != null)
        .cast<ProductModel>()
        .toList();
  }

  void clearFields() {
    nameController.clear();
    barcodeController.clear();
    quantityController.text = "1";
    priceController.clear();
    shelfController.clear();
  }
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
