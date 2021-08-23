import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/Alumni/Promotion_chapter.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/Alumni/dimens/dimens.dart';
import 'package:sparks/Alumni/jobs_input_page.dart';
import 'package:sparks/Alumni/newsboard_Internship.dart';
import 'package:sparks/Alumni/newsboard_alumniproject.dart';
import 'package:sparks/Alumni/newsboard_career.dart';
import 'package:sparks/Alumni/newsboard_scholarship.dart';
import 'package:sparks/Alumni/newsboardevents.dart';
import 'package:sparks/alumni/strings.dart';

class Constant {
  static final textstylesfonts = TextStyle(
    fontSize: kMyfonts.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Rajdhani',
    color: kAWhite,
  );
}

class NavBarSelect extends StatelessWidget {
  NavBarSelect({
    this.bgSchlEvents,
    this.bgJobs,
    this.bgPromotions,
    this.bgScholarships,
    this.bgInternships,
    this.bgCareerServices,
    this.bgAlumniProject,
    required this.SchlEventsColor,
    required this.JobsColor,
    required this.PromotionsColor,
    required this.ScholarshipsColor,
    required this.InternshipsColor,
    required this.CareerServicesColor,
    required this.AlumniProjectColor,
  });

  final Color? bgSchlEvents;
  final Color? bgJobs;
  final Color? bgPromotions;
  final Color? bgScholarships;
  final Color? bgInternships;
  final Color? bgCareerServices;
  final Color? bgAlumniProject;
  final Color SchlEventsColor;
  final Color JobsColor;
  final Color PromotionsColor;
  final Color ScholarshipsColor;
  final Color InternshipsColor;
  final Color CareerServicesColor;
  final Color AlumniProjectColor;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: NewsBoardEvents()));
          },
          child: NavBarComponent(
            bgColour: bgSchlEvents,
            colour: SchlEventsColor,
            text: kAppBarSchoolEvents,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                PageTransition(type: PageTransitionType.fade, child: Jobs()));
          },
          child: NavBarComponent(
            bgColour: bgJobs,
            colour: JobsColor,
            text: kAppBarJobs,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: Promotions()));
          },
          child: NavBarComponent(
            bgColour: bgPromotions,
            colour: PromotionsColor,
            text: kAppBarPromotions,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: NewsBoardScholarship()));
          },
          child: NavBarComponent(
            bgColour: bgScholarships,
            colour: ScholarshipsColor,
            text: kAppBarScholarship,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: NewsBoardInternship()));
          },
          child: NavBarComponent(
            bgColour: bgInternships,
            colour: InternshipsColor,
            text: kAppBarInternship,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: CareerService()));
          },
          child: NavBarComponent(
            bgColour: bgCareerServices,
            colour: CareerServicesColor,
            text: kAppBarCareerService,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: AlumniProjects()));
          },
          child: NavBarComponent(
            bgColour: bgAlumniProject,
            colour: AlumniProjectColor,
            text: kAppBarAlumniProject,
          ),
        ),
      ],
    );
  }
}

class NavBarComponent extends StatelessWidget {
  NavBarComponent({required this.colour, required this.bgColour, this.text});

  final Color colour;
  final Color? bgColour;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: bgColour,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text!,
            style: TextStyle(
                fontFamily: "Rajdhani",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colour),
          ),
        ),
      ),
    );
  }
}
