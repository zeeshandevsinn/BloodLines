// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/dropDownClass.dart';
import 'package:bloodlines/View/Pedigree/Data/pedigreeController.dart';
import 'package:bloodlines/View/Pedigree/View/dataTable.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Pedigree extends StatefulWidget {
  @override
  State<Pedigree> createState() => _PedigreeState();
}

class _PedigreeState extends State<Pedigree> {
  PedigreeController controller = Get.put(PedigreeController());

  RxInt tab = 0.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getAllPedigrees();
    controller.getMyPedigrees();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TabBar(
                  padding: EdgeInsets.zero,
                  unselectedLabelColor: DynamicColors.textColor,
                  unselectedLabelStyle: poppinsRegular(fontSize: 12),
                  labelStyle: poppinsRegular(fontSize: 12),
                  labelColor: DynamicColors.primaryColorRed,
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (a) {
                    tab.value = a;
                  },
                  indicatorPadding: EdgeInsets.only(
                      right: MediaQuery
                          .of(context)
                          .size
                          .width / 3, left: 40),
                  indicatorColor: DynamicColors.primaryColorRed,
                  labelPadding: EdgeInsets.zero,
                  // indicator:
                  //     BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  indicatorWeight: 3,
                  automaticIndicatorColorAdjustment: true,
                  tabs: [
                    Tab(
                      text: "My Pedigrees            ",
                    ),
                    Tab(
                      text: "Pedigree Database",
                    ),
                  ]),
              SizedBox(
                height: 20,
              ),
              Obx(() {
                return IndexedStack(
                  index: tab.value,
                  children: [
                    DataTableClass(myPedigree: true),
                    DataTableClass(),
                  ],
                );
              }),
              SizedBox(
                height: kToolbarHeight + 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataTableClass extends StatelessWidget {
  DataTableClass({
    Key? key,
    this.myPedigree = false,
    this.fromTimeline = false,
  }) : super(key: key);

  final bool myPedigree;
  final bool fromTimeline;
  PedigreeController controller = Get.find();

  List<String> daysList = [
    "7 days",
    "14 days",
    "30 days",
    "6 months",
    "1 year",
    "All time",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fromTimeline == true
              ? SizedBox.shrink()
              : SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height / 3.7,
            child: InkWell(
              onTap: () {
                Get.toNamed(Routes.addNewPedigree, arguments: {
                  "sourceId": 0,
                });
              },
              child: Container(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  // color: Colors.black,

                  boxShadow: [
                    BoxShadow(blurStyle: BlurStyle.solid,
                        // color: Colors.black,
                        blurRadius: 20.0,
                        spreadRadius: 3
                    ),
                  ],
                ),
                child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
                  elevation: 15,
                  margin: EdgeInsets.zero,

                  child: ClipRRect(
                    child: SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 3.7,
                      width: double.infinity,
                      child: Image.asset(
                        "assets/newPedigree.png",
                        fit: BoxFit.cover,
                        // height: 23,
                        // color: DynamicColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          fromTimeline == true
              ? SizedBox.shrink()
              : SizedBox(
            height: 20,
          ),
          myPedigree == true
              ? Container()
              : Row(
            children: [
              Expanded(
                flex: 7,
                child: Text(
                  "Most Viewed in the Last",
                  style: montserratBold(fontSize: 20),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 4,
                child: DropDownClass(
                  hint: "7 Days",
                  list: daysList,
                  validationError: 'days',
                  listener: (value) {
                    if (value == "All time") {
                      controller.getAllPedigrees();
                    } else {
                      switchValue(value);
                    }
                  },
                ),
              ),
            ],
          ),
          fromTimeline == true
              ? SizedBox.shrink()
              : SizedBox(
            height: 20,
          ),
          GetBuilder<PedigreeController>(builder: (controller) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(color: DynamicColors.accentColor)),
              child: GestureDetector(
                onTap: () {
                  // Get.toNamed(Routes.pedigreeTree);
                },
                child: PaginatedDataTableCustom(
                  footer: false,
                  onTap: () {},
                  columnSpacing: 10,
                  dataRowHeight: 45,
                  columns: <DataColumn>[
                    DataColumn(label: Text("Dog Name")),
                    DataColumn(label: Text("Sire")),
                    DataColumn(label: Text("Dam")),
                  ],
                  source: DataSource(
                      context,
                      myPedigree == true ? controller.myCells : controller
                          .cells,
                      myPedigree == true ? controller.myCells : controller
                          .cells),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void switchValue(value) {
    switch (value) {
      case "7 days":
        controller.getAllPedigrees(url: "most-viewed-pedigree?days=7");
        break;
      case "14 days":
        controller.getAllPedigrees(url: "most-viewed-pedigree?days=14");
        break;
      case "30 days":
        controller.getAllPedigrees(url: "most-viewed-pedigree?days=30");
        break;
      case "6 months":
        controller.getAllPedigrees(url: "most-viewed-pedigree?days=180");
        break;
      default:
        controller.getAllPedigrees(url: "most-viewed-pedigree?days=364");
        break;
    }
  }
}
