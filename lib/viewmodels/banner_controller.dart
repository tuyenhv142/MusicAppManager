import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/banner.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController imgController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    titleController.dispose();
    imgController.dispose();
  }

  void saveUpdateBanner(String id, String type) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();

    CollectionReference bannerColl = firestore.collection("banner");

    Banner1 banner = Banner1(
      id: id,
      title: titleController.text,
      img: imgController.text,
    );

    try {
      if (id.isEmpty) {
        await bannerColl.add(banner.toJson());
      } else {
        await bannerColl.doc(id).update(banner.toJson());
      }
      Get.back();
      Get.snackbar("Banner", "Successfully $type");
    } catch (error) {
      Get.snackbar("Banner", "Error $type");
    }
  }

  void deleteBanner(String id) async {
    CollectionReference bannerColl = firestore.collection("banner");

    await bannerColl.doc(id).delete().whenComplete(() {
      Get.back();
      Get.snackbar("Banner", "Successfully deleted");
    });
  }
}
