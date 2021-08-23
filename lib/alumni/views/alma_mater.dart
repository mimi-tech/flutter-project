import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sparks/alumni/components/alumni_card_joined.dart';
import 'package:sparks/alumni/components/alumni_persistent_header.dart';
import 'package:sparks/alumni/components/alumni_card_not_joined.dart';
import 'package:sparks/alumni/components/shimmers/alumni_school_shimmer.dart';
import 'package:sparks/alumni/models/alumni_school.dart';
import 'package:sparks/alumni/services/alumni_db.dart';
import 'package:sparks/alumni/utilities/alumni_db_const.dart';
import 'package:sparks/alumni/views/join_alumni_form.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/sparks_bottom_munus_enums.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/utilities/colors.dart';
import 'package:sparks/utilities/styles.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/alumni/static_variables/alumni_globals.dart';

class AlmaMater extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AlmaMaterState();
  }
}

class _AlmaMaterState extends State<AlmaMater>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late AlumniDB _alumniDB;

  SparksBottomMenu bottomMenuPressed = SparksBottomMenu.ALUMNI;

  StreamController<List<AlumniSchool>> _streamController =
      StreamController<List<AlumniSchool>>();

  ScrollController? _scrollController;

  late AnimationController _animationController;

  /// List of AlumniSchool objects that hold the list of schools to display as
  /// received from the StreamBuilder
  List<AlumniSchool> _schoolDocumentSnapshot = [];

  /// List of DocumentSnapshot that'll hold the last fetched set of document
  /// snapshots that'll be used to get the next set of data from the database
  List<DocumentSnapshot>? _previousDocSnapshot = [];

  /// This boolean variable is used to check whether the scroll position is close
  /// to the bottom of the scrollable widget. If "true" then fetch next set of
  /// document data
  bool _shouldCheck = false;

  /// This boolean variable is used to check whether the method [fetchNextSetOfSchools]
  /// to fetch new set of document data is already running (pagination), if it is
  /// then the method is not called again
  bool _shouldRunCheck = true;

  /// This boolean variable is used to verify if there are still any documents
  /// left in the database
  bool _noMoreDocuments = false;

  /// Boolean variable to verify if the next set of document snapshot has been
  /// fetched
  bool _hasGottenNextDocData = false;

  /// Boolean variable that determines if a circular progress spinner should be
  /// shown at the bottom of the scrollable widget to indicated data being fetched
  bool _showCircularProgress = false;

  /// TODO: Remove these 3 lines of variable instances
  static final _formKey = GlobalKey<FormState>();
  bool isSearching = false;
  TextEditingController schoolSearchController = TextEditingController();

  /// Method to listen for changes in the "alumniUsers" collection group, when an
  /// event is emitted the [_onUserJoinedAlumni] method is called to handle the
  /// doc change
  void _listenOnAlumniUsers() {
    FirebaseFirestore.instance
        .collectionGroup("alumniUsers")
        .snapshots()
        .listen((event) => _onUserJoinedAlumni(event.docChanges));
  }

  /// This method uses the instance of AlumniDB [_alumniDB] to fetch the first
  /// set of alumni schools to be displayed
  void _getFirstSetOfSchools() {
    _listenOnAlumniUsers();

    _alumniDB.getFirstSetOfSchools().then((mapStringDynamicData) {
      List<AlumniSchool> listOfAlumniSchools =
          mapStringDynamicData[kSchoolListOfMapData];

      /// Assigning the list of documentSnapshot to [_previousDocSnapshot] to be
      /// used for when fetching next set of data
      _previousDocSnapshot = mapStringDynamicData[kLastDocumentSnapshot];
      if (listOfAlumniSchools.isNotEmpty) {
        _schoolDocumentSnapshot = listOfAlumniSchools;
      }

      if (mounted) {
        setState(() {
          _streamController.add(_schoolDocumentSnapshot);
        });
      }
    }).catchError((onError) {
      /// TODO: Show notification to user about error
      print("_getFirstSetOfSchools: From alma_mater - $onError");
    });
  }

  /// This method listens to the "alumniUsers" collection of a given school
  void _onUserJoinedAlumni(List<DocumentChange> documentChange) async {
    bool isChanged = false;

    for (DocumentChange change in documentChange) {
      if (change.type == DocumentChangeType.added) {
        List<AlumniSchool> schoolList = _schoolDocumentSnapshot;

        Map<String, dynamic> data = change.doc.data as Map<String, dynamic>;

        String? userId = data["id"];

        String? schoolId = data["schId"];

        if (userId == GlobalVariables.loggedInUserObject.id) {
          int indexWhere = schoolList.indexWhere((sch) {
            return data["schId"] == sch.schoolId;
          });

          if (indexWhere != -1) {
            schoolList.removeAt(indexWhere);

            try {
              DocumentSnapshot docSnap =
                  await (_alumniDB.getUserAlumnusSchool(schoolId)
                      as Future<DocumentSnapshot<Object>>);

              if (docSnap.exists) {
                Map<String, dynamic> tempMapData =
                    docSnap.data() as Map<String, dynamic>;

                tempMapData[kIsInAlumni] = true;

                AlumniSchool alumniSchool = AlumniSchool.fromJson(tempMapData);

                schoolList.insert(0, alumniSchool);

                _schoolDocumentSnapshot = schoolList;

                isChanged = true;
              }
            } catch (e) {
              print("onUserJoinedAlumni: $e");
            }
          }
        }
      }

      if (change.type == DocumentChangeType.removed) {
        List<AlumniSchool> schoolList = _schoolDocumentSnapshot;

        Map<String, dynamic> data = change.doc.data as Map<String, dynamic>;

        String? userId = data["id"];

        if (userId == GlobalVariables.loggedInUserObject.id) {
          int indexWhere = schoolList.indexWhere((sch) {
            return data["schId"] == sch.schoolId; // sch_Id
          });

          // AlumniSchool alumniSchool = AlumniSchool.fromJson(change.data);
          if (indexWhere != -1) {
            schoolList.removeAt(indexWhere);
            // schoolList.add(alumniSchool);
            _schoolDocumentSnapshot = schoolList;

            isChanged = true;
          }
        }
      }
    }

    if (isChanged) {
      if (mounted)
        setState(() => _streamController.add(_schoolDocumentSnapshot));
    }
  }

  /// Method responsible for handling processing subsequent set of fetched school
  /// listing data and displaying the data to the user using the [__streamController]
  void fetchNextSetOfSchools() {
    if (_shouldCheck && !_noMoreDocuments) {
      /// TODO: Check length of [_previousDocSnapshot] if "0" return - Edge case
      _shouldRunCheck = false;
      _shouldCheck = false;

      _hasGottenNextDocData = false;

      List<DocumentSnapshot> prevDocSnapshot = _previousDocSnapshot!;

      _alumniDB
          .fetchNextSetOfSchools(prevDocSnapshot)
          .then((listOfDocumentSnapshot) {
        List<DocumentSnapshot> nextSchoolChunk = listOfDocumentSnapshot;

        if (nextSchoolChunk.length == 0 || nextSchoolChunk.isEmpty) {
          /// i.e. No more Document Snapshot available in the database
          _noMoreDocuments = true;

          setState(() => _showCircularProgress = false);
          return;
        } else {
          _previousDocSnapshot = listOfDocumentSnapshot;

          /// There are still documents available in the database
          _noMoreDocuments = false;

          List<AlumniSchool> listOfAlumniSchool = [];

          for (DocumentSnapshot doc in nextSchoolChunk) {
            AlumniSchool alumniSchool =
                AlumniSchool.fromJson(doc.data as Map<String, dynamic>);
            listOfAlumniSchool.add(alumniSchool);
          }

          _schoolDocumentSnapshot.addAll(listOfAlumniSchool);

          _hasGottenNextDocData = true;

          setState(() {
            _showCircularProgress = false;
            _streamController.add(_schoolDocumentSnapshot);
          });
        }
      }).catchError((onError) {
        /// TODO: Display an error notification/widget to the user
        print("fetchNextSetOfSchools: From school_listing - $onError");
        setState(() {
          _showCircularProgress = false;
          _hasGottenNextDocData = false;
        });
      });
    }
    _shouldRunCheck = true;
  }

  /// Widget method that determines the widget to be return from [_schoolDocumentSnapshot]
  Widget _alumniCardToDisplay(
      {String? schoolId,
      String? schoolOwnerId,
      required String schoolName,
      String? schoolStreet,
      String? schoolCity,
      String? schoolState,
      String? schoolCountry,
      String? schoolLogo,
      required bool isAlumni,
      Function? onPressed}) {
    Widget widget;

    if (isAlumni) {
      widget = AlumniCardJoined(
          onPressed: onPressed!,
          schoolName: schoolName,
          schoolStreet: schoolStreet!,
          schoolCity: schoolCity!,
          schoolState: schoolState!,
          schoolCountry: schoolCountry!,
          schoolLogo: schoolLogo!,
          isAlumni: isAlumni);
    } else {
      widget = AlumniCardNotJoined(
        schoolName: schoolName,
        schoolStreet: schoolStreet!,
        schoolCity: schoolCity!,
        schoolState: schoolState!,
        schoolCountry: schoolCountry!,
        schoolLogo: schoolLogo!,
        isAlumni: isAlumni,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JoinAlumniForm(
                schoolId: schoolId,
                schoolOwnerId: schoolOwnerId,
                schoolName: schoolName,
                schoolStreet: schoolStreet,
                schoolCity: schoolCity,
                schoolLogo: schoolLogo,
              ),
            ),
          );
        },
      );
    }

    return widget;
  }

  void initState() {
    super.initState();

    _alumniDB = AlumniDB(userId: GlobalVariables.loggedInUserObject.id);

    _scrollController = ScrollController();

    _scrollController!.addListener(() {
      double maxScroll = _scrollController!.position.maxScrollExtent;
      double currentScroll = _scrollController!.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;

      /// Bottom of the screen
      if (_scrollController!.offset >=
              _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        if (!_hasGottenNextDocData && !_noMoreDocuments) {
          setState(() => _showCircularProgress = true);
        } else {
          setState(() => _showCircularProgress = false);
        }
      }

      /// 20% to the bottom of the screen
      if (maxScroll - currentScroll <= delta) {
        _shouldCheck = true;

        if (_shouldRunCheck) {
          fetchNextSetOfSchools();
        }
      }
    });

    _getFirstSetOfSchools();

    _animationController =
        AnimationController(duration: new Duration(seconds: 1), vsync: this);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _streamController.close();
    _scrollController!.dispose();
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverPersistentHeader(
            floating: true,
            pinned: false,
            delegate: AlumniPersistentHeader(
              widget: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        ),
                        elevation: MaterialStateProperty.all<double>(
                          2.0,
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Text(
                        "Notify your school",
                        textAlign: TextAlign.left,
                        style: kTextStyleFont15Medium.copyWith(
                            color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xffFAFAFA),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Search school",
                            textAlign: TextAlign.left,
                            style: kTextStyleFont15Medium.copyWith(
                                color: kHintColor1),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StreamBuilder<List<AlumniSchool>>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.data == null &&
                      snapshot.connectionState == ConnectionState.waiting) {
                    return AlumniSchoolShimmer();
                  } else if (snapshot.hasError) {
                    print(
                        "Error has occurred with the streamcontroller stream");
                    return Text("An error has occurred");
                  } else {
                    List<AlumniSchool> school = snapshot.data!.toList();

                    if (school == null || school.isEmpty) {
                      return Text("No data found");
                    } else {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: school.length,
                        itemBuilder: (BuildContext context, int index) {
                          final schoolAtIndex = school[index];
                          return _alumniCardToDisplay(
                              schoolId: schoolAtIndex.schoolId,
                              schoolOwnerId: schoolAtIndex.schoolOwnerId,
                              schoolName: schoolAtIndex.schoolName!,
                              schoolStreet: schoolAtIndex.schoolStreet,
                              schoolCity: schoolAtIndex.schoolCity,
                              schoolState: schoolAtIndex.schoolState,
                              schoolCountry: schoolAtIndex.schoolCountry,
                              schoolLogo: schoolAtIndex.schoolLogo,
                              isAlumni: schoolAtIndex.isAlumni!);
                        },
                      );
                    }
                  }
                },
              ),
            ),
            _showCircularProgress
                ? Center(
                    child: SizedBox(
                      width: 18.0,
                      height: 18.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: _animationController.drive(
                          ColorTween(
                            begin: kADeepOrange,
                            end: kMarketSecondaryColor,
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
