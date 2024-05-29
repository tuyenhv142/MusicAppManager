import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_dashboard/helpers/constants/style.dart';
import 'package:flutter_web_dashboard/viewmodels/user_controller.dart';
import 'package:flutter_web_dashboard/views/widgets/custom_text.dart';
import 'package:flutter_web_dashboard/views/widgets/header.dart';
import 'package:flutter_web_dashboard/views/widgets/header_phone.dart';
import 'package:flutter_web_dashboard/views/widgets/side_bar.dart';
import 'package:get/get.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final UserController controller = UserController();
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String? selectedArtistName;
  String? selectedArtistSource;

  void confirmDeleteUser(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this user?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                controller.deleteUser(id);
                Navigator.of(context).pop();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(UserController controller) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      controller.setImage(file.bytes);
    }
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
                      ? Header()
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
                                hintText: 'Search user by email',
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
                                    .collection('user')
                                    .orderBy("dateEnter", descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<QueryDocumentSnapshot> users =
                                        snapshot.data!.docs;
                                    if (searchQuery.isNotEmpty) {
                                      users = users.where((user) {
                                        String userName = user['email'] ?? '';
                                        return userName.toLowerCase().contains(
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
                                          label: Text("Full Name"),
                                          size: ColumnSize.L,
                                        ),
                                        DataColumn(
                                          label: Text('Email'),
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
                                      rows: users.map((user) {
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              CustomText(text: user.id),
                                            ),
                                            DataCell(
                                              CustomText(
                                                text: user['fullname'] ?? '',
                                              ),
                                            ),
                                            DataCell(
                                              CustomText(
                                                text: user['email'] ?? '',
                                              ),
                                            ),
                                            DataCell(
                                              CustomText(
                                                text: user['dateEnter'] ?? '',
                                              ),
                                            ),
                                            DataCell(
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: FadeInImage(
                                                  image: NetworkImage(
                                                    user['img'] ?? '',
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
                                                  // IconButton(
                                                  //   icon:
                                                  //       const Icon(Icons.edit),
                                                  //   onPressed: () {
                                                  //     controller
                                                  //             .fullnameController
                                                  //             .text =
                                                  //         user['fullname'];
                                                  //     controller.imgController
                                                  //         .text = user['img'];
                                                  //     controller.emailController
                                                  //         .text = user['email'];
                                                  //     addOrEditUser(
                                                  //         context: context,
                                                  //         type: 'Edit',
                                                  //         id: user.id);
                                                  //   },
                                                  // ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                    ),
                                                    onPressed: () {
                                                      confirmDeleteUser(
                                                          user.id);
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
            controller.fullnameController.clear();
            controller.setImage(null);
            controller.emailController.clear();
            controller.passwordController.clear();
            // selectedArtistName == controller.singerIdController.text;
            // selectedArtistSource == controller.sourceController.text;
            addOrEditUser(context: context, type: 'Add', id: '');
          },
          label: const Text("Add User"),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  addOrEditUser({BuildContext? context, String? type, String? id}) async {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
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
                  "$type User",
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
                  controller: controller.fullnameController,
                  decoration: InputDecoration(
                    hintText: 'Fullname',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fullname cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    hintText: " Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "123",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
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
                    child: Obx(() {
                      return controller.selectedImage.value != null
                          ? Image.memory(
                              controller.selectedImage.value!,
                              // fit: BoxFit.cover,
                            )
                          : const Center(child: Text('Tap to select an image'));
                    }),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ConstrainedBox(
                  constraints:
                      BoxConstraints.tightFor(width: Get.width, height: 40),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.formKey.currentState!.validate()) {
                        await controller.saveUpdateUser(id!, type);
                        setState(() {});
                      }
                    },
                    child: Text(type!),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
