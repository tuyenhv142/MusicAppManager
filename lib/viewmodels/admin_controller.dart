import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/admin.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  CollectionReference adminColl =
      FirebaseFirestore.instance.collection("admin");

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login(String email, String password) async {
    try {
      final query =
          await adminColl.where('email', isEqualTo: email).limit(1).get();
      if (query.docs.isNotEmpty) {
        var adminDoc = query.docs.first;
        var storedPassword = adminDoc.get("password");

        if (password == storedPassword) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('id', adminDoc.id);
          await prefs.setString('name', adminDoc.get('name'));
          await prefs.setString('email', adminDoc.get('email'));
          await prefs.setString('password', adminDoc.get('password'));

          Get.toNamed("/home");
          Get.snackbar("Admin", "Login Successful");
        } else {
          Get.snackbar("Admin", "Incorrect password. Please try again.");
        }
      } else {
        Get.snackbar("Admin", "Email not found. Please try again.");
      }
    } catch (error) {
      Get.snackbar("Admin", "Error: $error");
    }
  }

  void saveOrUpdateAdmin(String id, String type) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();

    String dateEnter = DateTime.now().toIso8601String();

    Admin admin = Admin(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      dateEnter: dateEnter,
    );
    try {
      await adminColl.add(admin.toJson());
      Get.back();
      Get.snackbar("Admin", "Successfully $type");
    } catch (error) {
      Get.snackbar("Admin", "Error: $error");
    }
  }

  void deleteAdmin(String id) async {
    try {
      await adminColl.doc(id).delete();
      Get.back();
      Get.snackbar("Admin", "Successfully deleted");
    } catch (error) {
      Get.snackbar("Admin", "Error: $error");
    }
  }
}
