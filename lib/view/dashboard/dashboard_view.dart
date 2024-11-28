import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:item_track/view/allProdcutView/all_product_view.dart';
import 'package:item_track/view/dashboard/widgets/reported_product_view.dart';
import 'package:item_track/view/dashboard/widgets/shelf_view.dart';
import 'package:item_track/view/login/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            itemCard(
              Icons.report,
              "Reported Products",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportedProductView(),
                  ),
                );
              },
            ),
            itemCard(
              Icons.production_quantity_limits,
              "All Products",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllProductView(),
                  ),
                );
              },
            ),
            itemCard(
              Icons.shelves,
              "Shelves",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShelfView(),
                  ),
                );
              },
            ),
            const Spacer(),
            itemCard(
              Icons.logout,
              "Logout",
              () {
                showLogoutDialog(context);
              },
            ),
            const Gap(20)
          ],
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final pref = await SharedPreferences.getInstance();
                pref.remove(
                    'employeeId');

                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                    (route) =>
                        false,
                  );
                }
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}

Widget itemCard(IconData leading, String title, void Function()? onTap) {
  return Card(
    child: ListTile(
      onTap: onTap,
      leading: Icon(leading),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
    ),
  );
}
