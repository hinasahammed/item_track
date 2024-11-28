import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:item_track/model/productModel/product_model.dart';
import 'package:item_track/res/components/common/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadExcel extends StatefulWidget {
  const UploadExcel({super.key});

  @override
  State<UploadExcel> createState() => _UploadExcelState();
}

class _UploadExcelState extends State<UploadExcel> {
  bool isLoading = false;

  Future<List<ProductModel>> convertExcelToJson() async {
    List<ProductModel> allproducts = [];
    List<Map<String, dynamic>> jsonDataList = [];

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      var file = File(result.files.single.path!);
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var sheet = excel.tables.keys.first;
      var rows = excel.tables[sheet]!.rows;

      var headers =
          rows[0].map((cell) => cell?.value.toString() ?? '').toList();

      for (var i = 1; i < rows.length; i++) {
        Map<String, dynamic> rowData = {};
        bool hasNonNullData = false;

        for (var j = 0; j < headers.length; j++) {
          var cellValue = rows[i][j]?.value;
          if (cellValue != null && cellValue.toString().trim().isNotEmpty) {
            rowData[headers[j]] = _convertToEncodableValue(cellValue);
            hasNonNullData = true;
          }
        }

        if (hasNonNullData) {
          jsonDataList.add(rowData);
        }
      }

      for (var i in jsonDataList) {
        allproducts.add(ProductModel.fromJson(jsonEncode(i)));
      }
      return allproducts;
    } else {
      log('File picking cancelled.');
      return allproducts;
    }
  }

  dynamic _convertToEncodableValue(dynamic value) {
    if (value == null) return null;
    if (value is int || value is double || value is String || value is bool) {
      return value;
    }
    return value.toString();
  }

  void storetoLocal(BuildContext context) async {
    const productkeyTesting = "testing_product";
    List<String> jsonProductData = [];
    final pref = await SharedPreferences.getInstance();
    var allproduct = await convertExcelToJson();

    for (var i in allproduct) {
      jsonProductData.add(i.toJson());
    }

    await pref.setStringList(productkeyTesting, jsonProductData);
    var gettingProduct = pref.getStringList(productkeyTesting);
    log(gettingProduct.toString());

    if (context.mounted) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Excel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload your Excel file and convert it to JSON format.',
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                onPressed: () {
                  setState(() {
                    isLoading = true; 
                  });
                  storetoLocal(context);
                },
                btnText: "Pick Excel and Convert to JSON",
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              Center(
                child: Text(
                  'Ready to upload your file!',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
