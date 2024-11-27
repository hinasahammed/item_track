import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:item_track/res/components/common/custom_button.dart';
import 'package:item_track/res/components/common/custom_textformfield.dart';
import 'package:item_track/view/bottomNavigation/custom_navigation.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final employeeId = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employ Login"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Employ Id",
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Gap(10),
            const CustomTextFormfield(
              fieldTitle: "Employ Id",
            ),
            const Gap(20),
            Text(
              "Password",
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Gap(10),
            const CustomTextFormfield(
              fieldTitle: "Password",
            ),
            const Gap(40),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CustomBottomNavigation()),
                  );
                },
                btnText: "Login",
              ),
            )
          ],
        ),
      ),
    );
  }
}
