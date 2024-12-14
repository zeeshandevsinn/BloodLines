// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:developer';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/CustomAlert.dart';
import 'package:bloodlines/Components/Dummy.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Pedigree/Data/pedigreeController.dart';
import 'package:bloodlines/View/Pedigree/Model/pedigreeSearchModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:get/get.dart' as getx;
import 'package:graphview/GraphView.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class PedigreeTree extends StatefulWidget {
  @override
  State<PedigreeTree> createState() => _PedigreeTreeState();
}

class _PedigreeTreeState extends State<PedigreeTree> {
  int id = getx.Get.arguments["id"];

  PedigreeController controller = getx.Get.find();

  final getx.RxInt _current = 0.obs;

  Future<bool> onWillPop() async {
    controller.singlePedigreeModel = null;
    getx.Get.back();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: AppBarWidgets(
              isCardType: true,
              onTap: () {
                controller.singlePedigreeModel = null;
                onWillPop();
              },
            ),
            title: Text(
              "Four Generation Pedigree",
              style: montserratBold(color: DynamicColors.textColor),
            ),
          ),
          body: getx.GetBuilder<PedigreeController>(builder: (controller) {
            if (controller.singlePedigreeModel == null) {
              return Center(
                child: LoaderClass(),
              );
            }
            return LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Divider(
                          color: DynamicColors.accentColor,
                        ),
                        upperWidget(context, controller),
                        SizedBox(
                          height: 0,
                        ),
                        sireGraph.edges.isEmpty && sireGraph.nodes.isEmpty
                            ? Container()
                            : Expanded(
                                flex: 7,
                                // flex: 6,
                                // height: MediaQuery.of(context).size.height / 3,
                                // width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, bottom: 10, top: 80),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Center(
                                          child: CustomPaint(
                                                      size: Size(200, 200),
                                                      painter: MyPainter(),
                                                    ),
                                        ),
                                      ),
          //                         child: InteractiveViewer(
          //                             constrained: false,

          //                             alignment: Alignment.centerLeft,
          //                             boundaryMargin: EdgeInsets.all(8),
          //                             minScale: 1,
          //                             maxScale: 1,
          //                             child: Container(
          //                               margin:
          //                                   EdgeInsets.only(top: 0, right: 10),
          //                                   child:  CustomPaint(
          //   size: Size(200, 200),
          //   painter: MyPainter(),
          // ),
          //                               // child: GraphView(
          //                               //   graph: sireGraph,
          //                               //   algorithm: BuchheimWalkerAlgorithm(
          //                               //       sireBuilder,
          //                               //       TreeEdgeRenderer(sireBuilder)),
          //                               //   paint: Paint()
          //                               //     ..color =
          //                               //         DynamicColors.primaryColorRed
          //                               //     ..strokeWidth = 1
          //                               //     ..style = PaintingStyle.stroke,
          //                               //   builder: (Node node) {
          //                               //     print(node.position);
          //                               //     // return SizedBox();
          //                               //     // I can decide what widget should be shown here based on the id
          //                               //     if (node.key!.value != null) {
          //                               //       var a = node.key!.value as int;
          //                               //       return rectangleWidget(a);
          //                               //     } else {
          //                               //       return rectangleWidget(-1);
          //                               //     }
          //                               //   },
          //                               // ),
                                      
          //                             )),
                                ),
                              ),
                        damGraph.edges.isEmpty && damGraph.nodes.isEmpty
                            ? Container()
                            : Expanded(
                                flex: 7,
                                child: InteractiveViewer(
                                    constrained: false,
                                    panAxis: PanAxis.free,
                                    alignment: Alignment.center,
                                    boundaryMargin: EdgeInsets.all(8),
                                    minScale: 1,
                                    maxScale: 1,
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 0, right: 10),
                                      child: GraphView(
                                        graph: damGraph,

                                        // animated: true,
                                        algorithm: BuchheimWalkerAlgorithm(
                                            builder, TreeEdgeRenderer(builder)),
                                        paint: Paint()
                                          ..color =
                                              DynamicColors.primaryColorRed
                                          ..strokeWidth = 1
                                          ..style = PaintingStyle.stroke,
                                        builder: (Node node) {
                                          print(node.position);
                                          // return SizedBox();
                                          // I can decide what widget should be shown here based on the id
                                          if (node.key!.value != null) {
                                            var a = node.key!.value as int;
                                            return rectangleWidget(a);
                                          } else {
                                            return rectangleWidget(-1);
                                          }
                                          // return Container();
                                        },
                                      ),
                                    )),
                              ),
                      ],
                    ),
                  ),
                ),
              );
            });
          })),
    );
  }

  IntrinsicHeight upperWidget(
      BuildContext context, PedigreeController controller) {
    return IntrinsicHeight(
      // height: MediaQuery.of(context).size.height / 6,
      child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                  color: DynamicColors.primaryColorRed,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )),
            ),
            SizedBox(
              width: 10,
            ),
            carouselSlider(context),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 30,
                              height: 30,
                              child: OptimizedCacheImage(
                                imageUrl:controller.singlePedigreeModel!.data!
                                    .creator == null?dummyProfile: controller.singlePedigreeModel!.data!
                                    .creator!.profile!.profileImage!,
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.singlePedigreeModel!.data!
                                    .creator == null?"Deleted User":    controller.singlePedigreeModel!.data!.creator!
                                    .profile!.fullname!,
                                style: poppinsRegular(fontSize: 13),
                              ),
                              Text(
                                controller.singlePedigreeModel!.data!
                                    .creator == null?"":   controller.singlePedigreeModel!.data!.creator!
                                        .profile!.country ??
                                    "",
                                style: poppinsRegular(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w100,
                                    color: DynamicColors.accentColor),
                              ),
                            ],
                          ),
                          Icon(
                            Elusive.share,
                            color: DynamicColors.primaryColorRed,
                            size: 15,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Dog Name :",
                            style: montserratSemiBold(fontSize: 13),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              "${controller.singlePedigreeModel!.data!.fullName}",
                              style: montserratRegular(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // SizedBox(
                      //   height: 50,
                      //   width: MediaQuery.of(context)
                      //           .size
                      //           .width /
                      //       1.8,
                      //   child: GridView.builder(
                      //       itemCount: 4,
                      //       shrinkWrap: true,
                      //       padding: EdgeInsets.zero,
                      //       gridDelegate:
                      //           SliverGridDelegateWithFixedCrossAxisCount(
                      //               crossAxisCount: 2,
                      //               childAspectRatio: 5),
                      //       itemBuilder: (context, index) {
                      //         return Text(
                      //           gridItems[index],
                      //           style: montserratSemiBold(
                      //               fontSize: 10,
                      //               color: DynamicColors
                      //                   .blueColor),
                      //         );
                      //       }),
                      // ),
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    controller.singlePedigreeModel!.data!.createrId ==
                            Api.singleton.sp.read("id")
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: InkWell(
                              highlightColor:
                                  DynamicColors.primaryColor.withOpacity(0.1),
                              onTap: () {
                                alertCustomMethod(context,
                                    titleText: "Do you want to delete this pedigree?",
                                    buttonText: "Yes",
                                    buttonText2: "No", click: () {
                                      controller.deletePedigree(controller.singlePedigreeModel!.data!.id!);
                                    }, click2: () {
                                      getx.Get.back();
                                    }, theme: DynamicColors.primaryColor);
                              },
                              child: Text(
                                "Delete",
                                style: poppinsRegular(
                                    fontSize: 13,
                                    color: DynamicColors.primaryColorRed),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      width: 10,
                    ),
                    controller.singlePedigreeModel!.data!.createrId ==
                            Api.singleton.sp.read("id")
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: InkWell(
                              highlightColor:
                                  DynamicColors.primaryColor.withOpacity(0.1),
                              onTap: () {
                                getx.Get.toNamed(Routes.addNewPedigree,
                                        arguments: {
                                      "data":
                                          controller.singlePedigreeModel!.data!,
                                      "tree": true,
                                    })!
                                    .then((value) {
                                  damGraph = Graph()..isTree = true;
                                  builder = BuchheimWalkerConfiguration();
                                  sireGraph = Graph()..isTree = true;
                                  sireBuilder = BuchheimWalkerConfiguration();
                                  getData();
                                });
                              },
                              child: Text(
                                "Edit Info",
                                style: poppinsRegular(
                                    fontSize: 13,
                                    color: DynamicColors.primaryColorRed),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          getx.Get.bottomSheet(
                            PedigreeBottomSheet(
                                data: controller.singlePedigreeModel!.data!),
                            isScrollControlled: true,
                            enableDrag: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30))),
                          );
                        },
                        child: Text(
                          "More Info",
                          style: poppinsRegular(
                              fontSize: 13,
                              color: DynamicColors.primaryColorRed),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget carouselSlider(
    BuildContext context,
  ) {
    return controller.singlePedigreeModel!.data!.photos == null ||
            controller.singlePedigreeModel!.data!.photos!.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                width: MediaQuery.of(context).size.width / 3,
                child: Stack(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 6,
                    child: CarouselSlider.builder(
                        itemCount: controller
                            .singlePedigreeModel!.data!.photos!.length,
                        itemBuilder: (BuildContext context, int index,
                                int pageViewIndex) =>
                            InkWell(
                              highlightColor:
                                  DynamicColors.primaryColor.withOpacity(0.1),
                              onTap: () {
                                getx.Get.toNamed(Routes.photo, arguments: {
                                  "image": controller.singlePedigreeModel!.data!
                                      .photos![index].photo!
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    image: DecorationImage(
                                        image: OptimizedCacheImageProvider(
                                          controller.singlePedigreeModel!.data!
                                              .photos![index].photo!,
                                        ),
                                        alignment: Alignment.topCenter,
                                        fit: BoxFit.cover)),
                              ),
                            ),
                        options: CarouselOptions(
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          reverse: false,
                          autoPlay: false,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: false,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1,
                          onPageChanged: (value, reason) {
                            _current.value = value;
                          },
                          scrollDirection: Axis.horizontal,
                        )),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: getx.Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: controller
                              .singlePedigreeModel!.data!.photos!
                              .asMap()
                              .entries
                              .map((entry) {
                            return Container(
                              width: 6.0,
                              height: 6.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : DynamicColors.primaryColorRed)
                                      .withOpacity(_current.value == entry.key
                                          ? 0.9
                                          : 0.4)),
                            );
                          }).toList(),
                        );
                      })),
                ]),
              ),
            ),
          );
  }

  Random r = Random();

  Widget rectangleWidget(int a) {
    // return Container();
    PedigreeSearchData? d;
    if (a > 0) {
      d = controller.pedigreeModel!.data!.singleWhere((element) {
        if (element.id == a) {
          return true;
        }
        return false;
      });
    }

    if (d == null) {
      print(
        "Unknown",
      );

      return InkWell(
        highlightColor: DynamicColors.primaryColor.withOpacity(0.1),
        onTap: () {
          sireNavigate(null);
        },
        child: Text(
          "Unknown",
          style: montserratBold(fontSize: 15),
        ),
      );
    } else {
      print(d.fullName);
      return Text(
        d.fullName!,
        style: montserratBold(
            fontSize: 15,
            color: d.sex == "female"
                ? DynamicColors.primaryColorRed
                : DynamicColors.primaryColor),
      );
    }
  }

  Graph damGraph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  Graph sireGraph = Graph()..isTree = true;
  BuchheimWalkerConfiguration sireBuilder = BuchheimWalkerConfiguration();

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await controller.getSinglePedigree(id);

    if (controller.singlePedigreeModel != null) {
      await getDamDogData(controller.singlePedigreeModel!.data!.dam,
          sourceId: controller.singlePedigreeModel!.data!.dam == null
              ? controller.singlePedigreeModel!.data!.id
              : null,treeData: controller.singlePedigreeModel!.data!.dam ?? controller.singlePedigreeModel!.data!);
      await getSireDogData(controller.singlePedigreeModel!.data!.sire,
          sourceId: controller.singlePedigreeModel!.data!.sire == null
              ? controller.singlePedigreeModel!.data!.id
              : null,treeData: controller.singlePedigreeModel!.data!.sire ?? controller.singlePedigreeModel!.data!);
    }
  }

  int? newId;

  damNavigate(PedigreeSearchData data) async {
    if (data.dam != null) {
      await controller.getSinglePedigree(data.dam!.id!);
      damGraph = Graph()..isTree = true;
      getDamDogData(controller.singlePedigreeModel!.data!);
    } else {
      getx.Get.toNamed(Routes.addNewPedigree, arguments: {
        "source": "dam",
        "sourceId": data.id,
        "data": data,
        "tree": true,
        "originalId": id,
      })!
          .then((value) {
        damGraph = Graph()..isTree = true;
        builder = BuchheimWalkerConfiguration();
        sireGraph = Graph()..isTree = true;
        sireBuilder = BuchheimWalkerConfiguration();
        getData();
      });
    }
  }

  sireNavigate(PedigreeSearchData? data) async {
    if (data != null) {
      if (data.sire != null) {
        await controller.getSinglePedigree(data.sire!.id!);
        damGraph = Graph()..isTree = true;
        getDamDogData(controller.singlePedigreeModel!.data!);
      } else {
        getx.Get.toNamed(Routes.addNewPedigree, arguments: {
          "source": "sire",
          "sourceId": data.id,
          "data": data,
          "tree": true,
          "originalId": id,
        })!
            .then((value) {
          damGraph = Graph()..isTree = true;
          builder = BuchheimWalkerConfiguration();
          sireGraph = Graph()..isTree = true;
          sireBuilder = BuchheimWalkerConfiguration();
          getData();
        });
      }
    }
  }

  sireDamNavigate(PedigreeSearchData data) async {
    if (data.dam != null) {
      await controller.getSinglePedigree(data.dam!.id!);
      sireGraph = Graph()..isTree = true;
      getSireDogData(controller.singlePedigreeModel!.data!);
    } else {
      getx.Get.toNamed(Routes.addNewPedigree, arguments: {
        "source": "dam",
        "sourceId": data.id,
        "data": data,
        "tree": true,
        "originalId": id,
      })!
          .then((value) {
        damGraph = Graph()..isTree = true;
        builder = BuchheimWalkerConfiguration();
        sireGraph = Graph()..isTree = true;
        sireBuilder = BuchheimWalkerConfiguration();
        getData();
      });
    }
  }

  sireSireNavigate(PedigreeSearchData? data) async {
    if (data != null) {
      if (data.sire != null) {
        await controller.getSinglePedigree(data.sire!.id!);
        sireGraph = Graph()..isTree = true;
        getSireDogData(controller.singlePedigreeModel!.data!);
      } else {
        getx.Get.toNamed(Routes.addNewPedigree, arguments: {
          "source": "sire",
          "sourceId": data.id,
          "data": data,
          "tree": true,
          "originalId": id,
        })!
            .then((value) {
          damGraph = Graph()..isTree = true;
          builder = BuchheimWalkerConfiguration();
          sireGraph = Graph()..isTree = true;
          sireBuilder = BuchheimWalkerConfiguration();
          getData();
        });
      }
    }
  }

  getDamDogData(PedigreeSearchData? data, {int? sourceId,PedigreeSearchData? treeData}) {
    Node? node1 = Node(SizedBox(
      height: 20,
      child: InkWell(
          highlightColor: DynamicColors.primaryColor.withOpacity(0.1),
          onTap: () async {
            if (data == null) {
              getx.Get.toNamed(Routes.addNewPedigree, arguments: {
                "source": "dam",
                "sourceId": sourceId,
                "data": treeData,
                "tree": true,
                "originalId": id,
              })!
                  .then((value) {
                damGraph = Graph()..isTree = true;
                builder = BuchheimWalkerConfiguration();
                sireGraph = Graph()..isTree = true;
                sireBuilder = BuchheimWalkerConfiguration();
                getData();
              });
            }
          },
          child: textWidget(data: data)),
    ));
    Node? node2 = data == null
        ? null
        : Node(SizedBox(
            height: 20,
            child: InkWell(
                highlightColor: DynamicColors.primaryColor.withOpacity(0.1),
                onTap: () async {
                  sireNavigate(data);
                },
                child: textWidget(data: data.sire))));
    Node? node3 = data == null
        ? null
        : Node(SizedBox(
            height: 20,
            child: InkWell(
                highlightColor: DynamicColors.primaryColor.withOpacity(0.1),
                onTap: () async {
                  damNavigate(data);
                },
                child: textWidget(data: data.dam))));
    Node? node3_1 = data == null
        ? null
        : data.dam == null
            ? null
            : Node(SizedBox(
                height: 20,
                child: InkWell(
                    highlightColor: DynamicColors.primaryColor.withOpacity(0.1),
                    onTap: () {
                      sireNavigate(data.dam!);
                    },
                    child: textWidget(data: data.dam!.sire)),
              ));
    Node? node3_2 = data == null
        ? null
        : data.dam == null
            ? null
            : Node(SizedBox(
                height: 20,
                child: InkWell(
                    highlightColor: DynamicColors.primaryColor.withOpacity(0.1),
                    onTap: () async {
                      damNavigate(data.dam!);
                    },
                    child: textWidget(data: data.dam!.dam)),
              ));
    Node? node2_1 = data == null
        ? null
        : data.sire == null
            ? null
            : Node(SizedBox(
                height: 20,
                child: InkWell(
                    highlightColor: DynamicColors.primaryColor.withOpacity(0.1),
                    onTap: () {
                      sireNavigate(data.sire!);
                    },
                    child: textWidget(data: data.sire!.sire)),
              ));
    Node? node2_2 = data == null
        ? null
        : data.sire == null
            ? null
            : Node(SizedBox(
                height: 20,
                child: InkWell(
                    highlightColor: DynamicColors.primaryColor.withOpacity(0.1),
                    onTap: () {
                      damNavigate(data.sire!);
                    },
                    child: textWidget(data: data.sire!.dam)),
              ));

    Node? node3_2_2 = data == null
        ? null
        : data.dam == null
            ? null
            : data.dam!.dam == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          damNavigate(data.dam!.dam!);
                        },
                        child: textWidget(data: data.dam!.dam!.dam)),
                  ));
    Node? node3_2_1 = data == null
        ? null
        : data.dam == null
            ? null
            : data.dam!.dam == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          sireNavigate(data.dam!.sire!);
                        },
                        child: textWidget(data: data.dam!.dam!.sire)),
                  ));

    Node? node3_1_2 = data == null
        ? null
        : data.dam == null
            ? null
            : data.dam!.sire == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          damNavigate(data.dam!.sire!);
                        },
                        child: textWidget(data: data.dam!.sire!.dam)),
                  ));
    Node? node3_1_1 = data == null
        ? null
        : data.dam == null
            ? null
            : data.dam!.sire == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          sireNavigate(data.dam!.sire!);
                        },
                        child: textWidget(data: data.dam!.sire!.sire)),
                  ));

    Node? node2_2_2 = data == null
        ? null
        : data.sire == null
            ? null
            : data.sire!.dam == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          damNavigate(data.sire!.dam!);
                        },
                        child: textWidget(data: data.sire!.dam!.dam)),
                  ));
    Node? node2_2_1 = data == null
        ? null
        : data.sire == null
            ? null
            : data.sire!.dam == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          sireNavigate(data.sire!.dam!);
                        },
                        child: textWidget(data: data.sire!.dam!.sire)),
                  ));

    Node? node2_1_2 = data == null
        ? null
        : data.sire == null
            ? null
            : data.sire!.sire == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          damNavigate(data.sire!.sire!);
                        },
                        child: textWidget(data: data.sire!.sire!.dam)),
                  ));
    Node? node2_1_1 = data == null
        ? null
        : data.sire == null
            ? null
            : data.sire!.sire == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          sireNavigate(data.sire!.sire!);
                        },
                        child: textWidget(data: data.sire!.sire!.sire)),
                  ));

    if (data != null && node2 != null) {
      damGraph.addEdge(node1, node2,
          paint: Paint()
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    } else {
      damGraph.addNode(node1);
    }
    if (node3 != null) {
      damGraph.addEdge(node1, node3,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }

    if (node2 != null && node2_1 != null) {
      damGraph.addEdge(node2, node2_1,
          paint: Paint()
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node2 != null && node2_2 != null) {
      damGraph.addEdge(node2, node2_2,
          paint: Paint()
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node3 != null && node3_1 != null) {
      damGraph.addEdge(node3, node3_1,
          paint: Paint()
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node3 != null && node3_2 != null) {
      damGraph.addEdge(node3, node3_2,
          paint: Paint()
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node2_1 != null && node2_1_1 != null) {
      damGraph.addEdge(node2_1, node2_1_1,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node2_1 != null && node2_1_2 != null) {
      damGraph.addEdge(node2_1, node2_1_2,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node2_2 != null && node2_2_1 != null) {
      damGraph.addEdge(node2_2, node2_2_1,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node2_2 != null && node2_2_2 != null) {
      damGraph.addEdge(node2_2, node2_2_2,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }

    if (node3_1 != null && node3_1_1 != null) {
      damGraph.addEdge(node3_1, node3_1_1,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node3_1 != null && node3_1_2 != null) {
      damGraph.addEdge(node3_1, node3_1_2,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node3_2 != null && node3_2_1 != null) {
      damGraph.addEdge(node3_2, node3_2_1,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node3_2 != null && node3_2_2 != null) {
      damGraph.addEdge(node3_2, node3_2_2,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }

    builder
      ..siblingSeparation = (20)
      ..levelSeparation = (30)
      ..subtreeSeparation = (30)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT);
  }

  getSireDogData(PedigreeSearchData? data, {int? sourceId,PedigreeSearchData? treeData,}) {
    Node? node1 = Node(SizedBox(
      height: 20,
      child: InkWell(
        highlightColor: DynamicColors.primaryColor.withOpacity(0.1),
        onTap: () async {
          if (data == null) {
            getx.Get.toNamed(Routes.addNewPedigree, arguments: {
              "source": "sire",
              "sourceId": sourceId,
              "data": treeData,
              "tree": true,
              "originalId": id,
            })!
                .then((value) {
              damGraph = Graph()..isTree = true;
              builder = BuchheimWalkerConfiguration();
              sireGraph = Graph()..isTree = true;
              sireBuilder = BuchheimWalkerConfiguration();
              getData();
            });
          }
        },
        child: textWidget(data: data),
      ),
    ));
    Node? node2 = data == null
        ? null
        : Node(SizedBox(
            height: 20,
            child: InkWell(
                highlightColor: DynamicColors.primaryColor.withOpacity(0.1),
                onTap: () async {
                  sireSireNavigate(data);
                },
                child: textWidget(data: data.sire)),
          ));
    Node? node3 = data == null
        ? null
        : Node(SizedBox(
            height: 20,
            child: InkWell(
                highlightColor: DynamicColors.primaryColor.withOpacity(0.1),
                onTap: () async {
                  sireDamNavigate(data);
                },
                child: textWidget(data: data.dam)),
          ));
    Node? node3_1 = data == null
        ? null
        : data.dam == null
            ? null
            : Node(SizedBox(
                height: 20,
                child: InkWell(
                    highlightColor: DynamicColors.primaryColor.withOpacity(0.1),
                    onTap: () {
                      sireSireNavigate(data.dam!);
                    },
                    child: textWidget(data: data.dam!.sire)),
              ));
    Node? node3_2 = data == null
        ? null
        : data.dam == null
            ? null
            : Node(SizedBox(
                height: 20,
                child: InkWell(
                    highlightColor: DynamicColors.primaryColor.withOpacity(0.1),
                    onTap: () async {
                      sireDamNavigate(data.dam!);
                    },
                    child: textWidget(data: data.dam!.dam)),
              ));
    Node? node2_1 = data == null
        ? null
        : data.sire == null
            ? null
            : Node(SizedBox(
                height: 20,
                child: InkWell(
                    highlightColor: DynamicColors.primaryColor.withOpacity(0.1),
                    onTap: () {
                      sireSireNavigate(data.sire!);
                    },
                    child: textWidget(data: data.sire!.sire)),
              ));
    Node? node2_2 = data == null
        ? null
        : data.sire == null
            ? null
            : Node(SizedBox(
                height: 20,
                child: InkWell(
                    highlightColor: DynamicColors.primaryColor.withOpacity(0.1),
                    onTap: () {
                      sireDamNavigate(data.sire!);
                    },
                    child: textWidget(data: data.sire!.dam)),
              ));

    Node? node3_2_2 = data == null
        ? null
        : data.dam == null
            ? null
            : data.dam!.dam == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          sireDamNavigate(data.dam!.dam!);
                        },
                        child: textWidget(data: data.dam!.dam!.dam)),
                  ));
    Node? node3_2_1 = data == null
        ? null
        : data.dam == null
            ? null
            : data.dam!.dam == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          sireSireNavigate(data.dam!.sire!);
                        },
                        child: textWidget(data: data.dam!.dam!.sire)),
                  ));

    Node? node3_1_2 = data == null
        ? null
        : data.dam == null
            ? null
            : data.dam!.sire == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          sireDamNavigate(data.dam!.sire!);
                        },
                        child: textWidget(data: data.dam!.sire!.dam)),
                  ));
    Node? node3_1_1 = data == null
        ? null
        : data.dam == null
            ? null
            : data.dam!.sire == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          sireSireNavigate(data.dam!.sire!);
                        },
                        child: textWidget(data: data.dam!.sire!.sire)),
                  ));

    Node? node2_2_2 = data == null
        ? null
        : data.sire == null
            ? null
            : data.sire!.dam == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          sireDamNavigate(data.sire!.dam!);
                        },
                        child: textWidget(data: data.sire!.dam!.dam)),
                  ));
    Node? node2_2_1 = data == null
        ? null
        : data.sire == null
            ? null
            : data.sire!.dam == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          sireSireNavigate(data.sire!.dam!);
                        },
                        child: textWidget(data: data.sire!.dam!.sire))));

    Node? node2_1_2 = data == null
        ? null
        : data.sire == null
            ? null
            : data.sire!.sire == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          sireDamNavigate(data.sire!.sire!);
                        },
                        child: textWidget(data: data.sire!.sire!.dam)),
                  ));
    Node? node2_1_1 = data == null
        ? null
        : data.sire == null
            ? null
            : data.sire!.sire == null
                ? null
                : Node(SizedBox(
                    height: 20,
                    child: InkWell(
                        highlightColor:
                            DynamicColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          sireSireNavigate(data.sire!.sire!);
                        },
                        child: textWidget(data: data.sire!.sire!.sire)),
                  ));

    if (data != null && node2 != null) {
      sireGraph.addEdge(node1, node2,
          paint: Paint()
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    } else {
      sireGraph.addNode(node1);
    }
    if (node3 != null) {
      sireGraph.addEdge(node1, node3,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }

    if (node2 != null && node2_1 != null) {
      sireGraph.addEdge(node2, node2_1,
          paint: Paint()
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node2 != null && node2_2 != null) {
      sireGraph.addEdge(node2, node2_2,
          paint: Paint()
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node3 != null && node3_1 != null) {
      sireGraph.addEdge(node3, node3_1,
          paint: Paint()
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node3 != null && node3_2 != null) {
      sireGraph.addEdge(node3, node3_2,
          paint: Paint()
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node2_1 != null && node2_1_1 != null) {
      sireGraph.addEdge(node2_1, node2_1_1,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node2_1 != null && node2_1_2 != null) {
      sireGraph.addEdge(node2_1, node2_1_2,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node2_2 != null && node2_2_1 != null) {
      sireGraph.addEdge(node2_2, node2_2_1,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node2_2 != null && node2_2_2 != null) {
      sireGraph.addEdge(node2_2, node2_2_2,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }

    if (node3_1 != null && node3_1_1 != null) {
      sireGraph.addEdge(node3_1, node3_1_1,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node3_1 != null && node3_1_2 != null) {
      sireGraph.addEdge(node3_1, node3_1_2,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node3_2 != null && node3_2_1 != null) {
      sireGraph.addEdge(node3_2, node3_2_1,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }
    if (node3_2 != null && node3_2_2 != null) {
      sireGraph.addEdge(node3_2, node3_2_2,
          paint: Paint()
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 1
            ..color = DynamicColors.primaryColorRed);
    }

    sireBuilder
      ..siblingSeparation = (40)
      ..levelSeparation = (80)
      ..subtreeSeparation = (80)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT);
  }
}

Widget textWidget({PedigreeSearchData? data}) {
  return data == null
      ? RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
              text: "Unknown",
              style: poppinsRegular(
                  fontSize: 12, color: DynamicColors.primaryColor)))
      : RichText(
          textAlign: TextAlign.start,
          text: TextSpan(children: [
            TextSpan(
                text: "${data.ownerName} ",
                style: poppinsRegular(
                    fontSize: 12,
                    color: data.beforeNameTitle == null
                        ? DynamicColors.primaryColor
                        : DynamicColors.primaryColorRed)),
            TextSpan(
                text: data.beforeNameTitle == null
                    ? ""
                    : "${data.beforeNameTitle!.toUpperCase()} ",
                style: poppinsRegular(
                    fontSize: 12,
                    color: data.beforeNameTitle == null
                        ? DynamicColors.primaryColor
                        : DynamicColors.primaryColorRed)),
            TextSpan(
                text: "${data.dogName} ",
                style: poppinsRegular(
                    fontSize: 12,
                    color: data.beforeNameTitle == null
                        ? DynamicColors.primaryColor
                        : DynamicColors.primaryColorRed)),
            TextSpan(
                text: data.afterNameTitle == null
                    ? ""
                    : "${data.afterNameTitle!.toUpperCase()} ",
                style: poppinsRegular(
                    fontSize: 12,
                    color: data.beforeNameTitle == null
                        ? DynamicColors.primaryColor
                        : DynamicColors.primaryColorRed)),
          ]),
        );
}

class PedigreeBottomSheet extends StatelessWidget {
  PedigreeBottomSheet({Key? key, required this.data}) : super(key: key);
  PedigreeSearchData? data;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          child: Container(
            decoration: BoxDecoration(
              color: DynamicColors.primaryColorLight,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        height: 10,
                        width: 70,
                        decoration: BoxDecoration(
                            color: DynamicColors.primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Photos & Videos",
                      style: montserratBold(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: ListView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          shrinkWrap: true,
                          itemCount: data!.photos!.length,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  width: Utils.width(context) / 3,
                                  child: InkWell(
                                    highlightColor: DynamicColors.primaryColor
                                        .withOpacity(0.1),
                                    onTap: () {
                                      getx.Get.toNamed(Routes.photo,
                                          arguments: {
                                            "image": data!.photos![index].photo!
                                          });
                                    },
                                    child: OptimizedCacheImage(
                                      imageUrl: data!.photos![index].photo!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ));
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            checkPedigreeColumn("Sex", data!.sex),
                            checkPedigreeColumn("Color", data!.color),
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            data!.dob == null
                                ? Container()
                                : Column(
                                    children: [
                                      Text(
                                        "Birth Date",
                                        style: montserratBold(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        DateFormat("MMM dd yyyy")
                                            .format(data!.dob!),
                                        style: montserratRegular(fontSize: 14),
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              height: data!.dob == null ? 0 : 20,
                            ),
                            checkPedigreeColumn("Weight", data!.weight),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: data!.brief == null ? 0 : 30,
                    ),
                    checkPedigreeColumn(
                        "Brief Description and Comments", data!.brief),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget checkPedigreeColumn(title, data) {
    if (data == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: montserratBold(),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          data,
          style: montserratRegular(fontSize: 14),
        ),
      ],
    );
  }
}

class GridViewList {
  String title;
  String subtitle;

  GridViewList({required this.title, required this.subtitle});
}

List<GridViewList> gridViewList = [
  GridViewList(title: "Sex", subtitle: "Male"),
  GridViewList(title: "Age", subtitle: "2 Years"),
  GridViewList(title: "Color", subtitle: "Brown"),
  GridViewList(title: "Weight", subtitle: "20 pound"),
];




class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // print(size);
    // debugger();

    const primaryColor = Color(0xffBD2636);
    final paint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final double cornerRadius = size.width / 10; // Adjust the corner radius as needed

    // Draw vertical line
    canvas.drawLine(Offset(0, cornerRadius), Offset(0, size.height  / 2   ), paint);
    canvas.drawLine(Offset(0,  size.width /2 + 20), Offset(0, size.height   ), paint);

    
  
    // Draw top-left corner
    canvas.drawArc(
      Rect.fromLTWH(0, 0, cornerRadius * 2, cornerRadius * 2),
      math.pi,
      math.pi / 2,
      false,
      paint,
    );

   

    // Draw bottom-left corner
    canvas.drawArc(
      Rect.fromLTWH(0, size.height - cornerRadius , cornerRadius * 2, cornerRadius * 2),
      math.pi / 2,
      math.pi / 2,
      false,
      paint
    );

// MY
    // canvas.drawLine(Offset(cornerRadius, size.height), Offset(size.width - cornerRadius, size.height), paint);


    // Draw bottom-right corner
    // canvas.drawArc(
    //   Rect.fromLTWH(size.width - cornerRadius * 2, size.height - cornerRadius * 2, cornerRadius * 2, cornerRadius * 2),
    //   0,
    //   math.pi / 2,
    //   false,
    //   paint,
    // );



     // Draw text
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.bold
    );

      final textStyle2= TextStyle(
      color: primaryColor,
      fontSize: 14,
      fontWeight: FontWeight.bold
    );
    final textSpan = TextSpan(      
      text: 'Martins Caeasar Of Tuff',
      style: textStyle,
    );
    final textPainter = TextPainter(      
      text: textSpan,
       textDirection: ui.TextDirection.ltr
    );
    textPainter.layout();
    final textX = (size.width/2 - textPainter.width) / 2;
    final textY = (size.width/2);
    textPainter.paint(canvas, Offset(textX, textY));


// Node2 TopUpper
    canvas.drawLine(Offset(cornerRadius + 30,-size.height / 4), Offset(cornerRadius + 30,  -15   ), paint);
// Node2 TopBottom
    canvas.drawLine(Offset(cornerRadius + 30,size.height / 4 ), Offset(cornerRadius + 30,  20   ), paint);
       // Draw bottom-left corner Tree 2
    canvas.drawArc(
      Rect.fromLTWH(cornerRadius + 30,size.height / 4 ,cornerRadius + 30,  1),
      math.pi / 2,
      math.pi / 2,
      false,
      paint,
    );

     final textSpan3 = TextSpan(      
      style: textStyle,
      text: "Hemphill's Geronimo",
    );
    final textPainter3 = TextPainter(      
      text: textSpan3,
      textDirection: ui.TextDirection.ltr
    );
    textPainter3.layout();
    final text3X =size.height / 4 + 35;
    final text3Y =-size.height / 4 + -10 ;
    textPainter3.paint(canvas, Offset(text3X, text3Y));


     final textSpan4 = TextSpan(      
      style: textStyle2,
      text: "Hemphill's Red Dixie",
    );
    final textPainter4 = TextPainter(      
      text: textSpan4,
      textDirection: ui.TextDirection.ltr
    );
    textPainter4.layout();
    final text4X =size.height / 4 + 35;
    final text4Y =size.height / 4  - 10 ;
    textPainter4.paint(canvas, Offset(text4X, text4Y));
  

       // Draw top-left corner Tree 2
    canvas.drawArc(
      Rect.fromLTWH(cornerRadius + 30,-size.height / 4 ,cornerRadius + 30, 1  ),
    math.pi,
      math.pi / 2,
      false,
      paint,
    );

    ///////////////////////////////////////////////////
    ///
    ///
    
// Node3 TopUpper
    canvas.drawLine(Offset(cornerRadius + 30,size.width  - 30   ), Offset(cornerRadius + 30,  size.width     ), paint);
// Node3 TopBottom
    canvas.drawLine(Offset(cornerRadius + 30,size.width  + 30 ), Offset(cornerRadius + 30,  size.width  + 60  ), paint);
       // Draw bottom-left corner Tree 3
    canvas.drawArc(
      Rect.fromLTWH(cornerRadius + 30,size.width  - 30 ,cornerRadius + 30,  1),
      math.pi / 2,
      math.pi / 2,
      false,
      paint,
    );

     final textSpan5 = TextSpan(      
      style: textStyle,
      text: "Archer's Chico V. lii",
    );
    final textPainter5 = TextPainter(      
      text: textSpan5,
      textDirection: ui.TextDirection.ltr
    );
    textPainter5.layout();
    final text5X =size.height / 4 + 35 ;
    final text5Y =size.width - 35;
    textPainter5.paint(canvas, Offset(text5X, text5Y));


     final textSpan6 = TextSpan(      
      style: textStyle2,
      text: "Storm's Dibo",
    );
    final textPainter6 = TextPainter(      
      text: textSpan6,
      textDirection: ui.TextDirection.ltr
    );
    textPainter6.layout();
    final text6X =size.height / 4 + 35;
    final text6Y =size.width + 50;
    textPainter6.paint(canvas, Offset(text6X, text6Y));
  

    //    // Draw top-left corner Tree 3
    canvas.drawArc(
      Rect.fromLTWH(cornerRadius + 30,size.width  + 60,cornerRadius + 30, 1  ),
    math.pi,
      math.pi / 2,
      false,
      paint,
    );
    ///
    ///
    


    final textSpan1 = TextSpan(      
      text: 'Zapper Chato',
      style: textStyle,
    );
    final textPainter1 = TextPainter(      
      text: textSpan1,
      textDirection: ui.TextDirection.ltr
    );
    textPainter1.layout();
    final text1X = cornerRadius + 10;
    final text1Y = -5.0;
    textPainter1.paint(canvas, Offset(text1X, text1Y));


     
    final textSpan2 = TextSpan(      
      text: 'Topsey Turvay',
      style: textStyle2,
    );
    final textPainter2 = TextPainter(      
      text: textSpan2,
      textDirection: ui.TextDirection.ltr
    );
    textPainter2.layout();
    final text2X = cornerRadius + 10;
    final text2Y = size.height + 10;
    textPainter2.paint(canvas, Offset(text2X, text2Y));
  
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
