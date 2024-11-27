import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:item_track/model/shelf.dart';

class ShelfView extends StatelessWidget {
  final nameController = TextEditingController();

  ShelfView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shelve Management")),
      body: Column(
        children: [
          TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Shelf Name')),
          ElevatedButton(
            onPressed: () async {
              final box = await Hive.openBox<Shelf>('shelves');
              final shelf =
                  Shelf(name: nameController.text, stockPercentage: 0.0);
              await box.add(shelf);
            },
            child: const Text("Add Shelf"),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Shelf>('shelves').listenable(),
              builder: (context, Box<Shelf> box, _) {
                if (box.isEmpty) return const Center(child: Text("No Shelves"));

                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final shelf = box.getAt(index);
                    return ListTile(title: Text(shelf!.name));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
