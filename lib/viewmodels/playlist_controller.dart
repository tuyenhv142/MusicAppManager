import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/playlist.dart';
import 'package:get/get.dart';

class PlaylistController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  var tracks = [].obs;
  var selectedTracks = <String>[].obs;
  var selectedImage = Rxn<Uint8List>();

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    contentController.dispose();
  }

  void setImage(Uint8List? image) {
    selectedImage.value = image;
    update();
  }

  Future<String> uploadImage(Uint8List imageBytes) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('AdminPlaylistImage')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    UploadTask uploadTask = storageRef.putData(imageBytes);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> saveUpdatePlaylist(String id, String type) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();

    CollectionReference playlistColl = firestore.collection("playlist");
    String dateEnter = DateTime.now().toIso8601String();
    String downloadUrl = await uploadImage(selectedImage.value!);

    Playlist playlist = Playlist(
      name: nameController.text,
      img: downloadUrl,
      content: contentController.text,
      dateEnter: dateEnter,
      tracks: selectedTracks.toList(),
    );

    try {
      if (id.isEmpty) {
        await playlistColl.add(playlist.toJson());
      } else {
        await playlistColl.doc(id).update(playlist.toJson());
      }
      Get.back();
      Get.snackbar("Playlist", "Successfully $type");
    } catch (error) {
      Get.snackbar("Playlist", "Error $type");
    }
  }

  void deletePlaylist(String id) async {
    CollectionReference playlistColl = firestore.collection("playlist");

    await playlistColl.doc(id).delete().whenComplete(() {
      Get.back();
      Get.snackbar("Playlist", "Successfully deleted");
    });
  }

  Future<List<String>> getTrackNames(List<String> trackIds) async {
    List<String> trackNames = [];
    for (String trackId in trackIds) {
      DocumentSnapshot track = await FirebaseFirestore.instance
          .collection('track')
          .doc(trackId)
          .get();
      if (track.exists) {
        trackNames.add(track['title']);
      }
    }
    return trackNames;
  }

  void fetchTracks(List<String> currentTrackIds) async {
    var snapshot = await FirebaseFirestore.instance.collection('track').get();
    tracks.value = snapshot.docs;
    selectedTracks.value = currentTrackIds;
  }

  void updatePlaylistTracks(String playlistId) async {
    await FirebaseFirestore.instance
        .collection('playlist')
        .doc(playlistId)
        .update({
      'tracks': selectedTracks.toList(),
    });
    selectedTracks.clear();
  }
}
