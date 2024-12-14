import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';

class Referral extends StatelessWidget {
  const Referral({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Available to Withdraw",
                        style: montserratSemiBold(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "\$ 500",
                        style: montserratExtraBold(
                            fontSize: 26, color: DynamicColors.primaryColorRed),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        text: "Withdraw",
                        isLong: false,
                        onTap: () {},
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                        color: DynamicColors.primaryColorRed.withOpacity(0.3),
                        borderColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        style: poppinsSemiBold(
                            color: DynamicColors.primaryColorRed, fontSize: 12),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Divider(),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Referral Earning",
                                        style: montserratRegular(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "\$ 650",
                                        style: montserratExtraBold(
                                            fontSize: 20,
                                            color:
                                                DynamicColors.primaryColorRed),
                                      ),
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                    // color: Colors.black45,
                                    ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Pending Balance",
                                        style: montserratRegular(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "\$ 150",
                                        style: montserratExtraBold(
                                            fontSize: 20,
                                            color:
                                                DynamicColors.primaryColorRed),
                                      ),
                                    ],
                                  ),
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
          SizedBox(
            height: 20,
          ),
          Container(
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: DynamicColors.primaryColorRed.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Text(
                          "Invite & Earn",
                          style: montserratSemiBold(
                              color: DynamicColors.primaryColorRed,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: "WhatsApp",
                              onTap: () {},
                              padding: EdgeInsets.symmetric(
                                vertical: 7,
                              ),
                              color: Color(0xff00CE53),
                              borderColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              style: poppinsSemiBold(
                                  color: DynamicColors.whiteColor,
                                  fontSize: 12),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
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
                                  borderRadius: BorderRadius.circular(30)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Elusive.share,
                                  color: DynamicColors.primaryColorRed,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: DynamicColors.accentColor.withOpacity(0.3),
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "or",
                          style: montserratSemiBold(
                              fontSize: 20,
                              color:
                                  DynamicColors.accentColor.withOpacity(0.3)),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: DynamicColors.accentColor.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CustomButton(
                        onTap: () {},
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                        ),
                        color: Colors.white,
                        borderColor: DynamicColors.primaryColorRed,
                        borderRadius: BorderRadius.circular(30),
                        style: poppinsSemiBold(
                            color: DynamicColors.whiteColor, fontSize: 12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "https://adobe.ly/3Tv0Sw9",
                              style: montserratSemiBold(
                                  fontSize: 14,
                                  textDecoration: TextDecoration.underline),
                            ),
                            Spacer(),
                            CustomButton(
                              onTap: () {},
                              text: "Copy",
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                              color: DynamicColors.primaryColorRed,
                              borderColor: DynamicColors.primaryColorRed,
                              borderRadius: BorderRadius.circular(30),
                              style: poppinsSemiBold(
                                  color: DynamicColors.whiteColor,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Invite friends to the Bloodlines app and earn \$1 for every new account that registers using this referral link. Amount will be credited once the new user has paid their first subscription. To see the list of members that have signed up using your referral link click here.",
                        textAlign: TextAlign.center,
                        style: montserratSemiBold(fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
