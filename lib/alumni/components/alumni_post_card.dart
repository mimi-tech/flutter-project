import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparks/utilities/colors.dart';
import 'package:sparks/utilities/styles.dart';

class AlumniPostCard extends StatelessWidget {
  const AlumniPostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: 8.0,
        right: 8.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 8.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    /// user image avatar
                    CircleAvatar(
                      radius: 30.0, // Change to 28.0 if too large
                      backgroundImage: AssetImage('images/alumni/pic8.png'),
                    ),

                    SizedBox(
                      width: 8.0,
                    ),

                    /// Username, user interest, timestamp
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Dummy name",
                          style: kTextStyleFont15Bold.copyWith(
                            fontSize: 18.0,
                          ),
                        ),
                        // SizedBox(
                        //   height: 8.0,
                        // ),
                        Text(
                          "Dummy interests",
                          style: kTextStyleFont15SemiBold.copyWith(
                            fontSize: 12.0,
                          ),
                        ),
                        // SizedBox(
                        //   height: 8.0,
                        // ),
                        Text(
                          "Dummy timestamp",
                          style: kTextStyleFont15Medium.copyWith(
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.person),
              ],
            ),
            SizedBox(
              height: 24.0,
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                "images/alumni/testing.png",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),

            /// Like, Comment and Share icons
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite,
                    color: kIconAndLabelInactive,
                  ),
                  label: Text(
                    "Dummy",
                    style: kTextStyleFont15SemiBold.copyWith(
                      fontSize: 12.0,
                      color: kIconAndLabelInactive,
                    ),
                  ),
                ),
                SizedBox(
                  width: 32.0,
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: FaIcon(
                    FontAwesomeIcons.solidComment,
                    color: kIconAndLabelInactive,
                  ),
                  label: Text(
                    "Dummy",
                    style: kTextStyleFont15SemiBold.copyWith(
                      fontSize: 12.0,
                      color: kIconAndLabelInactive,
                    ),
                  ),
                ),
                SizedBox(
                  width: 32.0,
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "images/app_entry_and_home/new_images/sparks_share.svg",
                    color: kIconAndLabelInactive,
                  ),
                  label: Text(
                    "Dummy",
                    style: kTextStyleFont15SemiBold.copyWith(
                      fontSize: 12.0,
                      color: kIconAndLabelInactive,
                    ),
                  ),
                ),
              ],
            ),

            /// User state
            Text(
              "From Dummy state",
              style: kTextStyleFont15Medium.copyWith(
                fontSize: 12.0,
              ),
            ),
            SizedBox(
              height: 4.0,
            ),

            /// User country
            Text(
              "Dummy country",
              style: kTextStyleFont15Medium.copyWith(
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
