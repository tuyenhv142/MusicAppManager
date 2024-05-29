import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/helpers/constants/style.dart';
import 'package:flutter_web_dashboard/viewmodels/banner_controller.dart';
import 'package:flutter_web_dashboard/views/widgets/custom_text.dart';
import 'package:flutter_web_dashboard/views/widgets/header.dart';
import 'package:flutter_web_dashboard/views/widgets/header_phone.dart';
import 'package:flutter_web_dashboard/views/widgets/side_bar.dart';
import 'package:get/get.dart';

class BannersPage extends StatefulWidget {
  const BannersPage({Key? key}) : super(key: key);

  @override
  State<BannersPage> createState() => _BannersPageState();
}

class _BannersPageState extends State<BannersPage> {
  final BannerController controller = Get.put(BannerController());
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

  Future<void> _pickImage(BannerController controller) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      controller.setImage(file.bytes);
    }
  }

  void confirmDeleteBanner(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this banner?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                controller.deleteBanner(id);
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
                      ? Header()
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
                              hintText: 'Search banner',
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
                                  .collection('banner')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<QueryDocumentSnapshot> banners =
                                      snapshot.data!.docs;
                                  if (searchQuery.isNotEmpty) {
                                    banners = banners.where((banner) {
                                      String bannerName = banner['title'] ?? '';
                                      return bannerName
                                          .toLowerCase()
                                          .contains(searchQuery.toLowerCase());
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
                                      DataColumn(
                                        label: Text('Title'),
                                      ),
                                      DataColumn(
                                        label: Text('Image'),
                                      ),
                                      DataColumn(
                                        label: Text('Actions'),
                                      ),
                                    ],
                                    rows: banners.map((banner) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            CustomText(text: banner.id),
                                          ),
                                          DataCell(
                                            CustomText(text: banner['title']),
                                          ),
                                          DataCell(
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: FadeInImage(
                                                image: NetworkImage(
                                                  banner['img'] ?? '',
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
                                                    controller.titleController
                                                        .text = banner['title'];
                                                    controller.setImage(null);
                                                    addOrEditBanner(
                                                      context: context,
                                                      type: 'Update',
                                                      id: banner.id,
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: () {
                                                    confirmDeleteBanner(
                                                        banner.id);
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
            controller.titleController.clear();
            addOrEditBanner(context: context, type: 'Add', id: '');
          },
          label: const Text("Add Banner"),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  addOrEditBanner({BuildContext? context, String? type, String? id}) {
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
                "$type Banner",
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
              GestureDetector(
                onTap: () => _pickImage(controller),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GetBuilder<BannerController>(
                    builder: (controller) {
                      return controller.selectedImage != null
                          ? Image.memory(controller.selectedImage!)
                          // fit: BoxFit.cover)
                          : const Center(child: Text('Tap to select an image'));
                    },
                  ),
                ),
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
                  onPressed: () async {
                    if (controller.formKey.currentState!.validate()) {
                      await controller.saveUpdateBanner(id!, type!);
                      controller.titleController.clear();
                      controller.setImage(null);
                      setState(() {});
                    }
                  },
                  child: Text(type == 'Add' ? 'Add' : 'Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
