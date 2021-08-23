import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PostBgImageChoice extends StatefulWidget {
  final String customBgImageUrl;
  final String fontFamily;
  final Color fontColor;

  PostBgImageChoice({
    required this.customBgImageUrl,
    required this.fontFamily,
    required this.fontColor,
  });

  @override
  _PostBgImageChoiceState createState() => _PostBgImageChoiceState();
}

class _PostBgImageChoiceState extends State<PostBgImageChoice> {
  TextEditingController postController = TextEditingController();
  int? numberOfWords = 0;

  //TODO: This function counts the number of words typed by a user in a given post.
  _postWordCounter() {
    int wordCounter = 0;

    String word = postController.text;
    wordCounter = word.split(" ").length;
    GlobalVariables.customText = word;

    setState(() {
      numberOfWords = postFontChange(wordCounter);
    });
  }

  //TODO: This function changes the font size of the post message.
  int? postFontChange(int numberOfWordsPresent) {
    int? fontSize;

    if (numberOfWordsPresent == 1) {
      fontSize = 32;
      GlobalVariables.customTextPostFontSize = fontSize;
    } else if ((numberOfWordsPresent > 1) && (numberOfWordsPresent <= 10)) {
      fontSize = 32;
      GlobalVariables.customTextPostFontSize = fontSize;
    } else if ((numberOfWordsPresent > 10) && (numberOfWordsPresent <= 20)) {
      fontSize = 28;
      GlobalVariables.customTextPostFontSize = fontSize;
    } else if ((numberOfWordsPresent > 20) && (numberOfWordsPresent <= 30)) {
      fontSize = 20;
      GlobalVariables.customTextPostFontSize = fontSize;
    } else if (numberOfWordsPresent > 30) {
      fontSize = 18;
      GlobalVariables.customTextPostFontSize = fontSize;
    }

    return fontSize;
  }

  @override
  void initState() {
    //TODO: Add a listener to the postController created.
    postController.addListener(_postWordCounter);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.30,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.customBgImageUrl),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.06,
        right: MediaQuery.of(context).size.width * 0.06,
        top: MediaQuery.of(context).size.height * 0.03,
        bottom: MediaQuery.of(context).size.height * 0.03,
      ),
      child: Center(
        child: TextFormField(
          controller: postController,
          keyboardType: TextInputType.multiline,
          textAlign: TextAlign.center,
          maxLengthEnforced: false,
          minLines: 1,
          maxLines: double.maxFinite.floor(),
          cursorColor: widget.fontColor,
          textCapitalization: TextCapitalization.none,
          style: TextStyle(
            color: widget.fontColor,
            fontFamily: widget.fontFamily,
            fontSize: numberOfWords!.sp,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: kHint_Make_A_Post,
            hintStyle: TextStyle(
              color: widget.fontColor,
              fontFamily: widget.fontFamily,
              fontSize: kSize_32.sp,
            ),
          ),
        ),
      ),
    );
  }
}
