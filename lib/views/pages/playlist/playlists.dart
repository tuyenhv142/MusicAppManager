import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/helpers/constants/style.dart';
import 'package:flutter_web_dashboard/viewmodels/playlist_controller.dart';
import 'package:flutter_web_dashboard/views/widgets/custom_text.dart';
import 'package:flutter_web_dashboard/views/widgets/header.dart';
import 'package:flutter_web_dashboard/views/widgets/header_phone.dart';
import 'package:flutter_web_dashboard/views/widgets/side_bar.dart';
import 'package:get/get.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({Key? key}) : super(key: key);

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  final PlaylistController controller = PlaylistController();
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

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

  void confirmDeletePlaylist(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this playlist?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                controller.deletePlaylist(id);
                Navigator.of(context).pop();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void showTrackSelectionDialog(
      BuildContext context, String playlistId, List<String> currentTrackIds) {
    controller.fetchTracks(currentTrackIds);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Tracks"),
          content: Obx(() {
            if (controller.tracks.isEmpty) {
              return const CircularProgressIndicator();
            } else {
              return SingleChildScrollView(
                child: ListBody(
                  children: controller.tracks.map((track) {
                    return Obx(() {
                      bool isSelected =
                          controller.selectedTracks.contains(track.id);
                      return CheckboxListTile(
                        value: isSelected,
                        title: Text(track['title']),
                        onChanged: (bool? value) {
                          if (value == true) {
                            controller.selectedTracks.add(track.id);
                          } else {
                            controller.selectedTracks.remove(track.id);
                          }
                        },
                      );
                    });
                  }).toList(),
                ),
              );
            }
          }),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                controller.updatePlaylistTracks(playlistId);
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
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
                  Expanded(
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
                              hintText: 'Search playlist',
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
                                  .collection('playlist')
                                  .orderBy("dateEnter", descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<QueryDocumentSnapshot> playlists =
                                      snapshot.data!.docs;
                                  if (searchQuery.isNotEmpty) {
                                    playlists = playlists.where((playlist) {
                                      String playlistName =
                                          playlist['name'] ?? '';
                                      return playlistName
                                          .toLowerCase()
                                          .contains(searchQuery.toLowerCase());
                                    }).toList();
                                  }
                                  return DataTable2(
                                    columnSpacing: 12,
                                    dataRowHeight: 70,
                                    headingRowHeight: 40,
                                    horizontalMargin: 12,
                                    minWidth: 600,
                                    columns: const [
                                      DataColumn2(
                                        label: Text("Index"),
                                        size: ColumnSize.L,
                                      ),
                                      DataColumn2(
                                        label: Text("Playlist Name"),
                                        size: ColumnSize.L,
                                      ),
                                      DataColumn2(
                                        label: Text("Content"),
                                        size: ColumnSize.L,
                                      ),
                                      DataColumn2(
                                        label: Text("Track"),
                                        size: ColumnSize.L,
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
                                    rows: playlists.map((playlist) {
                                      List<String> trackIds = List<String>.from(
                                          playlist['tracks'] ?? []);
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            CustomText(text: playlist.id),
                                          ),
                                          DataCell(
                                            CustomText(
                                              text: playlist['name'] ?? '',
                                            ),
                                          ),
                                          DataCell(
                                            CustomText(
                                              text: playlist['content'] ?? '',
                                            ),
                                          ),
                                          DataCell(
                                            FutureBuilder<List<String>>(
                                              future: controller
                                                  .getTrackNames(trackIds),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                    'Error: ${snapshot.error}',
                                                  );
                                                } else {
                                                  return CustomText(
                                                    text: snapshot.data!
                                                        .join(', '),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          DataCell(
                                            CustomText(
                                              text: playlist['dateEnter'] ?? '',
                                            ),
                                          ),
                                          DataCell(
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: FadeInImage(
                                                image: NetworkImage(
                                                  playlist['img'] ?? '',
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
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () {
                                                    controller.nameController
                                                            .text =
                                                        playlist['name'];
                                                    controller.imgController
                                                        .text = playlist['img'];
                                                    controller.contentController
                                                            .text =
                                                        playlist['content'];
                                                    addOrEditPLaylist(
                                                      context: context,
                                                      type: 'Update',
                                                      id: playlist.id,
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: () {
                                                    confirmDeletePlaylist(
                                                        playlist.id);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.add),
                                                  onPressed: () {
                                                    showTrackSelectionDialog(
                                                      context,
                                                      playlist.id,
                                                      List<String>.from(
                                                          playlist['tracks'] ??
                                                              []),
                                                    );
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
            controller.nameController.clear();
            controller.imgController.clear();
            controller.contentController.clear();
            addOrEditPLaylist(context: context, type: 'Add', id: '');
          },
          label: const Text("Add Playlist"),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  addOrEditPLaylist({BuildContext? context, String? type, String? id}) {
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
                "$type Playlist",
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
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: controller.nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: controller.contentController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Content cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Source Avatar',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: controller.imgController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Source Avatar cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  width: Get.width,
                  height: 40,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      controller.saveUpdatePlaylist(
                        id!,
                        type!,
                      );
                      controller.nameController.clear();
                      controller.imgController.clear();
                      controller.contentController.clear();
                      setState(() {});
                    }
                  },
                  child: Text(type == 'Add' ? 'Add' : 'Update'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
