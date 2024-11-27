import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

class UploadExcel extends StatefulWidget {
  const UploadExcel({super.key});

  @override
  State<UploadExcel> createState() => _UploadExcelState();
}

class _UploadExcelState extends State<UploadExcel> {
  List<Map<String, dynamic>> _jsonData = [];

  Future<void> convertExcelToJson() async {
    // Use FilePicker to select an Excel file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      var file = File(result.files.single.path!);

      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      List<Map<String, dynamic>> jsonDataList = [];

      var sheet = excel.tables.keys.first;
      var rows = excel.tables[sheet]!.rows;

      var headers =
          rows[0].map((cell) => cell?.value.toString() ?? '').toList();

      for (var i = 1; i < rows.length; i++) {
        Map<String, dynamic> rowData = {};
        bool hasNonNullData = false;

        for (var j = 0; j < headers.length; j++) {
          var cellValue = rows[i][j]?.value;

          // Skip null or empty values
          if (cellValue != null && cellValue.toString().trim().isNotEmpty) {
            rowData[headers[j]] = _convertToEncodableValue(cellValue);
            hasNonNullData = true;
          }
        }

        // Only add row if it has non-null data
        if (hasNonNullData) {
          jsonDataList.add(rowData);
        }
      }

      await saveJsonToFile(jsonDataList);

      setState(() {
        _jsonData = jsonDataList;
      });
    } else {
      print('File picking cancelled.');
    }
  }

  dynamic _convertToEncodableValue(dynamic value) {
    if (value == null) return null;

    if (value is int || value is double || value is String || value is bool) {
      return value;
    }

    return value.toString();
  }

  Future<void> saveJsonToFile(List<Map<String, dynamic>> jsonData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/converted_data.json');

      await file.writeAsString(jsonEncode(jsonData));
      print('JSON file saved: ${file.path}');
    } catch (e) {
      print('Error saving JSON file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel to JSON Converter'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: convertExcelToJson,
            child: const Text('Pick Excel and Convert to JSON'),
          ),
          Expanded(
            child: _jsonData.isNotEmpty
                ? ListView.builder(
                    itemCount: _jsonData.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      log(jsonEncode(_jsonData[index]));
                      return Card(
                        child: ListTile(
                          title: Text('Row ${index + 1}'),
                          subtitle: Text(jsonEncode(_jsonData[index])),
                        ),
                      );
                    },
                  )
                : const Center(child: Text('No data converted yet')),
          ),
        ],
      ),
    );
  }
}
