import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class ViewInsight extends StatefulWidget {
  @override
  _ViewInsightState createState() => _ViewInsightState();
}

class _ViewInsightState extends State<ViewInsight> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.7,
          automaticallyImplyLeading: true,
          backgroundColor: kLight_orange,
          centerTitle: true,
          title: Text(
            'View Insight',
            style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(18.0),
                fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    ProfileStorage.insightContent!['insightTitle'],
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(20),
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(250),
                width: ScreenUtil().setWidth(350),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: CachedNetworkImage(
                  imageUrl: ProfileStorage.insightContent!['image'],
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: 40.0,
                  height: 40.0,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  ProfileStorage.insightContent!['insightDescription'],
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(15),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
