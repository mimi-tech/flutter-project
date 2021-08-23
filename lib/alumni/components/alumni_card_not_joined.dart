import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/utilities/colors.dart';
import 'package:sparks/utilities/styles.dart';

class AlumniCardNotJoined extends StatelessWidget {
  final String schoolName;
  final String schoolStreet;
  final String schoolCity;
  final String schoolState;
  final String schoolCountry;
  final String schoolLogo;
  final bool isAlumni;
  final Function onPressed;

  AlumniCardNotJoined(
      {required this.schoolName,
      required this.schoolStreet,
      required this.schoolCity,
      required this.schoolState,
      required this.schoolCountry,
      required this.schoolLogo,
      required this.isAlumni,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 20.0, bottom: 20.0),
            child: Row(
              children: <Widget>[
                /// Institution's image logo
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 28.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: CachedNetworkImage(
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                        child: CircularProgressIndicator(
                          backgroundColor: kMarketPrimaryColor,
                          value: progress.progress,
                        ),
                      ),

                      /// TODO: Put a proper fall-back image
                      imageUrl: schoolLogo,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /// Institution name and icon
                        Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'images/alumni/institution_icon.svg',
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Flexible(
                              child: Text(
                                ReusableFunctions.capitalize(schoolName),
                                style: kTextStyleFont15SemiBold.copyWith(
                                    fontSize: 20.0),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 16.0,
                        ),

                        /// Institution's location and state
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              size: 24.0,
                            ),
                            SizedBox(
                              width: 6.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  schoolStreet,
                                  style: kTextStyleFont15Medium,
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  "$schoolState, $schoolCountry.",
                                  style: kTextStyleFont15Medium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomRight: Radius.circular(5.0),
              ),
            ),
            onPressed: onPressed as void Function()?,
            splashColor: kAWhite,
            child: Text(
              "Join alumni",
              style: kTextStyleFont15Bold.copyWith(
                  fontSize: 16.0, color: kWhiteColor),
            ),
            color: kADeepOrange,
          ),
        ],
      ),
    );
  }
}
