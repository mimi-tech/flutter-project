import 'package:flutter/material.dart';
import 'package:sparks/alumni/components/alumni_persistent_header.dart';
import 'package:sparks/alumni/models/alumni_user.dart';
import 'package:sparks/alumni/services/alumni_db.dart';
import 'package:sparks/alumni/static_variables/alumni_globals.dart';
import 'package:sparks/alumni/utilities/strings.dart';
import 'package:sparks/alumni/views/members_my_set_chapter.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/utilities/colors.dart';
import 'package:sparks/utilities/styles.dart';

/// TODO: Document class
class AlumniActivity extends StatefulWidget {
  const AlumniActivity({Key? key, this.alumniUser}) : super(key: key);

  final AlumniUser? alumniUser;

  @override
  _AlumniActivityState createState() => _AlumniActivityState();
}

class _AlumniActivityState extends State<AlumniActivity>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  /// This method is responsible for saving an instance of [AlumniUser]
  /// object of the currently logged in user accessing an alumni activity
  ///
  /// If an [AlumniUser] instance object was passed into the class constructor,
  /// its value is stored to the global instance of [AlumniGlobals.currentAlumniUser]
  ///
  /// Else a call to an [AlumniDB] service class method responsible for calling
  /// the database and an instance of [AlumniUser] object is saved/stored to the
  /// global [AlumniUser] object
  void _getCurrentAlumniUser() async {
    if (widget.alumniUser != null) {
      AlumniGlobals.currentAlumniUser = widget.alumniUser;
    } else {
      AlumniDB alumniDB =
          AlumniDB(userId: GlobalVariables.loggedInUserObject.id);

      await alumniDB.getAlumniUserData();

      print("_getCurrentAlumniUser: Successfully got alumni user data");

      /// TODO: Consider using the (onError) to display a failed call to the DB
    }
  }

  @override
  void initState() {
    super.initState();

    /// TODO: Store an instance of [AlumniUser] in the global variable

    _tabController = TabController(length: 3, vsync: this);

    _getCurrentAlumniUser();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dummy University",
                      style: kTextStyleFont15Bold.copyWith(color: kWhiteColor),
                    ),
                    Text(
                      "Dummy street address",
                      style: kTextStyleFont15Medium.copyWith(
                          color: kWhiteColor, fontSize: 12.0),
                    ),
                  ],
                ),
                actions: [
                  CircleAvatar(
                    radius: 24.0,
                    backgroundColor: Colors.brown,
                  ),
                  SizedBox(
                    width: 32.0,
                  ),
                  Icon(
                    Icons.notifications,
                    size: 24.0,
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                ],
              ),
              SliverPersistentHeader(
                delegate: AlumniPersistentHeader(
                  containerColor: Color(0xff700000),
                  widget: TabBar(
                    controller: _tabController,
                    indicatorColor: kWhiteColor,
                    labelColor: Color(0xffA2FFFC),
                    unselectedLabelColor: Color(0xffFFC8BC),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 4.0,
                    labelStyle: kTextStyleFont15Bold,
                    unselectedLabelStyle: kTextStyleFont15Bold,
                    tabs: [
                      Tab(
                        child: Text(
                          kActivities,
                        ),
                      ),
                      Tab(
                        child: Text(
                          kNewsBoard,
                        ),
                      ),
                      Tab(
                        child: Text(
                          kAdmin,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              MembersMySetChapter(),
              Container(
                color: Colors.brown,
              ),
              Container(
                color: Colors.brown,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
