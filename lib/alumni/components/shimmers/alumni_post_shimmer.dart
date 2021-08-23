import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparks/utilities/colors.dart';

class AlumniPostShimmer extends StatelessWidget {
  const AlumniPostShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kGreyColor,
      highlightColor: kBlurColor,
      period: Duration(seconds: 3),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.only(
              bottom: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 32.0,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 8.0,
                          width: MediaQuery.of(context).size.width * 0.16,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Container(
                          height: 8.0,
                          width: MediaQuery.of(context).size.width * 0.08,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Container(
                          height: 8.0,
                          width: MediaQuery.of(context).size.width * 0.16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  height: 96.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Container(
                      color: Colors.white,
                      height: 20.0,
                      width: 56.0,
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Container(
                      color: Colors.white,
                      height: 20.0,
                      width: 56.0,
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Container(
                      color: Colors.white,
                      height: 20.0,
                      width: 56.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.24,
                  height: 8.0,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
