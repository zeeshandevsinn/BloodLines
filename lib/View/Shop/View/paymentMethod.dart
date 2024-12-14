import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Shop/Data/shopController.dart';
import 'package:bloodlines/View/Shop/Model/cardList.dart';
import 'package:bloodlines/View/Shop/Model/transactionModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:get/get.dart';
import 'package:graphview/GraphView.dart';

class PaymentMethod extends StatefulWidget {
  PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  ShopController controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getCardList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicColors.primaryColorLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: AppBarWidgets(),
        title: Text(
          "Payment Methods",
          style:
              poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 24),
        ),
        elevation: 0,
      ),
      body: GetBuilder<ShopController>(builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              creditCardCheck(),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                text: "Add New Card",
                onTap: () {
                  Get.bottomSheet(
                    CardDialog(),
                    enableDrag: true,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30))),
                  );
                },
                isLong: false,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                borderRadius: BorderRadius.circular(5),
                margin: EdgeInsets.symmetric(vertical: 10),
                color: DynamicColors.primaryColorRed,
                borderColor: DynamicColors.primaryColorRed,
                style: montserratSemiBold(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: DynamicColors.whiteColor),
              ),
              // SizedBox(
              //   height: 10,
              // ),

              // SizedBox(
              //   height: 20,
              // ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Recent Transactions",
                          style: montserratBold(fontSize: 24),
                        ),
                        Spacer(),
                        Text(
                          "See all",
                          style: montserratSemiBold(fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: transactionList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[300]!,
                                    blurRadius: 10.0,
                                  ),
                                ],
                              ),
                              child: Card(
                                surfaceTintColor:
                                    DynamicColors.primaryColorLight,
                                color: DynamicColors.primaryColorLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    transactionList[index]
                                                        .image))),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              transactionList[index].name,
                                              style:
                                                  montserratBold(fontSize: 15),
                                            ),
                                            Text(
                                              transactionList[index].quantity,
                                              style: montserratLight(
                                                  fontSize: 11,
                                                  color: DynamicColors
                                                      .accentColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            transactionList[index].price,
                                            style: montserratSemiBold(
                                                fontSize: 14,
                                                color: DynamicColors
                                                    .primaryColorRed),
                                          ),
                                          Text(
                                            transactionList[index].date,
                                            style: montserratLight(
                                                fontSize: 11,
                                                color:
                                                    DynamicColors.accentColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget creditCardCheck(){
    if(controller.cardListModel!= null){
      if(controller.cardListModel!.data!.data!.isEmpty){
        return buildCreditCardWidget("5469567598122568",
          "12",
          "25",
          "Kate Winslett",
          "123",);
      }
      CardDetails details = controller.cardListModel!.data!.data!.singleWhere((e) =>e.isDefault == 1);
      return buildCreditCardWidget("${getCardType(details.brand??"")}12341234${details.last4!}",
        details.expMonth.toString(),
        details.expYear.toString(),
        details.name??"",
        "***");
    }else{
     return buildCreditCardWidget("5469567598122568",
        "12",
        "25",
        "Kate Winslett",
        "123",);
    }
  }

  String getCardType(value){
    switch(value){
      case "Visa":
        return "4242";
      case "Discover":
        return "6542";
      case "MasterCard":
        return "5442";
      case "AmericanExpress":
        return "3737";
      default:
        return "4242";
    }
  }

  Widget buildCreditCardWidget(String cardNumber,String expireMonth,String expireYear,String name,String cvv) {
    return CreditCardWidget(
      cardNumber: cardNumber,
      expiryDate: "$expireMonth/$expireYear",
      isHolderNameVisible: true,
      bankNameWidget: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Elusive.pencil,
            color: DynamicColors.primaryColorLight,
            size: 18,
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
                color: DynamicColors.greenColor, shape: BoxShape.circle),
            child: Padding(
              padding: EdgeInsets.all(1.0),
              child: Icon(
                Icons.check,
                color: DynamicColors.primaryColor,
                size: 18,
              ),
            ),
          ),
        ],
      ),
      cardHolderName: name,
      cardBgColor: DynamicColors.primaryColor,
      cvvCode: cvv,
      showBackView: false,
      onCreditCardWidgetChange:
          (creditCardBrand) {}, //true when you want to show cvv(back) view
    );
  }
}

class CardDialog extends StatelessWidget {
  CardDialog({super.key});

  ShopController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isCvvFocused = false;
  String cardNumber = "";
  String cardHolder = "";
  String cardExpiry = "";
  String cardCvv = "";

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<ShopController>(builder: (controller) {
        return Wrap(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              child: Container(
                decoration: BoxDecoration(
                  color: DynamicColors.primaryColorLight,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                ),
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Container(
                              height: 10,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: DynamicColors.primaryColor,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CreditCardWidget(
                            cardNumber: cardNumber,
                            cardHolderName: cardHolder,
                            expiryDate: cardExpiry,
                            cvvCode: cardCvv,
                            showBackView: isCvvFocused,
                            obscureCardNumber: true,
                            obscureCardCvv: true,
                            isHolderNameVisible: true,
                            cardBgColor: DynamicColors.primaryColor,
                            isSwipeGestureEnabled: true,
                            onCreditCardWidgetChange:
                                (CreditCardBrand creditCardBrand) {
                              print("change");
                            },
                            // customCardTypeIcons: <CustomCardTypeIcon>[
                            //   CustomCardTypeIcon(
                            //     cardType: CardType.mastercard,
                            //     cardImage: Image.asset(
                            //       'icons/mastercard.png',
                            //       height: 48,
                            //       width: 48,
                            //     ),
                            //   ),
                            // ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CreditCardForm(
                            formKey: formKey,
                            obscureCvv: true,
                            obscureNumber: false,
                            cardNumber: controller.cardNumber.text,
                            cvvCode: controller.cvv.text,
                            isHolderNameVisible: true,
                            isCardNumberVisible: true,
                            isExpiryDateVisible: true,
                            cardHolderName: controller.cardHolder.text,
                            expiryDate: controller.expiry.text,
                            themeColor: Colors.blue,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // expiryDateValidator: (date){
                            //   print(date);
                            // },
                            textColor: DynamicColors.primaryColor,
                            cardNumberDecoration: InputDecoration(
                              hintText: '0000 1111 2222 3333',
                              fillColor:
                                  DynamicColors.accentColor.withOpacity(0.3),
                              filled: true,
                              border: InputBorder.none,
                              hintStyle: montserratRegular(
                                  fontSize: 16,
                                  color: DynamicColors.accentColor),
                              labelStyle: montserratRegular(
                                  fontSize: 16,
                                  color: DynamicColors.primaryColor),
                            ),
                            expiryDateDecoration: InputDecoration(
                              hintStyle: montserratRegular(
                                  fontSize: 16,
                                  color: DynamicColors.accentColor),
                              labelStyle: montserratRegular(
                                  fontSize: 16,
                                  color: DynamicColors.primaryColor),
                              fillColor:
                                  DynamicColors.accentColor.withOpacity(0.3),
                              filled: true,
                              border: InputBorder.none,
                              hintText: '12/22',
                            ),
                            cvvCodeDecoration: InputDecoration(
                              hintStyle: montserratRegular(
                                  fontSize: 16,
                                  color: DynamicColors.accentColor),
                              labelStyle: montserratRegular(
                                  fontSize: 16,
                                  color: DynamicColors.primaryColor),
                              fillColor:
                                  DynamicColors.accentColor.withOpacity(0.3),
                              filled: true,
                              border: InputBorder.none,
                              hintText: "***",
                            ),
                            cardHolderDecoration: InputDecoration(
                                hintStyle: montserratRegular(
                                    fontSize: 16,
                                    color: DynamicColors.accentColor),
                                labelStyle: montserratRegular(
                                    fontSize: 16,
                                    color: DynamicColors.primaryColor),
                                fillColor:
                                    DynamicColors.accentColor.withOpacity(0.3),
                                filled: true,
                                border: InputBorder.none,
                                hintText: "Mark Anderson"),
                            onCreditCardModelChange: (a) {
                              cardNumber = a.cardNumber;
                              cardHolder = a.cardHolderName;

                              cardExpiry = a.expiryDate;
                              cardCvv = a.cvvCode;
                              isCvvFocused = a.isCvvFocused;
                              controller.update();
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                            text: "Add",
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                if (cardExpiry.isNotEmpty) {
                                  if (cardExpiry.contains("/")) {
                                    final split = cardExpiry.split("/");
                                    var a = DateTime.now()
                                        .year
                                        .toString()
                                        .substring(2, 4);
                                    if (int.parse(split[1].toString()) >=
                                        int.parse(a)) {
                                      if (int.parse(split[0].toString()) <=
                                          12) {
                                        if (int.parse(split[1].toString()) -
                                                int.parse(a) <
                                            7) {
                                          controller.addNewCard(
                                              cardNumber,
                                              split[0].toString(),
                                              "20${split[1].toString()}",
                                              cardCvv);
                                        } else {
                                          BotToast.showText(
                                              text:
                                                  "Select year is way too big");
                                        }
                                      } else {
                                        BotToast.showText(
                                            text: "Expiry date is not correct");
                                      }
                                    } else {
                                      BotToast.showText(
                                          text: "You cannot select past year");
                                    }
                                  }
                                }
                              }
                              // Get.back();
                            },
                            isLong: false,
                            style: montserratSemiBold(
                                fontSize: 16,
                                color: DynamicColors.primaryColorRed),
                            color:
                                DynamicColors.primaryColorRed.withOpacity(0.3),
                            borderColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
