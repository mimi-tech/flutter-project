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
import 'package:sparks/schoolClassroom/CampusSchool/add_campus_students.dart';
import 'package:sparks/schoolClassroom/CampusSchool/edit_campus_student.dart';

import 'package:sparks/schoolClassroom/SchoolAdmin/add_new_students.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/edit_students.dart';
import 'package:sparks/schoolClassroom/campus_searchAppbar.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class CampusSearchByDepartment extends StatefulWidget {
  CampusSearchByDepartment({required this.level});
  final dynamic level;

  @override
  _CampusSearchByDepartmentState createState() =>
      _CampusSearchByDepartmentState();
}

class _CampusSearchByDepartmentState extends State<CampusSearchByDepartment> {
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
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

    if (isChange) {
      _streamController.add(_products);
    }
  }

  @override
  void initState() {
    getDepartments();

    FirebaseFirestore.instance
        .collectionGroup('campusStudents')
        .where('schId', isEqualTo: SchClassConstant.schDoc['schId'])
        .where('dept', isEqualTo: widget.level)
        .orderBy('ts', descending: true)
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

  List<dynamic> levelSorted = <dynamic>[];
  List<Widget> getLevel() {
    List<Widget> list = [];
    for (var i = 0; i < levelSorted.length; i++) {
      Widget w = Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () {
            //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CampusLecturersLevel(name: widget.name,doc: widget.doc,level:levelSorted[i])));
          },
          child: Text(
            levelSorted[i].toString(),
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
            body: CustomScrollView(slivers: <Widget>[
              CampusStudentSearchAppBar(
                filter: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: getLevel(),
                ),
                click: () {
                  _addNewStudent();
                },
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                        child: Column(children: [
                          space(),
                          Text(
                            'List of your school students'.toUpperCase(),
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackcolor,
                                fontSize: kFontsize.sp,
                              ),
                            ),
                          ),
                          Text(
                            '[${widget.level} department]'.toUpperCase(),
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kAGreen,
                                fontSize: kFontsize.sp,
                              ),
                            ),
                          ),
                          space(),
                          StreamBuilder<List<DocumentSnapshot>>(
                              stream: _streamController.stream,
                              builder: (context,
                                  AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                                if (snapshot.data == null) {
                                  return Center(child: Text('Loading...'));
                                } else {
                                  return Column(
                                      children: snapshot.data!.map((doc) {
                                        Map<String, dynamic> data =
                                        doc.data() as Map<String, dynamic>;
                                        return Card(
                                            elevation: 10,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor: Colors.transparent,
                                                        child: ClipOval(
                                                          child: FadeInImage.assetNetwork(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            fit: BoxFit.cover,
                                                            image:
                                                            ('images/classroom/user.png'
                                                                .toString()),
                                                            placeholder:
                                                            'images/classroom/user.png',
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            data['fn'].toString(),
                                                            style: GoogleFonts.rajdhani(
                                                              textStyle: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                color: kBlackcolor,
                                                                fontSize: kFontsize.sp,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            data['ln'].toString(),
                                                            style: GoogleFonts.rajdhani(
                                                              textStyle: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                color: kBlackcolor,
                                                                fontSize: kFontsize.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      data['ass'] == true
                                                          ? RaisedButton(
                                                        onPressed: () {
                                                          _removeStudent(doc);
                                                        },
                                                        color: kFbColor,
                                                        child: Text(
                                                          'Denial',
                                                          style: GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: kWhitecolor,
                                                              fontSize: kFontsize.sp,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                          : RaisedButton(
                                                        onPressed: () {
                                                          _acceptStudent(doc);
                                                        },
                                                        color: kFbColor,
                                                        child: Text(
                                                          'Accept',
                                                          style: GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: kWhitecolor,
                                                              fontSize: kFontsize.sp,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Divider(),

                                                  ///username
                                                  ShowRichText(
                                                      color: kSwitchoffColors,
                                                      title: 'Username: ',
                                                      titleText: data['un']),

                                                  space(),
                                                  ShowRichText(
                                                      color: kSwitchoffColors,
                                                      title: 'Pin: ',
                                                      titleText: data['pin'].toString()),

                                                  space(),

                                                  ShowRichText(
                                                      color: kExpertColor,
                                                      title: 'student Level: ',
                                                      titleText: data['lv']),

                                                  space(),
                                                  ShowRichText(
                                                      color: kExpertColor,
                                                      title: 'Student department: ',
                                                      titleText: data['dept']),

                                                  space(),
                                                  ShowRichText(
                                                      color: kExpertColor,
                                                      title: 'Student faculty: ',
                                                      titleText: data['fac']),

                                                  space(),
                                                  ShowRichText(
                                                      color: kFbColor,
                                                      title: 'Added: ',
                                                      titleText:
                                                      '${DateFormat('EE, d MMM, yyyy').format(
                                                        DateTime.parse(
                                                          data['ts'],
                                                        ),
                                                      )} : ${DateFormat('h:m:a').format(
                                                        DateTime.parse(
                                                          data['ts'],
                                                        ),
                                                      )}'),

                                                  space(),
                                                  ShowRichText(
                                                      color: kFbColor,
                                                      title: 'By: ',
                                                      titleText: data['by']),

                                                  space(),
                                                  Divider(),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      RaisedButton(
                                                        onPressed: () {
                                                          _deleteStudent(doc);
                                                        },
                                                        color: kRed,
                                                        child: Text(
                                                          'Remove',
                                                          style: GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: kWhitecolor,
                                                              fontSize: kFontsize.sp,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      RaisedButton(
                                                        onPressed: () {
                                                          _editStudent(doc);
                                                        },
                                                        color: kWhitecolor,
                                                        child: Text(
                                                          'Edit',
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
                                            ));
                                      }).toList());
                                }
                              }),
                          _isFinish == false
                              ? isLoading == true
                              ? Center(child: PlatformCircularProgressIndicator())
                              : Text('')
                              : Text(''),
                        ])),
                  ]))
            ]),
          ),
        ));
  }

  void _addNewStudent() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade, child: AddCampusNewStudents()));
  }

  void _deleteStudent(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //remove Admin
    try {
      FirebaseFirestore.instance
          .collection('uniStudents')
          .doc(data['schId'])
          .collection('campusStudents')
          .doc(data['did'])
          .delete();
    } catch (e) {
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _removeStudent(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    try {
      FirebaseFirestore.instance
          .collection('uniStudents')
          .doc(data['schId'])
          .collection('campusStudents')
          .doc(data['did'])
          .update({
        'ass': false,
      });
    } catch (e) {
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _acceptStudent(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    try {
      FirebaseFirestore.instance
          .collection('uniStudents')
          .doc(data['schId'])
          .collection('campusStudents')
          .doc(data['did'])
          .update({
        'ass': true,
      });
    } catch (e) {
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _editStudent(DocumentSnapshot doc) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            child: EditCampusStudents(doc: doc)));
//edit students profile here
    /* showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return EditStudents(doc:workingDocuments[index]);
        });
*/
  }

  void requestNextPage() async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;

      if (_products.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collectionGroup('campusStudents')
            .where('schId', isEqualTo: SchClassConstant.schDoc['schId'])
            .where('dept', isEqualTo: widget.level)
            .orderBy('ts', descending: true)
            .limit(SchClassConstant.streamCount)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });
        querySnapshot = await FirebaseFirestore.instance
            .collectionGroup('campusStudents')
            .where('schId', isEqualTo: SchClassConstant.schDoc['schId'])
            .where('dept', isEqualTo: widget.level)
            .orderBy('ts', descending: true)
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

  Future<void> getDepartments() async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collectionGroup('deptList')
          .where('schId', isEqualTo: SchClassConstant.schDoc['schId'])
          .orderBy('ts', descending: true)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length != 0) {
        for (DocumentSnapshot document in documents) {
          Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
          setState(() {
            levelSorted.addAll(data!['dept']);
          });
          print(levelSorted);
        }
      } else {}
    } catch (e) {
      print(e);
    }
  }
}
