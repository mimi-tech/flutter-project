import 'package:flutter/material.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class AniminatedImagePicker extends StatefulWidget {
  const AniminatedImagePicker({Key? key}) : super(key: key);

  @override
  _AniminatedImagePickerState createState() => _AniminatedImagePickerState();
}

class _AniminatedImagePickerState extends State<AniminatedImagePicker>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1,

      /// Ellis => I added this as it was required
      //opacity: Variables.viewVisible ? 1.0 : 0.0,
      duration: Duration(seconds: 3),
      child: Visibility(
        //visible:Variables.viewVisible,
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            child: InkWell(
                              onTap: () {
                                //Variables.getImageFromGallery();
                              },
                              child: CircleAvatar(
                                child: Image(
                                  image: AssetImage('images/Gallery.png'),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            kGallerylive,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: kBlackcolor,
                              fontFamily: 'Rajdhani',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            child: InkWell(
                              onTap: () {
                                //Variables.getImageFromCamera();
                              },
                              child: CircleAvatar(
                                child: Image(
                                  image: AssetImage('images/camera.png'),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            kCameralive,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: kBlackcolor,
                              fontFamily: 'Rajdhani',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            child: InkWell(
                              onTap: () {
                                //Variables.getImageFromGallery();
                              },
                              child: CircleAvatar(
                                child: Image(
                                  image: AssetImage('images/document.png'),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            kDocumentlive,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: kBlackcolor,
                              fontFamily: 'Rajdhani',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ]),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            child: CircleAvatar(
                              child: Image(
                                image: AssetImage('images/dropbox.png'),
                              ),
                            ),
                          ),
                          Text(
                            kDropboxlive,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: kBlackcolor,
                              fontFamily: 'Rajdhani',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            child: CircleAvatar(
                              child: Image(
                                image: AssetImage('images/google_drive.png'),
                              ),
                            ),
                          ),
                          Text(
                            kGoogledrivelive,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: kBlackcolor,
                              fontFamily: 'Rajdhani',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            child: CircleAvatar(
                              child: Image(
                                image: AssetImage('images/one_drive.png'),
                              ),
                            ),
                          ),
                          Text(
                            kOneDrivelive,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: kBlackcolor,
                              fontFamily: 'Rajdhani',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ]),
              ],
            ),
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: kAshthumbnailcolor,
                  blurRadius: 15.0, // soften the shadow
                  spreadRadius: 2.0, //extend the shadow

                  offset: Offset(
                    3.0, // Move to right 10  horizontally
                    3.0,
                    // Move to bottom 10 Vertically
                  ),
                )
              ],
              color: Colors.white.withOpacity(Variables.controller.value),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
