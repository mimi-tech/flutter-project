import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparks/utilities/colors.dart';

class AlumniSchoolShimmer extends StatelessWidget {
  const AlumniSchoolShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kGreyColor,
      highlightColor: kBlurColor,
      period: Duration(seconds: 3),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 32.0,
                backgroundColor: Colors.white,
              ),
              title: Container(
                height: 8.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    height: 8.0,
                    width: MediaQuery.of(context).size.width * 0.56,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    height: 8.0,
                    width: MediaQuery.of(context).size.width * 0.32,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
