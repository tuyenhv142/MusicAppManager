import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/helpers/constants/style.dart';
import 'package:flutter_web_dashboard/routing/app_pages.dart';
import 'package:flutter_web_dashboard/viewmodels/admin_controller.dart';
import 'package:flutter_web_dashboard/views/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Header extends StatelessWidget {
  Header({Key? key}) : super(key: key);

  final AdminController controller =
      Get.put(AdminController()); // Ensure controller is properly initialized

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<String> _getEmailFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? "Guest";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getEmailFromPrefs(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String userEmail = snapshot.data ?? "Guest";
          return SizedBox(
            height: Get.height * 0.1,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Row(
                children: [
                  Expanded(child: Container()),
                  IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: dark,
                    ),
                    onPressed: () {
                      Get.bottomSheet(
                        Container(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                const Text(
                                  "Change password",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: controller.passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Old Password',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Old Password cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: controller.newPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'New Password',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'New Password cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller:
                                      controller.confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Re-enter New Password',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Re-enter New Password cannot be empty';
                                    }
                                    if (value !=
                                        controller.newPasswordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                ConstrainedBox(
                                  constraints: BoxConstraints.tightFor(
                                    width: Get.width,
                                    height: 40,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        await controller.updatePassword();
                                        controller.passwordController.clear();
                                        controller.newPasswordController
                                            .clear();
                                        controller.confirmPasswordController
                                            .clear();
                                      }
                                    },
                                    child: const Text('Update'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    width: 1,
                    height: 22,
                    color: lightGrey,
                  ),
                  const SizedBox(width: 24),
                  CustomText(
                    text: userEmail,
                    color: lightGrey,
                  ),
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: active.withOpacity(.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.all(2),
                      child: const CircleAvatar(
                        backgroundColor: light,
                        child: Icon(
                          Icons.person_outline,
                          color: dark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Container(
                    width: 1,
                    height: 22,
                    color: lightGrey,
                  ),
                  const SizedBox(width: 10),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.logout_outlined,
                          color: dark.withOpacity(.7),
                        ),
                        onPressed: () {
                          Get.defaultDialog(
                            title: 'Sign Out',
                            content:
                                const Text("Are you sure you want to log out?"),
                            cancel: ElevatedButton(
                              onPressed: () => Get.back(),
                              child: const Text("Cancel"),
                            ),
                            confirm: ElevatedButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove('id');
                                prefs.remove('name');
                                prefs.remove('email');
                                prefs.remove('password');
                                Get.toNamed(Routes.LOGIN);
                              },
                              child: const Text('Logout'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
