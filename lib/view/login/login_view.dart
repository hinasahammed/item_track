import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:item_track/res/components/common/custom_button.dart';
import 'package:item_track/res/components/common/custom_textformfield.dart';
import 'package:item_track/res/utils/employee_credentials.dart';
import 'package:item_track/view/bottomNavigation/custom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart'; // for Toast

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final employeeId = TextEditingController();
  final password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // Function to validate and check employee credentials
  void validateAndLogin(BuildContext context) async {
    // Validate if fields are not empty
    if (employeeId.text.isEmpty || password.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill in both fields.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // Check if the employeeId and password match any employee
    bool isValid = false;
    for (var employee in employees) {
      if (employee.employeeId == employeeId.text &&
          employee.password == password.text) {
        isValid = true;
        break;
      }
    }

    if (isValid) {
      // Show success Toast
      Fluttertoast.showToast(
        msg: "Login Successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      // Store user data in SharedPreferences (optional)
      final pref = await SharedPreferences.getInstance();
      pref.setString('employeeId', employeeId.text);

      // Navigate to the next screen
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const CustomBottomNavigation()),
        );
      }
    } else {
      // Show error Toast
      Fluttertoast.showToast(
        msg: "Invalid Employee ID or Password!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Login"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Employee Id",
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Gap(10),
            CustomTextFormfield(
              fieldTitle: "Employee Id",
              controller: employeeId,
            ),
            const Gap(20),
            Text(
              "Password",
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Gap(10),
            CustomTextFormfield(
              fieldTitle: "Password",
              controller: password,
            ),
            const Gap(40),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: CustomButton(
                onPressed: () {
                  validateAndLogin(context);
                },
                btnText: "Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
