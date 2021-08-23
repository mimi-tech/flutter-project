import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

import 'package:sparks/schoolClassroom/studentFolder/studentsPost.dart';

import 'package:sparks/schoolClassroom/utils/profilPix.dart';
import 'package:sparks/schoolClassroom/utils/searchservice.dart';


class SearchStudent extends StatefulWidget {
  @override
  _SearchStudentState createState() => _SearchStudentState();
}

class _SearchStudentState extends State<SearchStudent> {
  List<DocumentSnapshot> queryResultSet = <DocumentSnapshot> [];
  List<DocumentSnapshot> tempSearchStore = <DocumentSnapshot> [];
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
  bool isPlaying = false;
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);
    print(capitalizedValue);
    if (queryResultSet.length == 0 && value.length == 1) {

      SearchService().searchByStudents(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i]);
        }
      });
    } else {


      tempSearchStore = [];

      queryResultSet.forEach((element) {
        if (element['fn'].startsWith(capitalizedValue)) {

          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
        appBar: AppBar(
          backgroundColor: kStatusbar,
          title: Text('Search for student',
            style: GoogleFonts.rajdhani(
              fontSize:kFontsize.sp,
              color: kWhitecolor,
              fontWeight: FontWeight.bold,

            ),),
        ),
        body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: false,
                floating: true,
                backgroundColor: kWhitecolor,
                automaticallyImplyLeading: false,
                //expandedHeight: 100,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    autofocus: true,
                    onChanged: (dynamic val) {
                      initiateSearch(val);
                    },
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.search),
                          iconSize: 20.0,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        contentPadding: EdgeInsets.only(left: 25.0),
                        hintText: 'Search by first name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0))),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([

                    tempSearchStore.length == 0?Text(''):
                    ListView.builder(
                        itemCount: tempSearchStore.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, int index) {

                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    ProfilePix(pix: tempSearchStore[index]['logo']),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        Text(tempSearchStore[index]['fn'],
                                          style: GoogleFonts.rajdhani(
                                            fontSize:kFontsize.sp,
                                            fontWeight: FontWeight.bold,
                                            color: kBlackcolor,
                                          ),
                                        ),
                                        Text(tempSearchStore[index]['ln'],
                                          style: GoogleFonts.rajdhani(
                                            fontSize:kFontsize.sp,
                                            fontWeight: FontWeight.bold,
                                            color: kIconColor,
                                          ),
                                        ),            ],
                                    ),

                                    Spacer(),
                                    Icon(Icons.circle,color:tempSearchStore[index]['ass'] == true?kAGreen:kRed ,size: 15,)

                                  ],
                                ),
                                space(),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize:MainAxisSize.min,
                                        children: [
                                          Text(SchClassConstant.isUniStudent?'${tempSearchStore[index]['cl']} department':tempSearchStore[index]['cl'],
                                            overflow:TextOverflow.ellipsis,
                                            softWrap:true,
                                            maxLines:1,
                                            style: GoogleFonts.rajdhani(
                                              fontSize:kFontsize.sp,
                                              fontWeight: FontWeight.bold,
                                              color: klistnmber,
                                            ),
                                          ),
                                          space(),
                                          Text(tempSearchStore[index]['lv'],
                                            overflow:TextOverflow.ellipsis,
                                            softWrap:true,
                                            maxLines:1,
                                            style: GoogleFonts.rajdhani(
                                              fontSize:kFontsize.sp,
                                              fontWeight: FontWeight.bold,
                                              color: kBlackcolor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Spacer(),
                                    SchClassConstant.isUniStudent? BtnBorder(next: (){
                                      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentsPostScreen(doc:tempSearchStore[index])));

                                    }, title: 'Post', bgColor: kWhitecolor):Text('')
                                  ],
                                )

                              ],
                            ),
                          );

                        }),

                  ]
                  )
              )])));
  }



}

