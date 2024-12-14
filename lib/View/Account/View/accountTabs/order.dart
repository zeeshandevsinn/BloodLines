import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:flutter/material.dart';

class Order extends StatelessWidget {
  const Order({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Today",
              style: montserratSemiBold(
                  fontSize: 24, color: DynamicColors.accentColor),
            ),
            SizedBox(
              height: 20,
            ),
            productWidget(),
            SizedBox(
              height: 30,
            ),
            Text(
              "30, Sep 2022",
              style: montserratSemiBold(
                  fontSize: 24, color: DynamicColors.accentColor),
            ),
            SizedBox(
              height: 20,
            ),
            productWidget(),
          ],
        ),
      ),
    );
  }

  Widget productWidget() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Expanded(flex: 4, child: Image.asset("assets/products/2.png")),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Wellness CORE Natural Grain Ocean Whitefish, Herring & Salmon Dry Dog Food, 22 lbs.",
                        style: montserratBold(fontSize: 12),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            Text(
                              "\$44.98",
                              style: montserratExtraBold(fontSize: 14),
                            ),
                            Spacer(),
                            Text(
                              "02",
                              style: montserratExtraBold(
                                  fontSize: 14,
                                  color: DynamicColors.primaryColorRed),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Order Number",
                        style: montserratBold(fontSize: 14),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "1536546548654",
                        style: montserratSemiBold(fontSize: 14),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
