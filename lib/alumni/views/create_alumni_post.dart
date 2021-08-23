import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparks/alumni/models/alumni_post.dart';
import 'package:sparks/alumni/services/alumni_db.dart';
import 'package:sparks/alumni/static_variables/alumni_globals.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/market/components/custom_image_picker_box.dart';
import 'package:sparks/market/components/image_add_icon_and_text.dart';

/// This is a temporary class to be replaced by the Sparks home
/// implementation
class CreateAlumniPost extends StatefulWidget {
  const CreateAlumniPost({Key? key}) : super(key: key);

  /// TODO: Add profilePic string variable

  @override
  _CreateAlumniPostState createState() => _CreateAlumniPostState();
}

class _CreateAlumniPostState extends State<CreateAlumniPost> {
  final _picker = ImagePicker();

  // TextEditingController _textEditingController = TextEditingController();

  File? _postImage;

  String _postText = "";

  Future getImageFromGallery() async {
    final pickedFile = await (_picker.getImage(source: ImageSource.gallery)
        as Future<PickedFile>);

    String pickedFilePath = pickedFile.path;

    setState(() => _postImage = File(pickedFilePath));
  }

  void _uploadPostToDB() async {
    if (_postText.isNotEmpty && _postImage != null) {
      List<String?>? userAreaOfInterest = [];

      if (GlobalVariables.loggedInUserObject.aoi!.length > 2) {
        userAreaOfInterest =
            GlobalVariables.loggedInUserObject.aoi!.sublist(0, 2);
      } else {
        userAreaOfInterest = GlobalVariables.loggedInUserObject.aoi;
      }

      AlumniPost alumniPost = AlumniPost(
          id: AlumniGlobals.currentAlumniUser!.id!,
          docId: null,
          ts: DateTime.now().millisecondsSinceEpoch,
          yr: AlumniGlobals.currentAlumniUser!.yr,
          dept: AlumniGlobals.currentAlumniUser!.dept,
          text: _postText,
          commentsCount: 0,
          likesCount: 0,
          sharesCount: 0,
          state: GlobalVariables.loggedInUserObject.addr!["st"],
          country: GlobalVariables.loggedInUserObject.addr!["cty"],
          areaOfInterest: userAreaOfInterest,
          name: AlumniGlobals.currentAlumniUser!.name,
          type: "text_photo",
          img: [] // Will be added in the database service method
          );

      AlumniDB alumniDB = AlumniDB();

      alumniDB.pushTextImagePost(
        alumniPost: alumniPost,
        files: [_postImage],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kLight_orange,
          title: Text(
            kCreate_post,
            style: GoogleFonts.rajdhani(
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            //TODO: Create the post/submit post button.
            IconButton(
              onPressed: () {
                _uploadPostToDB();
              },
              icon: Image.asset(
                "images/app_entry_and_home/post_btn.png",
              ),
              padding: EdgeInsets.only(right: 15.0),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                // controller: _textEditingController,
                onChanged: (String value) {
                  _postText = value.trim();
                },
              ),
              SizedBox(
                height: 40.0,
              ),
              _postImage == null
                  ? CustomImagePickerBox(
                      widget: ImageAddIconAndText(buttonText: "Add post image"),
                      onTap: () {
                        getImageFromGallery();
                      },
                    )
                  : Image.file(
                      _postImage!,
                      fit: BoxFit.cover,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
