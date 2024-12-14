// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/Groups/Model/groupModel.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class CreatedGroups extends StatelessWidget {
  CreatedGroups({Key? key}) : super(key: key);
  FeedController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedController>(builder: (controller) {
      if(controller.createdGroups == null){
        return Padding(
          padding:  EdgeInsets.only(top: Utils.height(context)/3),
          child: Center(
            child: LoaderClass(),
          ),
        );
      }
      if(controller.createdGroups!.data!.isEmpty){
        return Padding(
          padding:  EdgeInsets.only(top: Utils.height(context)/3),
          child: Center(
            child: Text(
              "No Data",
              style: poppinsBold(fontSize: 25),
            ),
          ),
        );
      }
      return ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.zero,
          itemCount: controller.createdGroups!.data!.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            GroupData data = controller.createdGroups!.data![index];
            if(data.isReported == 1){
              return Container();
            }
            return GestureDetector(
              onTap: (){
                Get.toNamed(Routes.groupDetails,
                    arguments: {
                      "id": data.id,
                    });
              },
              child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300]!,
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            height: Utils.height(context) / 8,
                            width: Utils.width(context) / 3,
                            child: OptimizedCacheImage(
                              imageUrl:
                              data.photo!,
                              fit: BoxFit.cover,
                            ),
                          ),

                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Utils.width(context) / 1.7,
                                child: Text(
                                  data.name!,
                                  style: poppinsRegular(fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/group.png",
                                    height: 10,
                                    color: DynamicColors.primaryColorRed,
                                  ),
                                  Text(
                                    "  ${data.groupMembers!.length} Members",
                                    style: poppinsRegular(
                                        fontSize: 9,
                                        color: DynamicColors.primaryColorRed),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: Utils.width(context) / 1.7,
                                child: Row(
                                  children: [
                                    Spacer(),
                                    CustomButton(
                                      text: "View",
                                      isLong: false,
                                      onTap: () {
                                        Get.toNamed(Routes.groupDetails,
                                            arguments: {
                                              "id": data.id,
                                            });
                                      },
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 20),
                                      color: DynamicColors.primaryColorRed,
                                      borderColor: Colors.transparent,
                                      borderRadius: BorderRadius.circular(5),
                                      style: poppinsSemiBold(
                                          color: DynamicColors.primaryColorLight,
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
            );
          });
    });
  }
}
