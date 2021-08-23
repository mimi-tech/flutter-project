import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/social/socialConstants/user_desc.dart';
import 'package:video_player/video_player.dart';

class VideoText extends StatelessWidget {

  VideoText({
    required this.show,
    required this.thumbnail,
    required this.promo,
    required this.descFn,
    required this.descLn,
    required this.descPix,
    required this.descClick,
    required this.vido,



  });
  final Function show;
  final dynamic thumbnail;
  final dynamic promo;
  final dynamic vido;
  final dynamic descFn;
  final dynamic descLn;
  final dynamic descPix;
  final Function descClick;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap:show as void Function(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),

        child: Stack(
          // alignment: Alignment.center,
            children: <Widget>[

              promo == null && vido == null?
              //this is just an image
              ClipRRect(
                borderRadius: BorderRadius.circular(kSocialVideoCurve),

                child: FadeInImage.assetNetwork(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * kSocialVideoCurve2,
                  fit: BoxFit.cover,
                  image: ('$thumbnail'.toString()),
                  placeholder: 'images/classroom/user.png',),
              ) :


              thumbnail == null? Container(
                width:MediaQuery.of(context).size.width,

                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * kSocialVideoCurve2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(kSocialVideoCurve),

                    child: ShowUploadedVideo(
                      videoPlayerController: VideoPlayerController.network(promo),
                      looping: false,
                    ),
                  ),
                ),
              ): ClipRRect(
                borderRadius: BorderRadius.circular(kSocialVideoCurve),

                child: Image.network(thumbnail,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * kSocialVideoCurve2,
                ),
              ),
              promo == null && vido == null?Text(''):Align(
                  alignment:Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset("images/classroom/uploadvideo.svg"),
                  )),



              Positioned(
                bottom:0,
                top:0,
                left:0,
                right:0,
                child: Align(
                    alignment:Alignment.bottomCenter,

                    child: UserDescription(text1: descPix,
                        text2: descFn,
                        text3: descLn,
                        text4: 'Not in uniform yet',//workingDocuments[index]['aoi'][0],
                        text5:kFollowings,
                        click:descClick
                    )
                ),
              ),


            ]),
      ),
    );
  }
}
