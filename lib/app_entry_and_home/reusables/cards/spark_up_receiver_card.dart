import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

class SparkUpReceiverCard extends StatefulWidget {
  double width;
  double height;
  String profileImg;
  String name;
  String message;
  String acceptText;
  Function acceptRequest;

  SparkUpReceiverCard({
    required this.width,
    required this.height,
    required this.name,
    required this.profileImg,
    required this.message,
    required this.acceptText,
    required this.acceptRequest,
  });

  @override
  _SparkUpReceiverCardState createState() => _SparkUpReceiverCardState();
}

class _SparkUpReceiverCardState extends State<SparkUpReceiverCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.all(10.0),
      width: widget.width,
      height: widget.height,
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: kLeaveGreen,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                left: 14.0,
                right: 10.0,
              ),
              child: ClipOval(
                child: Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                      color: kWhitecolor,
                      border: Border(
                        top: BorderSide(
                          color: kWhitecolor,
                          width: 3.0,
                        ),
                        left: BorderSide(
                          color: kWhitecolor,
                          width: 3.0,
                        ),
                        right: BorderSide(
                          color: kWhitecolor,
                          width: 3.0,
                        ),
                        bottom: BorderSide(
                          color: kWhitecolor,
                          width: 3.0,
                        ),
                      ),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          widget.profileImg,
                        ),
                      )),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.005,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.70,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.name,
                            style: Theme.of(context).textTheme.headline6!.apply(
                                  fontSizeFactor: 0.8,
                                  fontWeightDelta: 2,
                                  color: kWhitecolor,
                                ),
                          ),
                          TextSpan(
                            text: " wants to ignite the spark with you.",
                            style: Theme.of(context).textTheme.headline6!.apply(
                                  fontSizeFactor: 0.8,
                                  color: kWhitecolor,
                                ),
                          ),
                          TextSpan(
                            text: widget.message,
                            style: Theme.of(context).textTheme.headline6!.apply(
                                  fontSizeFactor: 0.8,
                                  color: kWhitecolor,
                                ),
                          ),
                        ],
                      ),
                    )),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.70,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: widget.acceptRequest as void Function()?,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.03,
                      decoration: BoxDecoration(
                        color: kWhitecolor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Text(
                          widget.acceptText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kLeaveGreen,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
