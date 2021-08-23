import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/utils/searchservice.dart';


class SearchStudentAttendedClasses extends StatefulWidget {
  @override
  _SearchStudentAttendedClassesState createState() => _SearchStudentAttendedClassesState();
}

class _SearchStudentAttendedClassesState extends State<SearchStudentAttendedClasses> {
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

      SearchService().searchByStudentsAttendedClasses(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i]);
        }
      });
    } else {


      tempSearchStore = [];

      queryResultSet.forEach((element) {
        if (element['cn'].startsWith(capitalizedValue)) {

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
          title: Text('Search for course / subject',
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
                        hintText: 'Search by Course name',
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
                          Map<String, dynamic> data = tempSearchStore[index]
                              .data() as Map<String, dynamic>;
                          return Column(
                            children: [
                              Card(
                                elevation: 10,
                                color: kCardFillColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(child: Row(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            child: Icon(Icons.tv_off),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius
                                                    .circular(6.0),
                                                color: klistnmber
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('${data['cn']}',
                                                overflow: TextOverflow
                                                    .ellipsis,
                                                softWrap: true,
                                                maxLines: 1,
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight
                                                        .bold,
                                                    color: kBlackcolor,
                                                    fontSize: kFontSize14.sp,
                                                  ),
                                                ),

                                              ),
                                              Container(
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxWidth: ScreenUtil()
                                                        .setWidth(150),
                                                    minHeight: ScreenUtil()
                                                        .setHeight(
                                                        constrainedReadMoreHeight),
                                                  ),
                                                  child: ReadMoreText(
                                                    data['tp'],

                                                    trimLines: 1,
                                                    colorClickableText: Colors
                                                        .pink,
                                                    trimMode: TrimMode.Line,
                                                    trimCollapsedText: ' ...',
                                                    trimExpandedText: 'show less',
                                                    style: GoogleFonts
                                                        .rajdhani(
                                                      textStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                            .w500,
                                                        color: kBlackcolor,
                                                        fontSize: kFontSize14.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),


                                            ],
                                          ),

                                          Spacer(),
                                          Column(
                                            children: [
                                              Material(
                                                color: kRed,
                                                child: Text('Live',
                                                  style: GoogleFonts
                                                      .rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      color: kWhitecolor,
                                                      fontSize:kFontsize.sp,
                                                    ),
                                                  ),
                                                ),


                                              ),

                                            ],
                                          )
                                        ],
                                      )),

                                      Divider(),

                                      Text(data['tsn'],
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: kBlackcolor,
                                            fontSize:kFontsize.sp,
                                          ),
                                        ),
                                      ),


                                      Text('Class date: ${DateFormat(
                                          'EE d, MMM yyyy: hh:mma').format(
                                          DateTime.parse(data['ts']))}',
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: kExpertColor,
                                            fontSize: kFontsize.sp,
                                          ),
                                        ),
                                      ),


                                      SizedBox(height: 10,),


                                    ],
                                  ),
                                ),
                              )],
                          );

                        }),

                  ]
                  )
              )])));
  }



}

