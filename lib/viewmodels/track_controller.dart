import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/track.dart';
import 'package:get/get.dart';

class TrackController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  // TextEditingController imageController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController singerIdController = TextEditingController();
  var selectedImage = Rxn<Uint8List>();

  @override
  void onClose() {
    super.onClose();
    titleController.dispose();
    // imageController.dispose();
    sourceController.dispose();
    singerIdController.dispose();
  }

  void setImage(Uint8List? image) {
    selectedImage.value = image;
    update();
  }

  Future<String> uploadImage(Uint8List imageBytes) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('AdminTrackImage')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    UploadTask uploadTask = storageRef.putData(imageBytes);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> saveUpdateTrack(
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
    String downloadUrl = await uploadImage(selectedImage.value!);

    Track track = Track(
      // id: id,
      title: titleController.text,
      source: sourceController.text,
      singerId: singerIdController.text,
      image: downloadUrl,
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

  void deleteTracksBySinger(String singerId) async {
    CollectionReference trackColl = firestore.collection("track");

    try {
      QuerySnapshot querySnapshot =
          await trackColl.where('singerId', isEqualTo: singerId).get();

      WriteBatch batch = firestore.batch();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Get.back();
      Get.snackbar(
          "Tracks", "All tracks for the singer have been successfully deleted");
    } catch (e) {
      print("Error deleting tracks: $e");
      Get.snackbar("Error", "Failed to delete tracks for the singer");
    }
  }
}
