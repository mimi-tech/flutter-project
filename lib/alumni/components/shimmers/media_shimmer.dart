import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparks/utilities/colors.dart';

class MediaShimmer extends StatelessWidget {
  const MediaShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kGreyColor,
      highlightColor: kBlurColor,
      period: Duration(seconds: 3),
      child: Container(
        color: kWhiteColor,
      ),
    );
  }
}
