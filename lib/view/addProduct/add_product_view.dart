import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:item_track/res/components/common/custom_button.dart';
import 'package:item_track/view/addManually/add_manually_view.dart';
import 'package:item_track/view/addProduct/widgets/scan_bar_code.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: double.infinity,
              child: CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddManuallyView()),
                  );
                },
                icon: Icons.keyboard,
                btnText: "Add Manually",
              ),
            ),
            const Gap(10),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScanBarCode()),
                  );
                },
                icon: Icons.camera,
                btnText: "Scan Product",
              ),
            )
          ],
        ),
      ),
    );
  }
}
