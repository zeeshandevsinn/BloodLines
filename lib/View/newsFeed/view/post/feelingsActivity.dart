import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/View/newsFeed/model/feelingModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeelingsActivity extends StatelessWidget {
  const FeelingsActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: DynamicColors.primaryColorLight,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(
            "Feelings/Activity",
            style: poppinsBold(fontSize: 22),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: TabBar(
              indicatorColor: DynamicColors.primaryColor,
              tabs: [
                Tab(text: "Feelings"),
                Tab(
                  text: "Activity",
                ),
              ],
            ),
          ),
          leading: AppBarWidgets(),
        ),
        body: TabBarView(
          children: [
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemCount: feelingList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: InkWell(
                    onTap: () {
                      Get.back(result: feelingList[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: DynamicColors.primaryColor)),
                      child: Center(
                        child: Row(
                          children: [
                            Image.asset(
                              feelingList[index].image!,
                              height: 40,
                            ),
                            Text(
                              feelingList[index].name!,
                              style: poppinsRegular(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 3),
            ),
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemCount: activityList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: InkWell(
                    onTap: () {
                      Get.back(result: activityList[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: DynamicColors.primaryColor)),
                      child: Center(
                        child: Row(
                          children: [
                            Image.asset(
                              activityList[index].image!,
                              height: 40,
                            ),
                            Text(
                              activityList[index].name!,
                              style: poppinsRegular(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 3),
            ),
          ],
        ),
      ),
    );
  }
}
