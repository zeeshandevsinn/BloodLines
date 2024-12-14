import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/Classified/Data/classifiedController.dart';
import 'package:bloodlines/View/Classified/Model/classifiedAdModel.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class ProductAndServices extends StatelessWidget {
  ProductAndServices({Key? key, required this.classifiedAdDataList})
      : super(key: key);

  final List<ClassifiedAdData> classifiedAdDataList;
  ClassifiedController controller = Get.find();
  final RxInt _current = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: classifiedAdDataList.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              controller.getClassifiedDetails(classifiedAdDataList[index].id!);
              controller.classifiedAdData = classifiedAdDataList[index];
              Get.toNamed(Routes.productDetail,
                  arguments: {"model": classifiedAdDataList[index]});
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height / 6,
                            child: CarouselSlider.builder(
                                itemCount: classifiedAdDataList[index]
                                    .classifiedPhotos!
                                    .length,
                                itemBuilder: (BuildContext context, int i,
                                    int pageViewIndex) =>
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              3),
                                          image: DecorationImage(
                                              image: OptimizedCacheImageProvider(
                                                classifiedAdDataList[index]
                                                    .classifiedPhotos![i]
                                                    .photo!,
                                              ),
                                              alignment: Alignment.center,
                                              fit: BoxFit.cover)),
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
                              child:classifiedAdDataList[index]
                                  .classifiedPhotos!.length ==1?
                              Container()
                                  :  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:classifiedAdDataList[index]
                                    .classifiedPhotos!
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  return Obx(() {
                                    return Container(
                                      width: 6.0,
                                      height: 6.0,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (Theme
                                              .of(context)
                                              .brightness ==
                                              Brightness.dark
                                              ? Colors.white
                                              : DynamicColors.primaryColorRed)
                                              .withOpacity(
                                              _current.value == entry.key
                                                  ? 0.9
                                                  : 0.4)),
                                    );
                                  });
                                }).toList(),
                              )),
                        ],
                      ),
                      // OptimizedCacheImage(imageUrl:
                      //     classifiedAdDataList[index].cover!,
                      //     fit: BoxFit.cover,
                      //     height: Utils.height(context) / 7,
                      //     width: Utils.width(context) / 2.1,
                      //   ),
                      Positioned(
                        bottom: 10,
                        left: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: DynamicColors.primaryColorRed),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "\$${classifiedAdDataList[index].price!}",
                              style: montserratRegular(
                                  fontSize: 12,
                                  color: DynamicColors.whiteColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    classifiedAdDataList[index].title!,
                    style: montserratRegular(
                        fontSize: 14, color: DynamicColors.textColor),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
