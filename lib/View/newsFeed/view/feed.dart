// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/View/newsFeed/view/event/view/eventItems.dart';
import 'package:bloodlines/View/newsFeed/view/post/postWidget.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

class Feed extends StatelessWidget {
  Feed({Key? key}) : super(key: key);
  FeedController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: DynamicColors.accentColor.withOpacity(0.1),
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight - 8),
            child: TabBar(
              labelColor: DynamicColors.primaryColorRed,
              unselectedLabelColor: DynamicColors.primaryColor,
              onTap: (value) {
                if (value == 0) {
                  controller.getNewsFeed();
                } else if (value == 1) {
                  controller.getNewsFeed(type: "following");
                } else {
                  controller.getNewsFeed(type: "event");
                }
              },
              tabs: [
                Tab(
                  text: "All Posts",
                ),
                Tab(text: "Following"),
                Tab(text: "Events"),
              ],
            ),
          ),
        ),
        // backgroundColor: DynamicColors.accentColor.withOpacity(0.2),
        body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
                children: [AllPosts(), FollowingPosts(), EventPosts()])),
      ),
    );
  }
}

class AllPosts extends StatelessWidget {
  AllPosts({Key? key}) : super(key: key);
  FeedController controller = Get.find();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> onRefresh() async {
    controller.getNewsFeed();
    // refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: onRefresh,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: GetBuilder<FeedController>(builder: (controller) {
        if (controller.postsData == null) {
          return LoaderClass();
        }
        return FeedWidget(
          posts: controller.postsData,
        );
      }),
    );
  }
}

class FollowingPosts extends StatelessWidget {
  FollowingPosts({Key? key}) : super(key: key);
  FeedController controller = Get.find();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> onRefresh() async {
    controller.getNewsFeed(type: "following");
    // refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: onRefresh,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: GetBuilder<FeedController>(builder: (controller) {
        if (controller.followingPostsData == null) {
          return LoaderClass();
        }
        if(controller.followingPostsData!.postModel!.isEmpty){
          return Center(
            child: Text(
              "No Data",
              style: poppinsBold(fontSize: 25),
            ),
          );
        }
        return FeedWidget(
          posts: controller.followingPostsData,
          type: "following",
        );
      }),
    );
  }
}

class EventPosts extends StatelessWidget {
  EventPosts({Key? key}) : super(key: key);
  FeedController controller = Get.find();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> onRefresh() async {
    controller.getNewsFeed(type: "event");
    // refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: onRefresh,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: GetBuilder<FeedController>(builder: (controller) {
        if (controller.eventPostsData == null) {
          return LoaderClass();
        }
        if(controller.eventPostsData!.postModel!.isEmpty){
         return Center(
            child: Text(
              "No Data",
              style: poppinsBold(fontSize: 25),
            ),
          );
        }
        if(controller.eventPostsData!.postModel!.isEmpty){
          return Center(
            child: Text(
              "No Data",
              style: poppinsBold(fontSize: 25),
            ),
          );
        }
        return FeedWidget(posts: controller.eventPostsData, type: "event");
      }),
    );
  }
}

class FeedWidget extends StatelessWidget {
   FeedWidget({
    this.posts,
    this.type = "all",
    super.key,
  });

  final Posts? posts;
  final String type;
  FeedController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels ==
            scrollNotification.metrics.maxScrollExtent) {
          print(scrollNotification);

          if (posts!.nextPageUrl != null) {
            if (controller.newsFeedWait == false) {
              controller.newsFeedWait = true;
              Future.delayed(Duration(seconds: 2), () {
                controller.newsFeedWait = false;
              });
              controller.getNewsFeed(fullUrl: posts!.nextPageUrl, type: type);
              return true;
            }
          }
          return false;
        }
        return false;
      },
      child: posts!.postModel!.isEmpty
          ? Center(
        child: Text(
          "No Data",
          style: poppinsBold(fontSize: 25),
        ),
      )
          : ListView.builder(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: posts!.postModel!.length,
          padding: EdgeInsets.zero,
          // physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if(posts!.postModel![index].isReported == 1 || posts!.postModel![index].eventsPost?.isReported == 1){
              return Container();
            }
            return Padding(
              padding: EdgeInsets.only(
                  bottom: posts!.postModel!.length - 1 == index
                      ? kToolbarHeight + 10
                      : 0),
              child: type == "event"?
                  // Container()
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5,),
                child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                        child: EventItemsClass(
                          index: index,
                          data: posts!.postModel![index].eventsPost!,
                          type: type,
                          fromFeeds: true,
                        ),
                      ),
                    ),
              )
                  :posts!.postModel![index].eventsPost != null?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5,),
                child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                    child: EventItemsClass(
                      index: index,
                      data: posts!.postModel![index].eventsPost!,
                      type: type,
                      fromFeeds: true,
                    ),
                  ),
                ),
              )
                  : PostClass(
                index: index,
                result: posts!.postModel![index],
              ),
            );
          }),
    );
  }
}


