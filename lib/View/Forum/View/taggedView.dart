// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Pedigree/Model/pedigreeSearchModel.dart';
import 'package:bloodlines/userModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class TaggedView extends StatelessWidget {
  TaggedView({Key? key}) : super(key: key);
  List<PedigreeSearchData>? pedigree = Get.arguments["pedigree"];
  List<UserModel>? userModel = Get.arguments["user"];
  final RxInt _current = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: AppBarWidgets(
          isCardType: true,
        ),
        title: Text(
          "Tags",
          style: montserratSemiBold(fontSize: 26),
        ),
      ),
      body: pedigree!.isEmpty && userModel!.isEmpty
          ? Center(
              child: Text(
                "No Data",
                style: poppinsBold(fontSize: 25),
              ),
            )
          : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  pedigree!.isEmpty
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Pedigrees",
                              style: poppinsBold(fontSize: 24),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ListView.builder(
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                itemCount: pedigree!.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  PedigreeSearchData pedigreeData =
                                      pedigree![index];

                                  return GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.pedigreeTree,
                                          arguments: {"id": pedigreeData.id});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Row(
                                        children: [
                                          pedigreeData.photos == null ||
                                                  pedigreeData.photos!.isEmpty
                                              ? Container()
                                              : SizedBox(
                                                  height: 60,
                                                  width: 60,
                                                  child: Stack(children: [
                                                    SizedBox(
                                                      height: 60,
                                                      child:
                                                          CarouselSlider.builder(
                                                              itemCount:
                                                                  pedigreeData
                                                                      .photos!
                                                                      .length,
                                                              itemBuilder: (BuildContext
                                                                          context,
                                                                      int i,
                                                                      int
                                                                          pageViewIndex) =>
                                                                  InkWell(
                                                                    highlightColor: DynamicColors
                                                                        .primaryColor
                                                                        .withOpacity(
                                                                            0.1),
                                                                    onTap: () {
                                                                      Get.toNamed(
                                                                          Routes
                                                                              .photo,
                                                                          arguments: {
                                                                            "image": pedigreeData
                                                                                .photos![i]
                                                                                .photo!
                                                                          });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(3),
                                                                          image: DecorationImage(
                                                                              image: OptimizedCacheImageProvider(
                                                                                pedigreeData.photos![i].photo!,
                                                                              ),
                                                                              alignment: Alignment.topCenter,
                                                                              fit: BoxFit.cover)),
                                                                    ),
                                                                  ),
                                                              options:
                                                                  CarouselOptions(
                                                                initialPage: 0,
                                                                enableInfiniteScroll:
                                                                    false,
                                                                reverse: false,
                                                                autoPlay: false,
                                                                autoPlayInterval:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                autoPlayAnimationDuration:
                                                                    Duration(
                                                                        milliseconds:
                                                                            800),
                                                                autoPlayCurve: Curves
                                                                    .fastOutSlowIn,
                                                                enlargeCenterPage:
                                                                    false,
                                                                aspectRatio:
                                                                    16 / 9,
                                                                viewportFraction:
                                                                    1,
                                                                onPageChanged:
                                                                    (value,
                                                                        reason) {
                                                                  _current.value =
                                                                      value;
                                                                },
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                              )),
                                                    ),
                                                    Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Obx(() {
                                                          return Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: pedigreeData
                                                                .photos!
                                                                .asMap()
                                                                .entries
                                                                .map((entry) {
                                                              return Container(
                                                                width: 6.0,
                                                                height: 6.0,
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            8.0,
                                                                        horizontal:
                                                                            4.0),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: (Theme.of(context).brightness ==
                                                                                Brightness
                                                                                    .dark
                                                                            ? Colors
                                                                                .white
                                                                            : DynamicColors
                                                                                .primaryColorRed)
                                                                        .withOpacity(_current.value ==
                                                                                entry.key
                                                                            ? 0.9
                                                                            : 0.4)),
                                                              );
                                                            }).toList(),
                                                          );
                                                        })),
                                                  ])),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          RichText(
                                            textAlign: TextAlign.start,
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      "${pedigreeData.ownerName} ",
                                                  style: poppinsRegular(
                                                      fontSize: 12,
                                                      color: DynamicColors
                                                          .primaryColor)),
                                              TextSpan(
                                                  text: pedigreeData
                                                              .beforeNameTitle ==
                                                          null
                                                      ? ""
                                                      : "${pedigreeData.beforeNameTitle!.toUpperCase()} ",
                                                  style: poppinsRegular(
                                                      fontSize: 12,
                                                      color: DynamicColors
                                                          .primaryColorRed)),
                                              TextSpan(
                                                  text:
                                                      "${pedigreeData.dogName} ",
                                                  style: poppinsRegular(
                                                      fontSize: 12,
                                                      color: DynamicColors
                                                          .primaryColor)),
                                              TextSpan(
                                                  text: pedigreeData
                                                              .afterNameTitle ==
                                                          null
                                                      ? ""
                                                      : "${pedigreeData.afterNameTitle!.toUpperCase()} ",
                                                  style: poppinsRegular(
                                                      fontSize: 12,
                                                      color: DynamicColors
                                                          .primaryColor)),
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                  pedigree!.isEmpty
                      ? Container()
                      : SizedBox(
                          height: 20,
                        ),
                  userModel!.isEmpty
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Users",
                              style: poppinsBold(fontSize: 24),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ListView.builder(
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                itemCount: userModel!.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  UserModel user = userModel![index];
                                  return GestureDetector(
                                    onTap: (){
                                      Utils.routeOnTimeline(user.id!, user);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: SizedBox(
                                                child: OptimizedCacheImage(
                                                  imageUrl:
                                                      user.profile!.profileImage!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            user.profile!.fullname!,
                                            style: poppinsRegular(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                ],
              ),
          ),
    );
  }
}
