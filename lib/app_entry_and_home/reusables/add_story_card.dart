import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class AddStoryCard extends StatelessWidget {
  final ImageProvider profileImage;

  AddStoryCard({
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.24,
      height: MediaQuery.of(context).size.height * 0.18,
      child: Stack(
        children: [
          Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                k20,
              ),
              side: BorderSide(
                color: kAddStoryCardBorderColour,
                width: 3.0,
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: profileImage,
                ),
                borderRadius: BorderRadius.circular(
                  k20,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.028,
              ),
              width: MediaQuery.of(context).size.width * 0.22,
              height: MediaQuery.of(context).size.height * 0.04,
              decoration: BoxDecoration(
                color: kWhiteColour,
                border: Border(
                  top: BorderSide(
                    color: kWhiteColour,
                  ),
                  bottom: BorderSide(
                    color: kWhiteColour,
                  ),
                  left: BorderSide(
                    color: kWhiteColour,
                  ),
                  right: BorderSide(
                    color: kWhiteColour,
                  ),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    k20,
                  ),
                  bottomLeft: Radius.circular(
                    k20,
                  ),
                  bottomRight: Radius.circular(
                    k20,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                  ),
                  Text(
                    "Add Story",
                    style: Theme.of(context).textTheme.headline6!.apply(
                          fontSizeFactor: 0.6,
                        ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              kMe,
              style: Theme.of(context).textTheme.headline6!.apply(
                    fontSizeFactor: 0.7,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
