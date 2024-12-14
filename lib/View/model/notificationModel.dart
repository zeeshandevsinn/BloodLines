class NotificationModel {
  String image;
  String name;
  String status;
  String profile;
  String type;
  String time;

  NotificationModel({
    required this.image,
    required this.name,
    required this.status,
    required this.profile,
    required this.type,
    required this.time,
  });
}

List<NotificationModel> notificationList = [
  NotificationModel(
    image: "assets/avatar/3.png",
    name: "David Silbia",
    status: " send you Follow Request ",
    profile: "",
    type: "request",
    time: "Just Now",
  ),
  NotificationModel(
    image: "assets/avatar/8.png",
    name: "Jazz bin",
    status: " like your photo",
    profile: "",
    type: "normal",
    time: "5 min ago",
  ),
  NotificationModel(
    image: "assets/avatar/6.png",
    name: "Joan Baker",
    status: " send you Follow Request in ",
    profile: "Alter Ego",
    type: "request",
    time: "20 min ago",
  ),
];
