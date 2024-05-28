import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/helpers/constants/style.dart';
import 'package:flutter_web_dashboard/routing/app_pages.dart';
import 'package:flutter_web_dashboard/views/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderPhone extends StatelessWidget {
  const HeaderPhone({
    super.key,
    required GlobalKey<ScaffoldState> drawerKey,
  }) : _drawerKey = drawerKey;

  final GlobalKey<ScaffoldState> _drawerKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _drawerKey.currentState!.openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Image.asset(
              "assets/icons/logo.png",
              width: 28,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const CustomText(
            text: "Dash",
            color: lightGrey,
            size: 20,
            weight: FontWeight.bold,
          ),
          Spacer(),
          Row(
            children: [
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
                        content: const Text("Are you sure want to log out?"),
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
        ],
      ),
    );
  }
}
