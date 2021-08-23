import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class DisplayUserStoryCard extends StatelessWidget {
  final ImageProvider profileImage;
  final String? profileUsername;

  DisplayUserStoryCard({
    required this.profileImage,
    required this.profileUsername,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: k5,
      ),
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
                color: kDisplayStoryBorderColour,
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
            child: Text(
              profileUsername!,
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
