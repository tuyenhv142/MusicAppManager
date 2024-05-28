import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/helpers/constants/style.dart';
import 'package:flutter_web_dashboard/routing/app_pages.dart';
import 'package:flutter_web_dashboard/views/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 100,
                padding: EdgeInsets.all(10),
                width: double.infinity,
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    SizedBox(width: width / 48),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Image.asset("assets/icons/logo.png"),
                    ),
                    const Flexible(
                      child: CustomText(
                        text: "Dash",
                        size: 20,
                        weight: FontWeight.bold,
                        color: active,
                      ),
                    ),
                    // SizedBox(width: width / 48),
                  ],
                ),
              ),
              // Divider(
              //   color: lightGrey.withOpacity(.1),
              // ),
              SizedBox(
                height: 80,
                child: Center(
                  child: InkWell(
                    onTap: () => Get.toNamed(Routes.HOME),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: 100,
                          child: Get.currentRoute == '/home'
                              ? const Icon(
                                  Icons.home,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.home_outlined,
                                  color: Colors.grey,
                                ),
                        ),
                        Get.currentRoute == '/home'
                            ? const Text(
                                "Home",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text(
                                "Home",
                                style: TextStyle(color: Colors.grey),
                              )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: Center(
                  child: InkWell(
                    onTap: () => Get.toNamed(Routes.TRACK),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: 100,
                          child: Get.currentRoute == '/track'
                              ? const Icon(
                                  Icons.track_changes,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.track_changes_outlined,
                                  color: Colors.grey,
                                ),
                        ),
                        Get.currentRoute == '/track'
                            ? const Text(
                                "Track",
                                style: TextStyle(color: Colors.black),
                              )
                            : const Text(
                                "Track",
                                style: TextStyle(color: Colors.grey),
                              )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: Center(
                  child: InkWell(
                    onTap: () => Get.toNamed(Routes.PLAYLIST),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: 100,
                          child: Get.currentRoute == '/playlist'
                              ? const Icon(
                                  Icons.playlist_add,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.playlist_add_outlined,
                                  color: Colors.grey,
                                ),
                        ),
                        Get.currentRoute == '/playlist'
                            ? const Text(
                                "Playlist",
                                style: TextStyle(color: Colors.black),
                              )
                            : const Text(
                                "Playlist",
                                style: TextStyle(color: Colors.grey),
                              )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: Center(
                  child: InkWell(
                    onTap: () => Get.toNamed(Routes.ARTIST),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: 100,
                          child: Get.currentRoute == '/artist'
                              ? const Icon(
                                  Icons.people,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.people_outline,
                                  color: Colors.grey,
                                ),
                        ),
                        Get.currentRoute == '/artist'
                            ? const Text(
                                "Artist",
                                style: TextStyle(color: Colors.black),
                              )
                            : const Text(
                                "Artist",
                                style: TextStyle(color: Colors.grey),
                              )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: Center(
                  child: InkWell(
                    onTap: () => Get.toNamed(Routes.BANNER),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: 100,
                          child: Get.currentRoute == '/banner'
                              ? const Icon(
                                  Icons.balance,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.balance_outlined,
                                  color: Colors.grey,
                                ),
                        ),
                        Get.currentRoute == '/banner'
                            ? const Text(
                                "Banner",
                                style: TextStyle(color: Colors.black),
                              )
                            : const Text(
                                "Banner",
                                style: TextStyle(color: Colors.grey),
                              )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: Center(
                  child: InkWell(
                    onTap: () => Get.toNamed(Routes.USER),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: 100,
                          child: Get.currentRoute == '/user'
                              ? const Icon(
                                  Icons.verified_user,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.verified_user_outlined,
                                  color: Colors.grey,
                                ),
                        ),
                        Get.currentRoute == '/user'
                            ? const Text(
                                "User",
                                style: TextStyle(color: Colors.black),
                              )
                            : const Text(
                                "User",
                                style: TextStyle(color: Colors.grey),
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
