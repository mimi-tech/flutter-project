import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/alumni/views/create_alumni_post.dart';
import 'package:sparks/utilities/styles.dart';

class AlumniSearchCreatePostChat extends StatelessWidget {
  const AlumniSearchCreatePostChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            alignment: Alignment.centerLeft,
            icon: SvgPicture.asset(
              'images/market_images/search_right.svg',
              color: Colors.black,
              width: 20.0,
              height: 20.0,
              fit: BoxFit.cover,
            ),
            onPressed: () {
              /// TODO: Trigger search activity
            },
          ),
          GestureDetector(
            onTap: () {
              /// TODO: Trigger create post activity
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateAlumniPost(),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'images/alumni/create_post_icon.svg',
                  color: Colors.black,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  "Create post",
                  style: kTextStyleFont15SemiBold,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              /// TODO: Trigger alumni/Sparks chat
            },
            alignment: Alignment.centerRight,
            icon: SvgPicture.asset(
              "images/app_entry_and_home/new_images/sparks_chat.svg",
              width: 20.0,
              height: 20.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
