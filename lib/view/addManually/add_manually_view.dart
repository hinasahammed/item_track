import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:item_track/model/product.dart';
import 'package:item_track/res/components/common/custom_button.dart';
import 'package:item_track/res/components/common/custom_textformfield.dart';

class AddManuallyView extends StatefulWidget {
  const AddManuallyView({super.key});

  @override
  State<AddManuallyView> createState() => _AddManuallyViewState();
}

class _AddManuallyViewState extends State<AddManuallyView> {
  final nameController = TextEditingController();
  final barcodeController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final shelfController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Manually"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product name",
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Gap(10),
            CustomTextFormfield(
              controller: nameController,
              fieldTitle: "Product name",
            ),
            const Gap(20),
            Text(
              "Barcode",
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Gap(10),
            CustomTextFormfield(
              controller: barcodeController,
              fieldTitle: "Barcode",
            ),
            const Gap(20),
            Text(
              "Quantity",
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Gap(10),
            CustomTextFormfield(
              controller: quantityController,
              fieldTitle: "Quantity",
            ),
            const Gap(20),
            Text(
              "Price",
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Gap(10),
            CustomTextFormfield(
              controller: priceController,
              fieldTitle: "Price",
            ),
            const Gap(20),
            Text(
              "Shelf",
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Gap(10),
            CustomTextFormfield(
              controller: shelfController,
              fieldTitle: "Shelf",
            ),
            const Gap(40),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: CustomButton(
                onPressed: () async{
                  final box = await Hive.openBox<Product>('products');
                final product = Product(
                  name: nameController.text,
                  barcode: barcodeController.text,
                  quantity: int.parse(quantityController.text),
                  price: double.parse(priceController.text),
                  shelf: shelfController.text,
                );
                await box.add(product);
                Navigator.pop(context);
                },
                btnText: "Add Product",
              ),
            )
          ],
        ),
      ),
    );
  }
}
