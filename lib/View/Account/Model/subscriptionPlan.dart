import 'package:get/get.dart';

class SubscriptionPlan {
  String title;

  SubscriptionPlan(
      {this.title = "Monthly Plan", this.price = "\$1.99", this.isSelected});

  String price;
  RxBool? isSelected;
}

List<SubscriptionPlan> subscriptionPlansList = [
  SubscriptionPlan(isSelected: true.obs),
  SubscriptionPlan(title: "Yearly Plan", price: "\$20", isSelected: false.obs),
];
