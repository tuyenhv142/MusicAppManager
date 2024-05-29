import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_web_dashboard/models/user.dart';

class UserController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController fullnameController = TextEditingController();
  // TextEditingController imgController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  CollectionReference userColl = FirebaseFirestore.instance.collection("user");
  var selectedImage = Rxn<Uint8List>();

  @override
  void onClose() {
    super.onClose();
    fullnameController.dispose();
    // imgController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void setImage(Uint8List? image) {
    selectedImage.value = image;
    update();
  }

  Future<String> uploadImage(Uint8List imageBytes, String id) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('UserImage')
        .child(id)
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    UploadTask uploadTask = storageRef.putData(imageBytes);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> saveUpdateUser(String id, String type) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    String dateEnter = DateTime.now().toIso8601String();
    String urlImage = await uploadImage(selectedImage.value!, id);

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
          img: urlImage,
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
          'img': urlImage,
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
      await FirebaseAuth.instance.currentUser?.delete();
      Get.back();
      Get.snackbar("User", "Successfully deleted");
    });
  }
}
