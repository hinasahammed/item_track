import 'package:flutter/material.dart';
import 'package:item_track/viewmodel/services/barcode_services.dart';

class ScanBarCode extends StatefulWidget {
  const ScanBarCode({super.key});

  @override
  State<ScanBarCode> createState() => _ScanBarCodeState();
}

class _ScanBarCodeState extends State<ScanBarCode> {
  late BarcodeScannerService _scannerService;
  String _scannedBarcode = '';
  bool _isProductAdded = false;
  bool _isProductUpdated = false;

  @override
  void initState() {
    super.initState();
    _scannerService = BarcodeScannerService();
  }

  void _scanBarcode(BuildContext context) async {
    String? barcode = await _scannerService.scanBarcode(context);
    if (barcode!.isNotEmpty) {
      setState(() {
        _scannedBarcode = barcode;
      });
      if (context.mounted) {
        await _scannerService.addProduct(context, barcode);
      }
      setState(() {
        _isProductAdded = _isProductUpdated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product by Scanning Barcode"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  _scanBarcode(context);
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Scan Barcode'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_scannedBarcode.isNotEmpty) ...[
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(Icons.barcode_reader),
                  title: Text("Scanned Barcode: $_scannedBarcode"),
                ),
              ),
              const Divider(),
            ],
            if (_isProductAdded && !_isProductUpdated) ...[
              Card(
                color: Colors.green[50],
                margin: const EdgeInsets.only(bottom: 16),
                child: const ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text(
                    "Product added successfully!",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
              const Divider(),
            ],
            if (_isProductUpdated) ...[
              Card(
                color: Colors.green[50],
                margin: const EdgeInsets.only(bottom: 16),
                child: const ListTile(
                  leading: Icon(Icons.refresh, color: Colors.green),
                  title: Text(
                    "Product quantity updated successfully!",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
              const Divider(),
            ],
            if (_scannedBarcode.isEmpty && !_isProductAdded)
              const Text(
                "Scan a barcode to add a product.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
