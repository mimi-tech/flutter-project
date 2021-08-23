import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparks/alumni/components/alumni_post_card.dart';
import 'package:sparks/alumni/components/alumni_search_create_post_chat.dart';
import 'package:sparks/alumni/components/alumni_tv_reel_card.dart';
import 'package:sparks/alumni/components/label_icon_elevated_button.dart';
import 'package:sparks/utilities/colors.dart';
import 'package:sparks/utilities/styles.dart';

class AlumniMySet extends StatefulWidget {
  const AlumniMySet({Key? key}) : super(key: key);

  @override
  _AlumniMySetState createState() => _AlumniMySetState();
}

class _AlumniMySetState extends State<AlumniMySet>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// TODO: Change SingleChildScrollView to NestedScrollView if controlling multiple
    return SingleChildScrollView(
      child: Column(
        children: [
          /// Search, Create Post & Sparks Chat Widget
          AlumniSearchCreatePostChat(),
          SizedBox(
            height: 24.0,
          ),

          /// Sparks TV Button
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: LabelIconElevatedButton(
                onPressed: () {},
                label: "my set",
              ),
            ),
          ),
          Divider(),

          /// Sparks TV Reels
          Container(
            height: 296.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: kBlurColor,
                  offset: Offset(0, 3),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                AlumniTVReelCard(),
                AlumniTVReelCard(),
                AlumniTVReelCard(),
                AlumniTVReelCard(),
              ],
            ),
          ),

          AlumniPostCard(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
