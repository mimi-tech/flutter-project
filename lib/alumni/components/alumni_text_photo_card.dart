import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/alumni/components/shimmers/media_shimmer.dart';
import 'package:sparks/alumni/models/alumni_post.dart';
import 'package:sparks/alumni/utilities/alumni_utils.dart';
import 'package:sparks/utilities/colors.dart';
import 'package:sparks/utilities/styles.dart';

class AlumniTextPhotoCard extends StatelessWidget {
  const AlumniTextPhotoCard({
    Key? key,
    required this.alumniPost,
  }) : super(key: key);

  final AlumniPost alumniPost;

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
                      backgroundImage:
                          CachedNetworkImageProvider(alumniPost.pImg!),
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
                          "${alumniPost.name}",
                          style: kTextStyleFont15Bold.copyWith(
                            fontSize: 18.0,
                          ),
                        ),
                        // SizedBox(
                        //   height: 8.0,
                        // ),

                        Text(
                          "${alumniPost.areaOfInterest!.join(" ")}",
                          style: kTextStyleFont15SemiBold.copyWith(
                            fontSize: 12.0,
                            color: Color(0xff989898),
                          ),
                        ),
                        // SizedBox(
                        //   height: 8.0,
                        // ),
                        Text(
                          "${AlumniUtils.timeStampIntToElapsedString(alumniPost.ts!)}",
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
            ReadMoreText(
              "${alumniPost.text}",
              style: kTextStyleFont15Medium,
              moreStyle: kTextStyleFont15SemiBold.copyWith(
                color: kPrimaryColor,
                fontSize: 12.0,
              ),
              lessStyle: kTextStyleFont15SemiBold.copyWith(
                color: kPrimaryColor,
                fontSize: 12.0,
              ),
              trimLength: 128,
              trimCollapsedText: "more",
              trimExpandedText: "less",
            ),
            SizedBox(
              height: 8.0,
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                progressIndicatorBuilder: (context, _, __) => MediaShimmer(),
                imageUrl: alumniPost.img![0],
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(
              height: 24.0,
            ),

            /// Like, Comment and Share icons
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                bottom: 16.0,
              ),
              child: Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: kIconAndLabelInactive,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      alumniPost.likesCount! >= 1
                          ? Text(
                              "${alumniPost.likesCount}",
                              style: kTextStyleFont15SemiBold.copyWith(
                                fontSize: 12.0,
                                color: kIconAndLabelInactive,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  SizedBox(
                    width: 32.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.solidComment,
                        color: kIconAndLabelInactive,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      alumniPost.commentsCount! >= 1
                          ? Text(
                              "${alumniPost.commentsCount}",
                              style: kTextStyleFont15SemiBold.copyWith(
                                fontSize: 12.0,
                                color: kIconAndLabelInactive,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  SizedBox(
                    width: 32.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        "images/app_entry_and_home/new_images/sparks_share.svg",
                        color: kIconAndLabelInactive,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      alumniPost.sharesCount! >= 1
                          ? Text(
                              "${alumniPost.sharesCount}",
                              style: kTextStyleFont15SemiBold.copyWith(
                                fontSize: 12.0,
                                color: kIconAndLabelInactive,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),

            /// User state
            Text(
              "${alumniPost.state}",
              style: kTextStyleFont15Medium.copyWith(
                fontSize: 12.0,
              ),
            ),
            SizedBox(
              height: 4.0,
            ),

            /// User country
            Text(
              "${alumniPost.country}",
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
