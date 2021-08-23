import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/schoolClassroom/CampusSchool/edit_tutors.dart';

import 'package:sparks/schoolClassroom/campus_appbar.dart';
import 'package:sparks/schoolClassroom/campus_searchAppbar.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class CampusLecturersLevel extends StatefulWidget {
  CampusLecturersLevel({required this.doc,required this.name,required this.level});
  final List<dynamic> doc;
  final String name;
  final dynamic level;
  @override
  _CampusLecturersLevelState createState() => _CampusLecturersLevelState();
}

class _CampusLecturersLevelState extends State<CampusLecturersLevel> {
  Widget space(){
    return SizedBox(height:  MediaQuery.of(context).size.height * 0.02,);
  }


  StreamController<List<DocumentSnapshot>> _streamController =
  StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _products = [];

  bool _isRequesting = false;
  bool _isFinish = false;
  bool isLoading = false;
  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;
    documentChanges.forEach((productChange) {
      if (productChange.type == DocumentChangeType.removed) {
        _products.removeWhere((product) {
          return productChange.doc.id == product.id;
        });
        isChange = true;
      } else {

        if (productChange.type == DocumentChangeType.modified) {
          int indexWhere = _products.indexWhere((product) {
            return productChange.doc.id == product.id;
          });

          if (indexWhere >= 0) {
            _products[indexWhere] = productChange.doc;
          }
          isChange = true;
        }
      }
    });

    if(isChange) {
      _streamController.add(_products);
    }
  }

  @override
  void initState() {

    FirebaseFirestore.instance.collection('schoolTutors').doc(SchClassConstant.schDoc['schId']).collection('tutors')
        .where('facId',isEqualTo: widget.doc[0]['id'])
        .where('dept',isEqualTo: widget.name)
        .where('lv',isEqualTo: widget.level)
        .orderBy('ts',descending: true)

        .snapshots()
        .listen((data) => onChangeData(data.docChanges));

    requestNextPage();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
  late Widget f;

  List<dynamic> levelCount = <dynamic>[];
  List<dynamic> levelSorted = <dynamic>[];
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
            requestNextPage();
          }
          return true;
        },
        child: SafeArea(
            child: Scaffold(
                appBar:CampusDeptAppbar(name: widget.name,),

                body: CustomScrollView(slivers: <Widget>[
                  CampusSearchAppBar(filter:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: getLevel(),
                  ),),
                  SliverList(
                    delegate: SliverChildListDelegate([

                      Container(
                          child: Column(
                              children: [
                                space(),

                                space(),
                                Text('List of departmental courses & tutors [${widget.level}]'.toUpperCase(),
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kBlackcolor,
                                      fontSize: kFontSize14.sp,
                                    ),
                                  ),

                                ),
                                space(),

                                StreamBuilder<List<DocumentSnapshot>>(
                                    stream: _streamController.stream,

                                    builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                                      if(snapshot.data == null){
                                        return Center(child: Text('Loading...'));
                                      } else if(snapshot.data!.isEmpty){
                                        return Text('Loading');
                                      }else{
                                        return Column(
                                            children: snapshot.data!.map((doc) {
                                           Map<String, dynamic> data = doc as Map<String, dynamic>;

                                              addLevels(doc);

                                              return Card(
                                                  elevation: 10,
                                                  child:Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Tutor's name",
                                                          style: GoogleFonts.rajdhani(
                                                            decoration: TextDecoration.underline,
                                                            textStyle: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: kExpertColor,
                                                              fontSize: kFontsize.sp,
                                                            ),
                                                          ),

                                                        ),

                                                        Text(data['tc'].toString(),
                                                          style: GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              color: kBlackcolor,
                                                              fontSize: kFontsize.sp,
                                                            ),
                                                          ),

                                                        ),


                                                        data['ass'] == true?
                                                        BtnThird(next: (){_removeTeacher(doc);}, title: 'Denial', bgColor: kAGreen)

                                                            :BtnThird(next: (){_acceptTeacher(doc);}, title: 'Accept', bgColor: kFbColor),


                                                        Divider(),


                                                        space(),
                                                        ShowRichText(color:kSwitchoffColors,title: 'Pin: ',titleText: data['pin'].toString()),


                                                        space(),

                                                        ShowRichText(color:kExpertColor,title: 'Tutor Level: ',titleText: data['lv']),


                                                        space(),
                                                        ShowRichText(color:kExpertColor,title: 'Tutor course: ',titleText: data['curs']),

                                                        space(),
                                                        ShowRichText(color:kFbColor,title: 'Added: ',titleText: '${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(data['ts']))} : ${DateFormat('h:m:a').format(DateTime.parse(data['ts']))}'),



                                                        space(),
                                                        ShowRichText(color:kAGreen,title: 'By: ',titleText: data['by']),

                                                        space(),
                                                        Divider(),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [

                                                            BtnThird(next: (){ _deleteTeacher(doc);}, title: 'Remove', bgColor: kRed),

                                                            RaisedButton(onPressed: (){
                                                              _editTeacher(doc);
                                                            },
                                                              color: kWhitecolor,
                                                              child: Text('Edit',
                                                                style: GoogleFonts.rajdhani(
                                                                  textStyle: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    color: kFbColor,
                                                                    fontSize: kFontsize.sp,
                                                                  ),
                                                                ),

                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                              );
                                            }).toList()

                                        );

                                      }
                                    }),
                                _isFinish == false ?
                                isLoading == true ? Center(
                                    child: PlatformCircularProgressIndicator()) : Text('')

                                    : Text(''),
                              ])
                      ),
                    ]),
                  ),
                ])
            )));
  }


  void _deleteTeacher(DocumentSnapshot doc) {
    //remove Admin
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{

      FirebaseFirestore.instance.collection('schoolTutors').doc(data['schId']).collection('tutors').doc(data['id'])

          .delete();

    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _removeTeacher(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{

      FirebaseFirestore.instance.collection('schoolTutors').doc(data['schId']).collection('tutors').doc(data['id'])
          .update({
        'ass':false,
      });
    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _acceptTeacher(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{

      FirebaseFirestore.instance.collection('schoolTutors').doc(data['schId']).collection('tutors').doc(data['id'])
          .update({
        'ass':true,
      });
    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _editTeacher(DocumentSnapshot doc) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            child: EditCampusTutors(doc:doc)));
//edit students profile here



  }

  void requestNextPage() async {

    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;


      if (_products.isEmpty) {

        querySnapshot = await FirebaseFirestore.instance.collection('schoolTutors').doc(SchClassConstant.schDoc['schId']).collection('tutors')
            .where('facId',isEqualTo: widget.doc[0]['id'])
            .where('dept',isEqualTo: widget.name)
            .where('lv',isEqualTo: widget.level)

            .orderBy('ts',descending: true)

            .limit(SchClassConstant.streamCount)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });
        querySnapshot = await FirebaseFirestore.instance.collection('schoolTutors').doc(SchClassConstant.schDoc['schId']).collection('tutors')
            .where('facId',isEqualTo: widget.doc[0]['id'])
            .where('dept',isEqualTo: widget.name)
            .where('lv',isEqualTo: widget.level)

            .orderBy('ts',descending: true)

            .startAfterDocument(_products[_products.length - 1])
            .limit(SchClassConstant.streamCount)
            .get();
      }

      if (querySnapshot != null) {
        int oldSize = _products.length;
        _products.addAll(querySnapshot.docs);
        int newSize = _products.length;
        if (oldSize != newSize) {
          _streamController.add(_products);
        } else {
          setState(() {
            _isFinish = true;
            isLoading = false;
          });
        }
      }
      _isRequesting = false;
    }
  }

  void addLevels(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    for(int i = 0; i < data.length; i++){
      levelCount.add(data['lv']);
    }


  }
  List<Widget> getLevel(){
    levelSorted.clear();
    levelSorted.addAll(levelCount.toList().toSet());

    List<Widget> list =  <Widget>[];
    for(var i = 0; i < levelSorted.length; i++){
      Widget w =  Padding(padding: EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CampusLecturersLevel(name: widget.name,doc: widget.doc,level:levelSorted[i])));
          },
          child: Text(levelSorted[i].toString(),
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kBlackcolor,
                fontSize: kFontSize14.sp,
              ),
            ),

          ),
        ),
      );
      list.add(w);
    }
    return list;
  }
}
