// // import 'package:carousel_pro/carousel_pro.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import '../utilities/market_const.dart';

class MarketItemsCarousel extends StatefulWidget {
  MarketItemsCarousel({this.images, required this.showIndicator});

  final List<dynamic>? images;
  final bool showIndicator;

  @override
  _MarketItemsCarouselState createState() => _MarketItemsCarouselState();
}

class _MarketItemsCarouselState extends State<MarketItemsCarousel>
    with AutomaticKeepAliveClientMixin {
  int initialCounter = 1;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Carousel(
            autoplay: false,
            showIndicator: widget.showIndicator,
            images: widget.images!,
            dotSize: 4.0,
            dotBgColor: Colors.transparent,
            dotColor: Color(0xff727C8E).withOpacity(0.2),
            dotIncreasedColor: Color(0xff727C8E),
            onImageChange: (prev, next) {
              print('Previous: $prev');
              print('Next: $next');
              setState(() {
                initialCounter = next + 1;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 24.0, right: 8.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                "$initialCounter/${widget.images!.length}",
                style: kImageCounterTextStyle,
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
