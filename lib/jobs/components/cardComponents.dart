import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/subScreens/details/jobDetails.dart';
import 'package:sparks/jobs/subScreens/employment/viewAppointment.dart';
import 'package:sparks/jobs/subScreens/employment/viewInterview.dart';
import 'package:sparks/jobs/subScreens/employment/viewJobOffer.dart';
import 'package:sparks/jobs/subScreens/resume/resume.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//TODO: Job Card widget
class JobCard extends StatelessWidget {
  const JobCard({
    Key? key,
    required this.companyLogo,
    required this.jobTitle,
    required this.companyName,
    required this.jobLocation,
    required this.minSalary,
    required this.maxSalary,
    required this.jobType,
    required this.jobCategory,
    required this.jobTime,
    required this.jobId,
    required this.companyId,
    required this.mainId,
    required this.jobSummary,
    required this.jobBenefit,
    required this.jobQualification,
    required this.responsibility,
    required this.skills,
    required this.status,
    required this.displayMin,
    required this.displayMax,
  }) : super(key: key);

  final companyLogo;
  final mainId;
  final jobTitle;
  final jobLocation;
  final minSalary;
  final maxSalary;
  final companyName;
  final jobType;
  final jobCategory;
  final jobTime;
  final jobId;
  final companyId;
  final skills;
  final jobSummary;
  final jobBenefit;
  final jobQualification;
  final responsibility;
  final status;
  final displayMin;
  final displayMax;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: double.infinity, minHeight: ScreenUtil().setSp(150)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 32,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: companyLogo,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  width: 40.0,
                                  height: 40.0,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            ReusableFunctions.smallSentence(
                                15,
                                15,
                                ReusableFunctions.displayProfessionalName(
                                    companyName)!),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(18.0),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          ReusableFunctions.smallSentence(19, 19, jobTitle),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(16.0),
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_location,
                              color: kNavBg,
                              size: ScreenUtil().setSp(16.0),
                            ),
                            Text(
                              ReusableFunctions.smallSentence(
                                  19, 19, jobLocation),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(16.0),
                                    fontWeight: FontWeight.bold,
                                    color: kShade),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.date_range,
                              color: Colors.orange,
                              size: ScreenUtil().setSp(14.0),
                            ),
                          ),
                          Text(
                            jobTime,
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(14.0),
                                  fontWeight: FontWeight.bold,
                                  color: kShade),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Job Type',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(18.0),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "${ReusableFunctions.capitalizeWords(jobCategory)} - ${ReusableFunctions.capitalizeWords(jobType)}",
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(13.0),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '\$${ReusableFunctions.numberFormatter(minSalary)} - \$${ReusableFunctions.numberFormatter(maxSalary)}',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(16.0),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          PostJobFormStorage.jobId = jobId;
                          PostJobFormStorage.companyId = companyId;
                          PostJobFormStorage.logoUrl = companyLogo;
                          PostJobFormStorage.jobType = jobType;
                          PostJobFormStorage.jobTitle = jobTitle;
                          PostJobFormStorage.jobCategory = jobCategory;
                          PostJobFormStorage.jobSummary = jobSummary;
                          PostJobFormStorage.jobBenefit = jobBenefit;
                          PostJobFormStorage.jobQualification =
                              jobQualification;
                          PostJobFormStorage.responsibility = responsibility;
                          PostJobFormStorage.skills = skills;
                          PostJobFormStorage.companyName = companyName;
                          PostJobFormStorage.jobLocation = jobLocation;
                          PostJobFormStorage.salaryRangeMin = displayMin;
                          PostJobFormStorage.salaryRangeMax = displayMax;
                          PostJobFormStorage.mainCompanyId = mainId;
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: JobDetails()));
                        },
                        color: kLight_orange,
                        textColor: Colors.white,
                        child: Text("Job Details"),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfessionalCard extends StatelessWidget {
  const ProfessionalCard({
    Key? key,
    required this.professionalProfile,
    required this.professionalName,
    required this.jobTitle,
    required this.professionalLocation,
    required this.jobCategory,
    required this.jobType,
    required this.professionalId,
    required this.date,
    required this.status,
    required this.minSalary,
    required this.maxSalary,
    required this.starRating,
  });

  final professionalProfile;
  final String? professionalName;
  final jobTitle;
  final professionalLocation;
  final jobCategory;
  final jobType;
  final professionalId;
  final date;
  final status;
  final minSalary;
  final maxSalary;
  final starRating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: double.infinity, minHeight: ScreenUtil().setSp(150)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 32,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: professionalProfile,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover,
                                    width: 40.0,
                                    height: 40.0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                ReusableFunctions.displayProfessionalName(
                                    professionalName)!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(18.0),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        RatingBar.builder(
                          initialRating: starRating.toDouble(),
                          minRating: 1,
                          unratedColor: Colors.black,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ignoreGestures: true,
                          itemSize: 20,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (double) {},
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            ReusableFunctions.smallSentence(19, 19, jobTitle),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(16.0),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_location,
                                color: kNavBg,
                                size: ScreenUtil().setSp(16.0),
                              ),
                              Text(
                                ReusableFunctions.smallSentence(
                                    19, 19, professionalLocation),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(16.0),
                                      fontWeight: FontWeight.bold,
                                      color: kShade),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              ReusableFunctions.capitalizeWords(status)!,
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(18.0),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "$jobCategory - $jobType",
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(13.0),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              '\$${ReusableFunctions.numberFormatter(minSalary)} - \$${ReusableFunctions.numberFormatter(maxSalary)}',
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(16.0),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              ),
                            ),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            ProfessionalStorage.id = professionalId;
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: Resume()));
                          },
                          color: kLight_orange,
                          textColor: Colors.white,
                          child: Text("Job Profile"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class JobOfferCard extends StatelessWidget {
  const JobOfferCard({
    Key? key,
    required this.jobOffer,
  }) : super(key: key);

  final DocumentSnapshot jobOffer;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = jobOffer.data() as Map<String, dynamic>;
    return Card(
      elevation: 6,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: double.infinity,
          minHeight: ScreenUtil().setHeight(180.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            // color: kShade,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
            child: Container(
              height: ScreenUtil().setHeight(180.0),
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ReusableFunctions.smallSentence(25, 25, data['cnm']),
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(22),
                            fontWeight: FontWeight.bold,
                            color: kLight_orange),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Container(
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 32,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:
                                    jobOffer['lur'], // jobOffer.data()['lur']
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                                width: 40.0,
                                height: 40.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'JOB OFFER INVITATION',
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(15),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    data['jtm'],
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(12),
                                          fontWeight: FontWeight.bold,
                                          color: kMore),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  ReusableFunctions.smallSentence(
                                      40, 40, '${data['jof']}...'),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(15),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              ReusableFunctions.smallSentence(
                                  40, 40, data['jlt']),
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                    fontWeight: FontWeight.bold,
                                    color: kShade),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RaisedButton(
                                  onPressed: () {
                                    UserStorage.jobOfferRequestID =
                                        jobOffer['joId'];
                                    UserStorage.companyID = jobOffer['cid'];
                                    UserStorage.mainCompanyID =
                                        jobOffer['mCid'];
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: UserViewJobOfferRequest()));
                                  },
                                  color: Colors.black,
                                  textColor: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class JobsInterviewCard extends StatelessWidget {
  const JobsInterviewCard({
    Key? key,
    required this.interviewRequest,
    required this.displayDay,
  }) : super(key: key);

  // final QueryDocumentSnapshot interviewRequest;
  final Map<String, dynamic>? interviewRequest;
  final String displayDay;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: double.infinity, minHeight: ScreenUtil().setSp(150)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 32,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: interviewRequest!['lur'],
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                        width: 40.0,
                        height: 40.0,
                      ),
                    ),
                  ),
                ),
                Text(
                  ReusableFunctions.smallSentence(
                      25, 25, interviewRequest!['cnm']),
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(22),
                        fontWeight: FontWeight.bold,
                        color: kLight_orange),
                  ),
                ),
              ],
            ),
            Text(
              ReusableFunctions.smallSentence(25, 25, interviewRequest!['jtl']),
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'INTERVIEW INVITATION',
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(15),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    displayDay,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(12),
                          fontWeight: FontWeight.bold,
                          color: kLight_orange),
                    ),
                  ),
                ),
              ],
            ),
            RaisedButton(
              onPressed: () {
                UserStorage.sentInterviewRequestID = interviewRequest!['irId'];
                UserStorage.companyID = interviewRequest!['cid'];
                UserStorage.mainCompanyID = interviewRequest!['mCid'];

                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: UserViewInterviewRequest()));
              },
              color: Colors.black,
              textColor: Colors.white,
              child: Text("view details"),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    Key? key,
    required this.appointmentLetter,
  }) : super(key: key);

  final DocumentSnapshot appointmentLetter;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        appointmentLetter.data() as Map<String, dynamic>;
    return Card(
      elevation: 6,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: double.infinity,
          minHeight: ScreenUtil().setHeight(180.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            // color: kShade,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
            child: Container(
              height: ScreenUtil().setHeight(180.0),
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ReusableFunctions.smallSentence(25, 25, data['cnm']),
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(22),
                            fontWeight: FontWeight.bold,
                            color: kLight_orange),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Container(
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 32,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: data['lur'],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                                width: 40.0,
                                height: 40.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'APPOINTMENT LETTER',
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(15),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    data['date'],
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(12),
                                          fontWeight: FontWeight.bold,
                                          color: kMore),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  ReusableFunctions.smallSentence(
                                      40, 40, '${data['apMsg']}...'),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(15),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              ReusableFunctions.smallSentence(
                                  40, 40, data['cAds']),
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                    fontWeight: FontWeight.bold,
                                    color: kShade),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    UserStorage.appointmentID = data['sapId'];
                                    UserStorage.companyID = data['cid'];
                                    UserStorage.mainCompanyID = data['mCid'];
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: UserViewAppointment()));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.red,
                                    ),
                                    // margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                    height: ScreenUtil().setHeight(30.0),
                                    width: ScreenUtil().setWidth(80.0),
                                    margin: EdgeInsets.fromLTRB(
                                        0.0, 12.0, 5.0, 7.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Details',
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(18),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AcceptedCard extends StatelessWidget {
  const AcceptedCard({
    Key? key,
    required this.acceptedAppointmentLetter,
  }) : super(key: key);

  final DocumentSnapshot acceptedAppointmentLetter;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        acceptedAppointmentLetter.data() as Map<String, dynamic>;
    return Card(
      elevation: 6,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: double.infinity,
          minHeight: ScreenUtil().setHeight(100.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            // color: kShade,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Container(
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 32,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: data['usImg'],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                                width: 40.0,
                                height: 40.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    ' ACCEPTED APPOINTMENT LETTER',
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(15),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    data['jtm'],
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(12),
                                          fontWeight: FontWeight.bold,
                                          color: kMore),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: ScreenUtil().setSp(315),
                                      minHeight: ScreenUtil().setSp(2)),
                                  child: Text(
                                    '${data['uEmail']} Accepted Your Appointment Letter',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 6,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(15),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              ReusableFunctions.smallSentence(
                                  40, 40, data['rCity']),
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                    fontWeight: FontWeight.bold,
                                    color: kShade),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: RaisedButton(
                      onPressed: () {
                        ProfessionalStorage.id = data['uId'];
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: Resume()));
                      },
                      color: kComp,
                      child: Text(
                        'View Profile',
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(15),
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeclinedCard extends StatelessWidget {
  const DeclinedCard({
    Key? key,
    required this.declinedAppointmentLetter,
  }) : super(key: key);

  final DocumentSnapshot declinedAppointmentLetter;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        declinedAppointmentLetter.data() as Map<String, dynamic>;
    return Card(
      elevation: 6,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: double.infinity,
          minHeight: ScreenUtil().setHeight(100.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            // color: kShade,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Container(
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 32,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: data['usImg'],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                                width: 40.0,
                                height: 40.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    ' ACCEPTED APPOINTMENT LETTER',
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(15),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    data['jtm'],
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(12),
                                          fontWeight: FontWeight.bold,
                                          color: kMore),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: ScreenUtil().setSp(315),
                                      minHeight: ScreenUtil().setSp(2)),
                                  child: Text(
                                    '${data['uEmail']} Declined Your Appointment Letter',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 6,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(15),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              ReusableFunctions.smallSentence(
                                  40, 40, data['rCity']),
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                    fontWeight: FontWeight.bold,
                                    color: kShade),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: RaisedButton(
                      onPressed: () {
                        ProfessionalStorage.id = data['uId'];
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: Resume()));
                      },
                      color: kComp,
                      child: Text(
                        'View Profile',
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(15),
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
