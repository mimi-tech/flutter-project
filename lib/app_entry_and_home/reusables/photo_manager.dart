import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/reusables/photo_view.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';

class PhotoManager extends StatelessWidget {
  final List<ImageProvider>? photoAlbum;

  PhotoManager({
    this.photoAlbum,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.50,
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                GlobalVariables.gallery = photoAlbum;
                Navigator.pushNamed(
                  (context),
                  PhotoView.id,
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.30,
                margin: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: photoAlbum!.length > 0
                        ? photoAlbum![0]
                        : AssetImage("images/photo_album/plain1.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.145,
              margin: EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        GlobalVariables.gallery = photoAlbum;
                        Navigator.pushNamed(
                          (context),
                          PhotoView.id,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: photoAlbum!.length > 1
                                ? photoAlbum![1]
                                : AssetImage("images/photo_album/plain1.jpg"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.035,
                  ),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        GlobalVariables.gallery = photoAlbum;
                        Navigator.pushNamed(
                          (context),
                          PhotoView.id,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: photoAlbum!.length > 2
                                ? photoAlbum![2]
                                : AssetImage("images/photo_album/plain1.jpg"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.035,
                  ),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        GlobalVariables.gallery = photoAlbum;
                        Navigator.pushNamed(
                          (context),
                          PhotoView.id,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: photoAlbum!.length > 3
                                ? photoAlbum![3]
                                : AssetImage("images/photo_album/plain1.jpg"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            photoAlbum!.length <= 4
                                ? ""
                                : "${photoAlbum!.length - 4}+",
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontSize: kFont_Size.sp,
                                fontWeight: FontWeight.w900,
                                color: kWhiteColour,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
