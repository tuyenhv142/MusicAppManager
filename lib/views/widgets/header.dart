import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/helpers/constants/style.dart';
import 'package:flutter_web_dashboard/routing/app_pages.dart';
import 'package:flutter_web_dashboard/views/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

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
                    onPressed: () {},
                  ),
                  Container(
                    width: 1,
                    height: 22,
                    color: lightGrey,
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  CustomText(
                    text: userEmail,
                    color: lightGrey,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
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
                  const SizedBox(
                    width: 24,
                  ),
                  Container(
                    width: 1,
                    height: 22,
                    color: lightGrey,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
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
