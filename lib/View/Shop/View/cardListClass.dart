import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/View/Shop/Data/shopController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/radio_list_tile/gf_radio_list_tile.dart';


const double kCardHeight = 225;
const double kCardWidth = 356;

const double kSpaceBetweenCard = 24;
const double kSpaceBetweenUnselectCard = 32;
const double kSpaceUnselectedCardToTop = 320;

const Duration kAnimationDuration = Duration(milliseconds: 245);

class CardListClass extends StatelessWidget {
  CardListClass({super.key});

  final ShopController controller = Get.find();

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
          "Cards List",
          style:
          poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 24),
        ),
        elevation: 0,
      ),
      body: GetBuilder<ShopController>(
          initState: (x){
            controller.getCardList();
          },
          builder: (controller) {

        if(controller.cardListModel == null){
          return Center(
            child: LoaderClass(),
          );
        }
        if(controller.cardListModel!.data!.data!.isEmpty){
          return Center(
            child:  Text(
              "No Data",
              style: poppinsBold(fontSize: 25),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: controller.cardListModel!.data!.data!.length,
            itemBuilder: (context,index){
            return GFRadioListTile(
              value: index,
              groupValue: controller.cardListModel!.data!.data![index].isDefault == 1?index:null,
              // selected: controller.cardListModel!.data!.data![index].isDefault == 1? true:false,
              onChanged: (ind) {
                controller.changeDefaultCard(controller.cardListModel!.data!.data![index].id!);
              },
              titleText: controller.cardListModel!.data!.data![index].brand??"",
              subTitleText: controller.cardListModel!.data!.data![index].last4.toString(),
              icon: Image.asset(getCardType(controller.cardListModel!.data!.data![index].brand??""),height: 20,),
              activeIcon: Image.asset(getCardType(controller.cardListModel!.data!.data![index].brand??""),height: 20,),
              avatar: Image.asset(getCardType(controller.cardListModel!.data!.data![index].brand??""),height: 30,),
              radioColor: Color(0xffd51820),


            );
            
            });

        // return MainPage(
        //   creditCards: controller.cardListModel!.data!.data!.map((e) =>
        //       CreditCard(cardNumber: "************${e.last4}",
        //           expiryDate: "${e.expMonth}/${e.expYear}",cardType: e.brand??"",
        //           cardHolderName: e.name??"")).toList(),);
      }),
    );
  }

  String getCardType(value){
    switch(value){
      case "Visa":
        return "assets/shop/visa.png";
      case "Discover":
        return "assets/shop/discover.png";
      case "MasterCard":
        return "assets/shop/logo.png";
      case "AmericanExpress":
        return "assets/shop/american-express.png";
      default:
        return "assets/shop/card.png";
    }
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
    this.space = kSpaceBetweenCard,
    required this.creditCards,
  });

  final double space;
  final List<CreditCard> creditCards;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int? selectedCardIndex;


  @override
  void initState() {
    super.initState();
  }

  int toUnselectedCardPositionIndex(int indexInAllList) {
    if (selectedCardIndex != null) {
      if (indexInAllList < selectedCardIndex!) {
        return indexInAllList;
      } else {
        return indexInAllList - 1;
      }
    } else {
      throw 'Wrong usage';
    }
  }

  double _getCardTopPosititoned(int index, isSelected) {
    if (selectedCardIndex != null) {
      if (isSelected) {
        return widget.space;
      } else {
        /// Space from top to place put unselect cards.
        return kSpaceUnselectedCardToTop +
            toUnselectedCardPositionIndex(index) * kSpaceBetweenUnselectCard;
      }
    } else {
      /// Top first emptySpace + CardSpace + emptySpace + ...
      return widget.space + index * kCardHeight + index * widget.space;
    }
  }

  double _getCardScale(int index, isSelected) {
    if (selectedCardIndex != null) {
      if (isSelected) {
        return 1.0;
      } else {
        int totalUnselectCard = widget.creditCards.length - 1;
        return 1.0 -
            (totalUnselectCard - toUnselectedCardPositionIndex(index) - 1) *
                0.05;
      }
    } else {
      return 1.0;
    }
  }

  void unSelectCard() {
    setState(() {
      selectedCardIndex = null;
    });
  }

  double totalHeightTotalCard() {
    if (selectedCardIndex == null) {
      final totalCard = widget.creditCards.length;
      return widget.space * (totalCard + 1) + kCardHeight * totalCard;
    } else {
      return kSpaceUnselectedCardToTop +
          kCardHeight +
          (widget.creditCards.length - 2) * kSpaceBetweenUnselectCard +
          kSpaceBetweenCard;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SizedBox.expand(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            AnimatedContainer(
              duration: kAnimationDuration,
              height: totalHeightTotalCard(),
              width: mediaQuery.size.width,
            ),
            for (int i = 0; i < widget.creditCards.length; i++)
              AnimatedPositioned(
                top: _getCardTopPosititoned(i, i == selectedCardIndex),
                duration: kAnimationDuration,
                child: AnimatedScale(
                  scale: _getCardScale(i, i == selectedCardIndex),
                  duration: kAnimationDuration,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCardIndex = i;
                      });
                    },
                    child: widget.creditCards[i],
                  ),
                ),
              ),
            if (selectedCardIndex != null)
              Positioned.fill(
                  child: GestureDetector(
                    onVerticalDragEnd: (_) {
                      unSelectCard();
                    },
                    onVerticalDragStart: (_) {
                      unSelectCard();
                    },
                  ))
          ],
        ),
      ),
    );
  }
}

class CreditCard extends StatelessWidget {
  const CreditCard({
    super.key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cardType,
  });

  final String cardNumber;
  final String expiryDate;
  final String cardType;
  final String cardHolderName;

  // final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CreditCardWidget(
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cardHolderName: cardHolderName,
        cvvCode: "***",
        showBackView: false, 
        // cardType: getCardType(cardType),
        isSwipeGestureEnabled: false,
        height: kCardHeight,
        width: kCardWidth,
        obscureCardCvv: true,

        // glassmorphismConfig: Glassmorphism.defaultConfig(),
        // cardBgColor: backgroundColor,
        onCreditCardWidgetChange: (_) {},
      ),
    );
  }

  
}