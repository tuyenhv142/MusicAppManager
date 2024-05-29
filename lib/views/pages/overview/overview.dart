import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_web_dashboard/helpers/reponsiveness.dart';
import 'package:flutter_web_dashboard/viewmodels/admin_controller.dart';
import 'package:flutter_web_dashboard/views/pages/overview/widgets/overview_cards_large.dart';
import 'package:flutter_web_dashboard/views/pages/overview/widgets/overview_cards_medium.dart';
import 'package:flutter_web_dashboard/views/pages/overview/widgets/revenue_section_large.dart';
import 'package:flutter_web_dashboard/views/pages/overview/widgets/available_drivers_table.dart';
import 'package:flutter_web_dashboard/views/pages/overview/widgets/overview_cards_small.dart';

import 'package:flutter_web_dashboard/views/widgets/header.dart';
import 'package:flutter_web_dashboard/views/widgets/header_phone.dart';
import 'package:flutter_web_dashboard/views/widgets/side_bar.dart';
import 'package:get/get.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

import 'widgets/revenue_section_small.dart';

class HomePage extends StatefulWidget {
  // const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final AdminController controller = AdminController();
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  List<_ChartData> chartData = <_ChartData>[];

  @override
  void initState() {
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue =
        await FirebaseFirestore.instance.collection("track").get();
    List<_ChartData> list = snapShotsValue.docs
        .map(
          (e) => _ChartData(
              x: DateTime.fromMillisecondsSinceEpoch(
                e.data()['x'].millisecondsSinceEpoch,
              ),
              y: e.data()['dateEnter']),
        )
        .toList();
    setState(() {
      chartData = list;
    });
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
            child: Column(
              children: [
                !context.isPhone
                    ? Header()
                    : HeaderPhone(drawerKey: _drawerKey),
                Expanded(
                  child: ListView(
                    children: [
                      if (ResponsiveWidget.isLargeScreen(context) ||
                          ResponsiveWidget.isMediumScreen(context))
                        if (ResponsiveWidget.isCustomSize(context))
                          const OverviewCardsMediumScreen()
                        else
                          const OverviewCardsLargeScreen()
                      else
                        const OverviewCardsSmallScreen(),
                      if (!ResponsiveWidget.isSmallScreen(context))
                        // SfCartesianChart(
                        //   primaryXAxis: DateTimeAxis(),
                        //   primaryYAxis: NumericAxis(),
                        //   series: <ChartSeries<_ChartData, DateTime>>[
                        //     LineSeries<_ChartData, DateTime>(
                        //       dataSource: chartData,
                        //       xValueMapper: (_ChartData data, _) => data.x,
                        //       yValueMapper: (_ChartData data, _) => data.y,
                        //     )
                        //   ],
                        // )
                        const RevenueSectionLarge()
                      else
                        const RevenueSectionSmall(),
                      const AvailableDriversTable(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: const Alignment(0.95, 0.95),
        child: FloatingActionButton.extended(
          onPressed: () {
            controller.nameController.clear();
            controller.emailController.clear();
            addAdmin(context: context, id: '');
          },
          label: const Text("Add Admin"),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  addAdmin({BuildContext? context, String? id}) {
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
              const Text(
                "Add Admin",
                style: TextStyle(
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
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: controller.emailController,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "123",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
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
                      await controller.saveOrUpdateAdmin(id!);
                    }
                  },
                  child: const Text('Add'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData({this.x, this.y});
  final DateTime? x;
  final int? y;
}
