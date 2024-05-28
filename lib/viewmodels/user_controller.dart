import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_web_dashboard/models/user.dart';

class UserController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController imgController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  CollectionReference userColl = FirebaseFirestore.instance.collection("user");

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    fullnameController.dispose();
    imgController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void saveUpdateUser(String id, String type) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    String dateEnter = DateTime.now().toIso8601String();

    try {
      if (id.isEmpty) {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        User1 user = User1(
          idUser: userCredential.user!.uid,
          fullname: fullnameController.text,
          email: emailController.text,
          img: imgController.text,
          dateEnter: dateEnter,
          favoriteArtistId: [],
          favoritePlaylistId: [],
          favoriteTrackId: [],
        );

        await userColl.doc(user.idUser).set(user.toJson());
      } else {
        await userColl.doc(id).update({
          'fullname': fullnameController.text,
          'email': emailController.text,
          'img': imgController.text,
          'dateEnter': dateEnter,
        });
      }
      Get.back();
      Get.snackbar("User", "Successfully $type");
    } catch (error) {
      Get.snackbar("User", "Error $type");
    }
  }

  void deleteUser(String id) async {
    await userColl.doc(id).delete().whenComplete(() async {
      // await FirebaseAuth.instance.currentUser?.delete();
      Get.back();
      Get.snackbar("User", "Successfully deleted");
    });
  }
}
