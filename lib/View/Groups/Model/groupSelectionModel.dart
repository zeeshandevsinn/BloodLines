import 'package:get/get.dart';

class GroupSelectionModel {
  String name;

  GroupSelectionModel({this.name = "Free Group", this.isSelected});

  RxBool? isSelected;
}

List<GroupSelectionModel> groupSelectionModelList = [
  GroupSelectionModel(isSelected: false.obs),
  GroupSelectionModel(name: "Subscription Group", isSelected: true.obs),
];
