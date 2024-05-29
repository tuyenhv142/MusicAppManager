import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/banner.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  Uint8List? selectedImage;

  @override
  void onClose() {
    super.onClose();
    titleController.dispose();
  }

  void setImage(Uint8List? image) {
    selectedImage = image;
    update();
  }

  Future<String> uploadImage(Uint8List imageBytes) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('AdminBannerImage')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    UploadTask uploadTask = storageRef.putData(imageBytes);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> saveUpdateBanner(String id, String type) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();

    CollectionReference bannerColl = firestore.collection("banner");
    String downloadUrl = await uploadImage(selectedImage!);
    Banner1 banner = Banner1(
      title: titleController.text,
      img: downloadUrl,
    );
    setImage(null);
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
