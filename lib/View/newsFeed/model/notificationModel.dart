class NotificationModel {
  String image;
  String name;
  String status;
  String type;
  String time;

  NotificationModel({
    required this.image,
    required this.name,
    required this.status,
    required this.type,
    required this.time,
  });
}

List<NotificationModel> notificationList = [
  NotificationModel(
    image: "assets/avatar/1.png",
    name: "David Silbia",
      status: " send you Follow Request ",
    type: "request",
    time: "Just Now",
  ),
  NotificationModel(
    image: "assets/avatar/2.png",
    name: "Jazz bin",
    status: " like your photo",
    type: "normal",
    time: "5 min ago",
  ),
  NotificationModel(
    image: "assets/avatar/3.png",
    name: "Joan Baker",
    status: " send you Follow Request in ",
    type: "request",
    time: "20 min ago",
  ),
];
