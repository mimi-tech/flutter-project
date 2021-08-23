import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/models/sparks_user.dart';
import 'package:sparks/app_entry_and_home/screens/view_profile.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';

class SocialCard extends StatelessWidget {
  final String? profileImg;
  final String fullName;
  final String? discipline;
  final String? currentStatus;
  final String? profileId;

  SocialCard({
    required this.profileImg,
    required this.fullName,
    required this.discipline,
    required this.currentStatus,
    required this.profileId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //TODO: View user profile
        DocumentSnapshot<Map<String, dynamic>> dst =
            await CustomFunctions.viewingThisUserProfile(profileId, "Personal");
        SparksUser sUser = SparksUser.fromJson(dst.data()!);
        GlobalVariables.viewingProfileInfo = sUser;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewProfile(
              profileId: profileId,
              profileStatus: currentStatus,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 5.0,
        ),
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.35,
        child: Card(
          elevation: 3.0,
          shadowColor: kGreyLightShade,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: ClipOval(
                  child: Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          profileImg!,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Center(
                child: Text(
                  fullName,
                  style: Theme.of(context).textTheme.headline6!.apply(
                        color: kBlackcolor,
                        fontSizeFactor: 0.8,
                      ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Center(
                child: Text(
                  discipline!,
                  style: Theme.of(context).textTheme.headline6!.apply(
                        color: kHintColor,
                        fontSizeFactor: 0.6,
                      ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10.0,
                    left: 40.0,
                    right: 40.0,
                    bottom: 10.0,
                  ),
                  width: 200.0,
                  height: 25.0,
                  decoration: BoxDecoration(
                    color: kProfile,
                    border: Border.all(
                      color: kProfile,
                    ),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Text(
                    currentStatus!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kWhitecolor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
