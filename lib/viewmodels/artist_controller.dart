import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/artist.dart';
import 'package:get/get.dart';

class ArtistController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController imgController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    imgController.dispose();
  }

  void saveUpdateArtist(String id, String type) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();

    CollectionReference artistColl = firestore.collection("singer");
    String modifiedId = nameController.text.replaceAll(' ', '').toUpperCase();
    String dateEnter = DateTime.now().toIso8601String();

    Artist artist = Artist(
      id: id.isEmpty ? modifiedId : id,
      name: nameController.text,
      img: imgController.text,
      dateEnter: dateEnter,
    );

    try {
      if (id.isEmpty) {
        await artistColl.doc(modifiedId).set(artist.toJson());
      } else {
        await artistColl.doc(id).update(artist.toJson());
      }
      Get.back();
      Get.snackbar("Artist", "Successfully $type");
    } catch (error) {
      Get.snackbar("Artist", "Error $type");
    }
  }

  void deleteArtist(String id) async {
    CollectionReference artistColl = firestore.collection("singer");

    await artistColl.doc(id).delete().whenComplete(() {
      Get.back();
      Get.snackbar("Artist", "Successfully deleted");
    });
  }
}
