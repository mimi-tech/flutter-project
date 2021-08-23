import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ProfilePix extends StatelessWidget {
  ProfilePix({required this.pix});
  final String pix;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl:pix,
        imageBuilder: (context, imageProvider) => Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(

            shape: BoxShape.circle,
            image: DecorationImage(
                image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) =>  SvgPicture.asset('images/classroom/user.svg')
    );
  }
}
