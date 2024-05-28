import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/helpers/constants/style.dart';
import 'package:flutter_web_dashboard/viewmodels/admin_controller.dart';
import 'package:flutter_web_dashboard/views/widgets/custom_text.dart';

/// Example without datasource
class AvailableDriversTable extends StatefulWidget {
  const AvailableDriversTable({super.key});

  @override
  State<AvailableDriversTable> createState() => _AvailableDriversTableState();
}

class _AvailableDriversTableState extends State<AvailableDriversTable> {
  final AdminController controller = AdminController();

  // final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller.onInit();
    // searchController.addListener(() {
    //   setState(() {
    //     searchQuery = searchController.text;
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    controller.onClose();
  }

  void confirmDeleteAdmin(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content:
              const Text("Are you sure you want to delete this acount admin?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                controller.deleteAdmin(id);
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: active.withOpacity(.4), width: .5),
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
      margin: const EdgeInsets.only(bottom: 30, right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              SizedBox(
                width: 10,
              ),
              CustomText(
                text: "Acounts Admin",
                color: lightGrey,
                weight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(
            height: (56 * 7) + 20,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("admin")
                  .orderBy('dateEnter', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> admins = snapshot.data!.docs;
                  return DataTable2(
                    columnSpacing: 12,
                    dataRowHeight: 56,
                    headingRowHeight: 40,
                    horizontalMargin: 12,
                    minWidth: 600,
                    columns: const [
                      DataColumn2(
                        label: Text("Index"),
                        size: ColumnSize.L,
                      ),
                      // DataColumn2(
                      //   label: Text("Name"),
                      //   size: ColumnSize.L,
                      // ),
                      DataColumn(
                        label: Text('Email'),
                      ),
                      DataColumn(
                        label: Text('DateEnter'),
                      ),
                      DataColumn(
                        label: Text('Action'),
                      ),
                    ],
                    rows: admins.map((admin) {
                      return DataRow(
                        cells: [
                          DataCell(
                            CustomText(text: admin.id),
                          ),
                          // DataCell(
                          //   CustomText(
                          //     text: admin['name'] ?? '',
                          //   ),
                          // ),
                          DataCell(
                            CustomText(
                              text: admin['email'] ?? '',
                            ),
                          ),
                          DataCell(
                            CustomText(
                              text: admin['dateEnter'] ?? '',
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                // IconButton(
                                //   icon: const Icon(Icons.edit),
                                //   onPressed: () {
                                //     controller.nameController
                                //             .text =
                                //         playlist['name'];
                                //     controller.imgController
                                //         .text = playlist['img'];
                                //     controller.contentController
                                //             .text =
                                //         playlist['content'];
                                //     addOrEditPLaylist(
                                //       context: context,
                                //       type: 'Update',
                                //       id: playlist.id,
                                //     );
                                //   },
                                // ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    confirmDeleteAdmin(admin.id);
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
        ],
      ),
    );
  }
}
