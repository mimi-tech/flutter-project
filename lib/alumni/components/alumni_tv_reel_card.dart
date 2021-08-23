import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/market/utilities/market_brain.dart';
import 'package:sparks/utilities/colors.dart';
import 'package:sparks/utilities/styles.dart';

class AlumniTVReelCard extends StatelessWidget {
  const AlumniTVReelCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      margin: const EdgeInsets.only(right: 10.0),
      width: MediaQuery.of(context).size.width * 0.64, // 64% of screen space
      child: Card(
        margin: const EdgeInsets.only(left: 10.0),
        elevation: 1.0,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  /// User image, user name, user location
                  Flexible(
                    child: Row(
                      children: [
                        /// Image of user
                        CircleAvatar(
                          backgroundImage: AssetImage('images/alumni/pic8.png'),
                        ),

                        SizedBox(
                          width: 8.0,
                        ),

                        /// Name & Location of User
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Dummy name",
                                style: kTextStyleFont15Bold.copyWith(
                                    fontSize: 13.0),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Dummy location",
                                style: kTextStyleFont15Medium.copyWith(
                                    fontSize: 9.0),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// View icon & view count
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.remove_red_eye,
                        color: kPrimaryColor,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        "${MarketBrain.numberFormatter(398888)}",
                        style:
                            kTextStyleFont15SemiBold.copyWith(fontSize: 10.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.0,
            ),

            /// TODO: Create a StatelessWidget using a Stack Widget for the image and icon to the top right
            /// Broadcast image
            GestureDetector(
              onTap: () {
                /// TODO: Take the user to the live stream
              },
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  "images/alumni/testing.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),

            /// Broadcast title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Dummy summary of broadcast",
                style: kTextStyleFont15SemiBold.copyWith(fontSize: 14.0),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),

            /// Broadcaster's profile and Sparks add icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      /// TODO: Navigate to broadcaster's profile
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(8.0),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(kPrimaryColor),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "Profile",
                      style: kTextStyleFont15Bold.copyWith(
                          fontSize: 11.0, color: kWhiteColor),
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      /// TODO: Send Sparks request
                    },
                    icon: SvgPicture.asset(
                      "images/alumni/add_user.svg",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
