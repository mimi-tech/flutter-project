import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class SinglePortfolio extends StatefulWidget {
  @override
  _SinglePortfolioState createState() => _SinglePortfolioState();
}

class _SinglePortfolioState extends State<SinglePortfolio> {
  int? imageIndex;
  LiquidController? liquidController;
  int likes = ProfessionalStorage.portfolioImageLike!;

  void likeButton() {
    setState(() {
      likes += 1;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    liquidController = LiquidController();
    super.initState();
    setState(() {
      imageIndex = ProfessionalStorage.portfolioImageIndex;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    FirebaseFirestore.instance
        .collection('PortfolioImagesView')
        .doc(ProfessionalStorage.portfolioImageClickedId)
        .update({
      'likes': likes,
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenData = MediaQuery.of(context).size;

    List<Widget> imageCards = [];

    for (var imageUrl in ProfessionalStorage.portfolioImageUrls!) {
      final imageWidget = Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black54, width: 4),
          //borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
            height: ScreenUtil().setHeight(500.0),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            )),
      );

      imageCards.add(imageWidget);
    }

    setState(() {
      imageIndex = ProfessionalStorage.portfolioImageIndex;
    });
    pageChangeCallback(int page) {
      setState(() {
        imageIndex = page;
      });
    }

    return SafeArea(
      child: Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            elevation: 0.7,
            automaticallyImplyLeading: true,
            backgroundColor: kLight_orange,
            centerTitle: true,
            title: Padding(
              padding: EdgeInsets.only(left: 18.0),
              child: Text(
                '${ProfessionalStorage.portfolioImageSingleCategory} Category',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(18.0),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          body: Stack(
            children: [
              LiquidSwipe(
                  initialPage: imageIndex!,
                  onPageChangeCallback: pageChangeCallback,
                  waveType: WaveType.liquidReveal,
                  liquidController: liquidController,
                  ignoreUserGestureWhileAnimating: true,
                  pages: imageCards),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 60.0),
                child: Column(
                  children: <Widget>[
                    Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            likeButton();
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 45.0,
                              ),
                              Text(
                                '$likes Likes',
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(18),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: FlatButton(
                    onPressed: () {
                      liquidController!.animateToPage(
                          page: imageCards.length - 1, duration: 500);
                    },
                    child: Text(
                      "Skip to End",
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    color: kLight_orange,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: FlatButton(
                    onPressed: () {
                      liquidController!
                          .jumpToPage(page: liquidController!.currentPage + 1);
                    },
                    child: Text(
                      "Next",
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    color: kLight_orange,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
