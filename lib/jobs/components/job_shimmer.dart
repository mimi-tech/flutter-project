import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparks/utilities/colors.dart';

class JobShimmer extends StatelessWidget {
  const JobShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kGreyColor,
      highlightColor: kBlurColor,
      period: Duration(seconds: 3),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Container(
                            height: 8.0,
                            width: MediaQuery.of(context).size.width * 0.16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Container(
                        height: 8.0,
                        width: MediaQuery.of(context).size.width * 0.24,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 8.0,
                        width: MediaQuery.of(context).size.width * 0.24,
                        color: Colors.white,
                      ),
                      Container(
                        height: 8.0,
                        width: MediaQuery.of(context).size.width * 0.24,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 8.0,
                        width: MediaQuery.of(context).size.width * 0.24,
                        color: Colors.white,
                      ),
                      Container(
                        height: 8.0,
                        width: MediaQuery.of(context).size.width * 0.24,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 8.0,
                        width: MediaQuery.of(context).size.width * 0.24,
                        color: Colors.white,
                      ),
                      Container(
                        height: 24.0,
                        width: MediaQuery.of(context).size.width * 0.24,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
