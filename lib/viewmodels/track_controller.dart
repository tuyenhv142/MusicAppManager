import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/track.dart';
import 'package:get/get.dart';

class TrackController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController singerIdController = TextEditingController();

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
    titleController.dispose();
    imageController.dispose();
    sourceController.dispose();
    singerIdController.dispose();
  }

  void saveUpdateTrack(
    String id,
    String type,
  ) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    CollectionReference trackColl = firestore.collection("track");
    String dateEnter = DateTime.now().toIso8601String();

    Track track = Track(
      // id: id,
      title: titleController.text,
      source: sourceController.text,
      singerId: singerIdController.text,
      image: imageController.text,
      dateEnter: dateEnter,
    );

    try {
      if (id.isEmpty) {
        await trackColl.add(track.toJson());
      } else {
        await trackColl.doc(id).update(track.toJson());
      }
      Get.back();
      Get.snackbar("Track", "Successfully $type");
    } catch (error) {
      Get.snackbar("Track", "Error $type");
    }
  }

  void deleteTrack(String id) async {
    CollectionReference trackColl = firestore.collection("track");

    await trackColl.doc(id).delete().whenComplete(() {
      Get.back();
      Get.snackbar("Track", "Successfully deleted");
    });
  }
}
