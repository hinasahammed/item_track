import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';

class ScanBarCode extends StatefulWidget {
  const ScanBarCode({super.key});

  @override
  State<ScanBarCode> createState() => _ScanBarCodeState();
}

class _ScanBarCodeState extends State<ScanBarCode> {
 String barcode = "";

  Future<void> scanBarcode() async {
    var result = await BarcodeScanner.scan();
    setState(() {
      barcode = result.rawContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Product")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Scanned Barcode: $barcode"),
            ElevatedButton(
              onPressed: scanBarcode,
              child: const Text("Scan"),
            ),
          ],
        ),
      ),
    );
  }
}