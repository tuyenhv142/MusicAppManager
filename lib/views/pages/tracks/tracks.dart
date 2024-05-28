import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/helpers/constants/style.dart';
import 'package:flutter_web_dashboard/viewmodels/track_controller.dart';
import 'package:flutter_web_dashboard/views/widgets/custom_text.dart';
import 'package:flutter_web_dashboard/views/widgets/header.dart';
import 'package:flutter_web_dashboard/views/widgets/header_phone.dart';
import 'package:flutter_web_dashboard/views/widgets/side_bar.dart';
import 'package:get/get.dart';

class TracksPage extends StatefulWidget {
  const TracksPage({super.key});

  @override
  State<TracksPage> createState() => _TracksPageState();
}

class _TracksPageState extends State<TracksPage> {
  final TrackController controller = TrackController();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String? selectedArtistName;
  String? selectedArtistSource;

  late firebase_storage.UploadTask uploadTask;
  String downloadURL = '';

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  Future<void> uploadFile() async {
    FileUploadInputElement uploadInput = FileUploadInputElement();

    uploadInput.accept = 'audio/mp3';

    uploadInput.click();

    await uploadInput.onChange.first;

    File file = uploadInput.files!.first;

    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';

    final ref = firebase_storage.FirebaseStorage.instance.ref().child(fileName);

    uploadTask = ref.putBlob(file);

    uploadTask.snapshotEvents.listen((event) {
      if (kDebugMode) {
        print(
            'Upload progress: ${(event.bytesTransferred / event.totalBytes) * 100}%');
      }
    });

    await uploadTask;

    downloadURL = await ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('music_sources').add({
      'name': fileName,
      'url': downloadURL,
      'uploadedAt': Timestamp.now(),
    });
    Get.snackbar("Upload", "Successfully");
  }

  void confirmDeleteTrack(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this track?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                controller.deleteTrack(id);
                Navigator.of(context).pop();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    controller.onInit();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.onClose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _drawerKey,
      drawer: SideBar(width: width),
      body: Row(
        children: [
          context.isPhone
              ? const SizedBox()
              : Expanded(
                  flex: 2,
                  child: SideBar(width: width),
                ),
          Expanded(
            flex: 15,
            child: Container(
              padding: context.isPhone
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(right: 15),
              child: Column(
                children: [
                  !context.isPhone
                      ? const Header()
                      : HeaderPhone(drawerKey: _drawerKey),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: !context.isPhone
                          ? const EdgeInsets.only(right: 25.0)
                          : const EdgeInsets.all(0),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: 'Search tracks',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: active.withOpacity(.4),
                                width: .5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 6),
                                  color: lightGrey.withOpacity(.1),
                                  blurRadius: 12,
                                )
                              ],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 30),
                            child: SizedBox(
                              height: (60 * 7) + 200,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('track')
                                    .orderBy("dateEnter", descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<QueryDocumentSnapshot> tracks =
                                        snapshot.data!.docs;
                                    if (searchQuery.isNotEmpty) {
                                      tracks = tracks.where((track) {
                                        String trackTitle =
                                            track['title'] ?? '';
                                        return trackTitle
                                            .toLowerCase()
                                            .contains(
                                                searchQuery.toLowerCase());
                                      }).toList();
                                    }
                                    return DataTable2(
                                      columnSpacing: 12,
                                      dataRowHeight: 60,
                                      headingRowHeight: 40,
                                      horizontalMargin: 12,
                                      minWidth: 600,
                                      columns: const [
                                        DataColumn2(
                                          label: Text("Index"),
                                          size: ColumnSize.L,
                                        ),
                                        DataColumn2(
                                          label: Text("Track Name"),
                                          size: ColumnSize.L,
                                        ),
                                        DataColumn(
                                          label: Text('Artist'),
                                        ),
                                        DataColumn(
                                          label: Text('Date Enter'),
                                        ),
                                        DataColumn(
                                          label: Text('Avatar'),
                                        ),
                                        DataColumn(
                                          label: Text('Actions'),
                                        ),
                                      ],
                                      rows: tracks.map((track) {
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              CustomText(text: track.id),
                                            ),
                                            DataCell(
                                              CustomText(
                                                text: track['title'] ?? '',
                                              ),
                                            ),
                                            DataCell(
                                              CustomText(
                                                text: track['singerId'] ?? '',
                                              ),
                                            ),
                                            DataCell(
                                              CustomText(
                                                text: track['dateEnter'] ?? '',
                                              ),
                                            ),
                                            DataCell(
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: FadeInImage(
                                                  image: NetworkImage(
                                                    track['image'] ?? '',
                                                  ),
                                                  width: 55,
                                                  height: 55,
                                                  fit: BoxFit.cover,
                                                  placeholder: const AssetImage(
                                                    "assets/icons/spinner100.gif",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon:
                                                        const Icon(Icons.edit),
                                                    onPressed: () {
                                                      controller.titleController
                                                              .text =
                                                          track['title'];
                                                      controller.imageController
                                                              .text =
                                                          track['image'];
                                                      controller
                                                              .singerIdController
                                                              .text =
                                                          track['singerId'];
                                                      controller
                                                              .sourceController
                                                              .text =
                                                          track['source'];
                                                      addOrEditTrack(
                                                          context: context,
                                                          type: 'Edit',
                                                          id: track.id);
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                    ),
                                                    onPressed: () {
                                                      confirmDeleteTrack(
                                                          track.id);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: const Alignment(0.95, 0.95),
        child: FloatingActionButton.extended(
          onPressed: () {
            controller.titleController.clear();
            controller.sourceController.clear();
            // controller.singerIdController.clear();
            // controller.imageController.clear();
            // selectedArtistName == controller.singerIdController.text;
            // selectedArtistSource == controller.sourceController.text;
            addOrEditTrack(context: context, type: 'Add', id: '');
          },
          label: const Text("Add Track"),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  addOrEditTrack({BuildContext? context, String? type, String? id}) async {
    if (id!.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('track')
          .doc(id)
          .get()
          .then((doc) {
        if (doc.exists) {
          setState(() {
            selectedArtistName = doc['singerId'];
            selectedArtistSource = doc['source'];
            // controller.sourceController.text = doc['source'];
            // controller.singerIdController.text = selectedArtistName!;
          });
        }
      });
    }
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Text(
                "$type Track",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('music_sources')
                    .orderBy('uploadedAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                    List<DropdownMenuItem<String>> dropdownItems =
                        documents.map((doc) {
                      return DropdownMenuItem<String>(
                        value: doc['url'],
                        child: Text(doc['name']),
                      );
                    }).toList();

                    return DropdownButtonFormField(
                      itemHeight: 48,
                      items: dropdownItems,
                      onChanged: (newValue) {
                        setState(() {
                          selectedArtistSource = newValue.toString();
                          controller.sourceController.text =
                              selectedArtistSource!;
                        });
                      },
                      value: selectedArtistSource,
                      hint: const Text('Select a soucre music'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ConstrainedBox(
                constraints:
                    BoxConstraints.tightFor(width: Get.width, height: 40),
                child: ElevatedButton(
                  onPressed: uploadFile,
                  child: const Text('Upload MP3 File'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('singer')
                    .orderBy('name')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<DropdownMenuItem<String>> dropdownItems =
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return DropdownMenuItem<String>(
                        value: document.id,
                        child: Text(document['name']),
                      );
                    }).toList();

                    return DropdownButtonFormField(
                      itemHeight: 48,
                      items: dropdownItems,
                      onChanged: (newValue) {
                        setState(() {
                          selectedArtistName = newValue.toString();
                          controller.singerIdController.text =
                              selectedArtistName!;
                        });
                      },
                      value: selectedArtistName,
                      hint: const Text('Select a Artist'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: controller.imageController,
                decoration: InputDecoration(
                  hintText: 'Source Avatar',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Avatar cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ConstrainedBox(
                constraints:
                    BoxConstraints.tightFor(width: Get.width, height: 40),
                child: ElevatedButton(
                  onPressed: () {
                    controller.saveUpdateTrack(
                      id,
                      type,
                    );
                    controller.titleController.clear();
                    controller.sourceController.clear();
                    // controller.singerIdController.clear();
                    // controller.imageController.clear();
                    setState(() {});
                  },
                  child: Text(type!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
