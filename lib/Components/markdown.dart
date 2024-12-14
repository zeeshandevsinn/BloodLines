import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/readmore.dart';
import 'package:bloodlines/userModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:markdown/markdown.dart' as md;

class ColoredBoxInlineSyntax extends md.InlineSyntax {
  ColoredBoxInlineSyntax({
    String pattern = r'\[(.*?)\]',
  }) : super(pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    /// This creates a new element with the tag name `coloredBox`
    /// The `textContent` of this new tag will be the
    /// pattern match with the @ symbol
    ///
    /// We can change how this looks by creating a custom
    /// [MarkdownElementBuilder] from the `flutter_markdown` package.
    final withoutBracket1 = match.group(0)!.replaceAll('[', "");
    final withoutBracket2 = withoutBracket1.replaceAll(']', "");
    md.Element mentionedElement =
        md.Element.text("coloredBox", withoutBracket2);
    print('Mentioned user ${mentionedElement.textContent}');
    parser.addNode(mentionedElement);
    return true;
  }
}

class ColoredBoxMarkdownElementBuilder extends MarkdownElementBuilder {
  final BuildContext context;
  final List<String?> mentionedUsers;
  final FeedController controller = Get.find();

  ColoredBoxMarkdownElementBuilder(
    this.context,
    this.mentionedUsers,
  );

  ///This method would help us figure out if the text element needs styling
  ///The background color of the text would be Color(0xffDCECF9) if it is the
  ///sender's name that is mentioned in the text, otherwise it would be transparent
  Color _backgroundColorForElement(String text) {
    Color color = Colors.transparent;
    // if (mentionedUsers.isNotEmpty) {
    //   color = Colors.black12;
    // }
    return color;
  }

  ///This method would help us figure out if the text element needs styling
  ///The text color would be blue if the text is a user's name and is mentioned
  ///in the text
  Color _textColorForBackground(
      Color backgroundColor, String textContent,
      // UserModel user
      ) {
    return Colors.blue;
    // return user.blockBy == true || user.isBlock == true
    //     ? Colors.grey
    //     : checkIfFormattingNeeded(textContent)
    //     ? Colors.blue
    //     : Colors.black;
  }

  String getUserID(String text) {
    controller.usersList.map((u) => u.id).toSet().forEach((userName) {
      text = userName.toString();
    });
    return text;
  }

  // String _replaceMentions(String text) {
  //   controller.usersList
  //       .map((u) => "${u.profile!.fullname}")
  //       .toSet()
  //       .forEach((userName) {
  //     text = text.replaceAll('@$userName', '[$userName]');
  //   });
  //   return text;
  // }
  //
  // @override
  // Widget? visitText(md.Text? text, TextStyle? preferredStyle) {
  //   return ReadMoreText(
  //     text!.textContent,
  //     trimLines: 2,
  //     style: preferredStyle,
  //   );
  // }

  @override
  Widget visitElementAfter(md.Element? element, TextStyle? preferredStyle) {
    // super.visitElementAfter(element!, preferredStyle);
    return Container(
      margin: EdgeInsets.only(left: 0, right: 0, top: 2, bottom: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: _backgroundColorForElement(element!.textContent),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: () {
            // if (checkIfFormattingNeeded(element.textContent)) {
            //
            // }
            for (int i = 0; i < controller.usersList.length; i++) {
              if (element.textContent ==
                  "${controller.usersList[i].profile!.fullname}") {
                Utils.onNavigateTimeline(controller.usersList[i].id!);

              }
            }
          },
          child: Text(
            element.textContent,
            style: poppinsRegular(
              fontSize: 15,
              color: _textColorForBackground(
                _backgroundColorForElement(
                  element.textContent.replaceAll('@', ''),
                ),
                element.textContent.replaceAll('@', ''),

                // controller.usersList.singleWhere(
                //     (e) => e.profile.fullname == element.textContent),
              ),
              fontWeight: checkIfFormattingNeeded(
                element.textContent.replaceAll('@', ''),
              )
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  bool checkIfFormattingNeeded(String text) {
    var checkIfFormattingNeeded = false;
    if (mentionedUsers.isNotEmpty) {
      if (mentionedUsers.contains(text)) {
        checkIfFormattingNeeded = true;
      } else {
        checkIfFormattingNeeded = false;
      }
    }
    return checkIfFormattingNeeded;
  }
}
