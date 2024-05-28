import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/helpers/constants/style.dart';
import 'package:flutter_web_dashboard/viewmodels/admin_controller.dart';
import 'package:flutter_web_dashboard/views/widgets/custom_text.dart';

import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AdminController controller = AdminController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  String adminEmail = "";
  String adminPassword = "";

  Future<void> allowAdminToLogin() async {
    final checkingSnackBar = ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Checking Credentials, Please wait...",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.pinkAccent,
        duration: Duration(seconds: 6),
      ),
    );

    String adminEmail = _emailTextController.text.trim();
    String adminPassword = _passwordTextController.text;
    try {
      controller.login(adminEmail, adminPassword);
      checkingSnackBar.close();
    } catch (error) {
      checkingSnackBar.close();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Login unsuccessfully! $error",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.pinkAccent,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Image.asset("assets/icons/logo.png"),
                  ),
                  Expanded(child: Container()),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    "Login",
                    style: GoogleFonts.roboto(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  CustomText(
                    text: "Welcome back to the admin panel.",
                    color: lightGrey,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _emailTextController,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "abc@domain.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                obscureText: true,
                controller: _passwordTextController,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "123",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  // Row(
                  //   children: [
                  //     Checkbox(value: true, onChanged: (value) {}),
                  //     const CustomText(
                  //       text: "Remeber Me",
                  //     ),
                  //   ],
                  // ),
                  // CustomText(text: "Forgot password?", color: active)
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  // Get.offAllNamed(rootRoute);
                  allowAdminToLogin();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: active,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const CustomText(
                    text: "Login",
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(text: "Do not have admin credentials? "),
                    TextSpan(
                      text: "Request Credentials! ",
                      style: TextStyle(color: active),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
