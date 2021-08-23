import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
class StudentPostListItems extends StatefulWidget {
  StudentPostListItems({required this.doc});
  final DocumentSnapshot doc;

  @override
  _StudentPostListItemsState createState() => _StudentPostListItemsState();
}

class _StudentPostListItemsState extends State<StudentPostListItems> {
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: Duration(milliseconds: 400),
          curve: Curves.decelerate,
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: kHorizontal),
              child: widget.doc['stId']== SchClassConstant.schDoc['id']?ListTile(
    onTap: (){
      _deletePost();
    },
                 leading: Icon(Icons.delete,color: kRed,),
                    title:Text(kDel.toUpperCase(),
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kBlackcolor,
                          fontSize: kFontsize.sp,
                        ),
                      ),
                    ),



              ):Text('')),
    ));
  }

  void _deletePost() {
    FirebaseFirestore.instance.collection(
        'schoolPost').doc(SchClassConstant.schDoc['schId']).collection('campusPost').doc(widget.doc['id']).delete();

    SchClassConstant.displayToastCorrect(title: 'Deleted successfully');
  }
}
