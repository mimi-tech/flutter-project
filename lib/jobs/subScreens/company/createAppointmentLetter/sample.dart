import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';



class AppointmentSample extends StatefulWidget {
  const AppointmentSample({
    Key? key,
    this.tabController,
  });

  final TabController? tabController;

  @override
  _AppointmentSampleState createState() => _AppointmentSampleState();
}

class _AppointmentSampleState extends State<AppointmentSample> {
  String congratulation = "We are pleased to inform you that you passed"
  "your interview and we are hereby offering you"
  "employment on contract basis for the position"
  "of a safety officer at XYZ Company. The terms"
  "and conditions of your employment are as"
  "follows:";

  String commencement =
  "You are expected to report to your duties"
  "as from 24th October 1618. Your contract is"
  "based on a period of two years after which"
  "we may renew it based on your performance"
  "and mutual agreement.";

  String reporting = "You will report to your immediate supervisor"
      "on the said date. You are required to comply with the company's rules"
      "and regulations at all given times and should always act in a manner that protects the "
      "company's interest";

  String allocation = "You will be based at the company's Headquarters in New York City";

  String roles = "Your roles and responsibilities are outlined in the job description which is an extension"
      "of this contract. Your acceptance will imply that you fully agree with all the terms and conditions laid out in"
      "this contract";

  String salary ="You are entitled to a monthly compensation amounting to {Amount} which will be subject to all "
      "statutory and company deductions with regards to the law";

  String hours = "Your working hours shall be from 9 a.m to 6 pm"
      "(Monday - Friday). However, you may also be required to avail yourself outside these stipulated hours if the"
      "need arises";

  String vacation = "You will be entitled to 21 working days of leave at full pay. However, the leave days should"
      "only be taken at a time most suitable for both you and your employer";

  String sick = "You are entitled to up to (29) working days fo sick leave at full pay";

  String paternity = "You are entitled to a paternity leave of up to (two) calendar weeks of which you should apply "
      "seven days beforehand";

  String termination = "By either party given a prior 30 working days written notice failure to which"
      " a compensation"
      "equivalent to a month's salary will be awarded "
      "Or, "
      "By the Employer on grounds of indiscipline or under performance"
      "Or"
      "By the Employer on account of redundancy/retrenchment as per the law";

  String copyrights = "You shall not work with any other company either full time or part-time in a capacity that"
      "would create a conflict of interest with the company";



  String amendment = "Any alterations or amendment to this contract shall be dully communicated in writing taking into consideration"
      "both the employer's and employee's views";

  String confirm =" To affirm your acceptance to the terms and conditions laid out in this letter kindly "
      "click on the accept button.";


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RaisedButton(
                color:kLight_orange,
                onPressed: (){
                  Navigator.pop(context);
                },
                child: new Text("Back",
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(18),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),),),
              ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top:18.0),
                child: Column(
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sample',
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(25.0),
                              fontWeight: FontWeight.bold,
                              color: kLight_orange),),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'EMPLOYMENT LETTER',
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(20.0),
                              fontWeight: FontWeight.bold,
                              color: Colors.black),),
                      ),
                    ],
                  ),
                ],),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10.0,10.0,0.0,10.0),
              child: Text(
                'Name',
                style:GoogleFonts.rajdhani(
                  textStyle:TextStyle(
                      fontSize:ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w500,
                      color: Colors.black),),
              ),
            ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0,0.0,0.0,10.0),
                child: Text(
                  'Address (Street)',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(16.0),
                        fontWeight: FontWeight.w500,
                        color: Colors.black),),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0,0.0,0.0,10.0),
                child: Text(
                  'City,State,Zip Code',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(16.0),
                        fontWeight: FontWeight.w500,
                        color: Colors.black),),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0,16.0,0.0,10.0),
                child: Text(
                  'Date',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(16.0),
                        fontWeight: FontWeight.w500,
                        color: Colors.black),),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0,25.0,0.0,10.0),
                child: Text(
                  'Recipients Name',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(16.0),
                        fontWeight: FontWeight.w500,
                        color: Colors.black),),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0,0.0,0.0,10.0),
                child: Text(
                  'Recipient\'s Address (State)',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(16.0),
                        fontWeight: FontWeight.w500,
                        color: Colors.black),),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0,0.0,0.0,10.0),
                child: Text(
                  'Recipient\'s City, State, Zip Code',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(16.0),
                        fontWeight: FontWeight.w500,
                        color: Colors.black),),
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(10.0,16.0,0.0,16.0),
                child: Text(
                  'Dear (Name)',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(16.0),
                        fontWeight: FontWeight.w500,
                        color: Colors.black),),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25.0,0.0,0.0,10.0),
                      child: Text(
                        congratulation,
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(16.0),
                              fontWeight: FontWeight.w500,
                              color: Colors.black),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: RaisedButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: congratulation));
                        Fluttertoast.showToast(
                            msg: "Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.black,
                            textColor: Colors.white);
                      },
                      child: Text("COPY",
                      style: TextStyle(
                        color: Colors.white
                      ),),
                      color: Colors.black,
                    ),
                  )
                ],
              ),

              Container(
                margin: EdgeInsets.fromLTRB(10.0,16.0,0.0,16.0),
                child: Text(
                  '1. Day Of Commencement',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(25.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25.0,0.0,0.0,10.0),
                      child: Text(
                        commencement,
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(16.0),
                              fontWeight: FontWeight.w500,
                              color: Colors.black),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: RaisedButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: commencement));
                        Fluttertoast.showToast(
                            msg: "Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.black,
                            textColor: Colors.white);
                      },
                      child: Text("COPY",
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      color: Colors.black,
                    ),
                  )
                ],
              ),

              Container(
                margin: EdgeInsets.fromLTRB(10.0,16.0,0.0,16.0),
                child: Text(
                  '2. Reporting',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(25.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25.0,0.0,0.0,10.0),
                      child: Text(
                        reporting,
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(16.0),
                              fontWeight: FontWeight.w500,
                              color: Colors.black),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: RaisedButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: reporting));
                        Fluttertoast.showToast(
                            msg: "Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.black,
                            textColor: Colors.white);
                      },
                      child: Text("COPY",
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      color: Colors.black,
                    ),
                  )
                ],
              ),

              Container(
                margin: EdgeInsets.fromLTRB(10.0,16.0,0.0,16.0),
                child: Text(
                  '3. Allocated Place Of Work',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(25.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25.0,0.0,0.0,10.0),
                      child: Text(
                        allocation,
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(16.0),
                              fontWeight: FontWeight.w500,
                              color: Colors.black),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: RaisedButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: allocation));
                        Fluttertoast.showToast(
                            msg: "Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.black,
                            textColor: Colors.white);
                      },
                      child: Text("COPY",
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      color: Colors.black,
                    ),
                  )
                ],
              ),

              Container(
                margin: EdgeInsets.fromLTRB(10.0,16.0,0.0,16.0),
                child: Text(
                  '4. Roles and Responsibilities',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(25.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25.0,0.0,0.0,10.0),
                      child: Text(
                        roles,
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(16.0),
                              fontWeight: FontWeight.w500,
                              color: Colors.black),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: RaisedButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: roles));
                        Fluttertoast.showToast(
                            msg: "Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.black,
                            textColor: Colors.white);
                      },
                      child: Text("COPY",
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      color: Colors.black,
                    ),
                  )
                ],
              ),


              Container(
                margin: EdgeInsets.fromLTRB(10.0,16.0,0.0,16.0),
                child: Text(
                  '5. Monthly Salary ',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(25.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25.0,0.0,0.0,10.0),
                      child: Text(
                        salary,
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(16.0),
                              fontWeight: FontWeight.w500,
                              color: Colors.black),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: RaisedButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: salary));
                        Fluttertoast.showToast(
                            msg: "Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.black,
                            textColor: Colors.white);
                      },
                      child: Text("COPY",
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      color: Colors.black,
                    ),
                  )
                ],
              ),

              Container(
                margin: EdgeInsets.fromLTRB(10.0,16.0,0.0,16.0),
                child: Text(
                  '6. Working Hours',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(25.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25.0,0.0,0.0,10.0),
                      child: Text(
                        hours,
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(16.0),
                              fontWeight: FontWeight.w500,
                              color: Colors.black),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: RaisedButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: hours));
                        Fluttertoast.showToast(
                            msg: "Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.black,
                            textColor: Colors.white);
                      },
                      child: Text("COPY",
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      color: Colors.black,
                    ),
                  )
                ],
              ),


              Container(
                margin: EdgeInsets.fromLTRB(10.0,16.0,0.0,16.0),
                child: Text(
                  '7. Leave',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(25.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25.0,10.0,0.0,0.0),
                child: Text(
                  '7.1 Vacation',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(22.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25.0,0.0,0.0,10.0),
                      child: Text(
                        vacation,
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(16.0),
                              fontWeight: FontWeight.w500,
                              color: Colors.black),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: RaisedButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: vacation));
                        Fluttertoast.showToast(
                            msg: "Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.black,
                            textColor: Colors.white);
                      },
                      child: Text("COPY",
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      color: Colors.black,
                    ),
                  )
                ],
              ),

              Container(
                margin: EdgeInsets.fromLTRB(25.0,10.0,0.0,0.0),
                child: Text(
                  '7.2 Sick Leave',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(22.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25.0,0.0,0.0,10.0),
                      child: Text(
                        sick,
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(16.0),
                              fontWeight: FontWeight.w500,
                              color: Colors.black),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: RaisedButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: sick));
                        Fluttertoast.showToast(
                            msg: "Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.black,
                            textColor: Colors.white);
                      },
                      child: Text("COPY",
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      color: Colors.black,
                    ),
                  )
                ],
              ),

              Container(
                margin: EdgeInsets.fromLTRB(25.0,10.0,0.0,0.0),
                child: Text(
                  '7.3 Paternity Leave',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(22.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25.0,0.0,0.0,10.0),
                      child: Text(
                        paternity,
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(16.0),
                              fontWeight: FontWeight.w500,
                              color: Colors.black),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: RaisedButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: paternity));
                        Fluttertoast.showToast(
                            msg: "Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.black,
                            textColor: Colors.white);
                      },
                      child: Text("COPY",
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      color: Colors.black,
                    ),
                  )
                ],
              ),



              Container(
                margin: EdgeInsets.fromLTRB(10.0,16.0,0.0,16.0),
                child: Text(
                  '8. Termination',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(25.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25.0,10.0,0.0,10.0),
                child: Text(
                  'This contract can be terminated:',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(22.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25.0,0.0,0.0,10.0),
                      child: Text(
                        termination,
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(16.0),
                              fontWeight: FontWeight.w500,
                              color: Colors.black),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: RaisedButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: termination));
                        Fluttertoast.showToast(
                            msg: "Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.black,
                            textColor: Colors.white);
                      },
                      child: Text("COPY",
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      color: Colors.black,
                    ),
                  )
                ],
              ),


              Container(
                margin: EdgeInsets.fromLTRB(10.0,16.0,0.0,16.0),
                child: Text(
                  '9. Copyrights and Ownership',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(25.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25.0,0.0,0.0,10.0),
                      child: Text(
                        copyrights,
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(16.0),
                              fontWeight: FontWeight.w500,
                              color: Colors.black),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: RaisedButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: copyrights));
                        Fluttertoast.showToast(
                            msg: "Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.black,
                            textColor: Colors.white);
                      },
                      child: Text("COPY",
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      color: Colors.black,
                    ),
                  )
                ],
              ),


              Container(
                margin: EdgeInsets.fromLTRB(10.0,16.0,0.0,16.0),
                child: Text(
                  '10. Amendment and Enforcement',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(25.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25.0,0.0,0.0,10.0),
                      child: Text(
                        amendment,
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(16.0),
                              fontWeight: FontWeight.w500,
                              color: Colors.black),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: RaisedButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: amendment));
                        Fluttertoast.showToast(
                            msg: "Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.black,
                            textColor: Colors.white);
                      },
                      child: Text("COPY",
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      color: Colors.black,
                    ),
                  )
                ],
              ),


              Container(
                margin: EdgeInsets.fromLTRB(25.0,10.0,0.0,0.0),
                child: Text(
                  'Yours Faithfully',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(16.0),
                        fontWeight: FontWeight.w500,
                        color: Colors.black),),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25.0,10.0,0.0,0.0),
                child: Text(
                  'Amadi Austin ',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(16.0),
                        fontWeight: FontWeight.w500,
                        color: Colors.black),),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25.0,10.0,0.0,0.0),
                child: Text(
                  'Human Resource Manager',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(16.0),
                        fontWeight: FontWeight.w500,
                        color: Colors.black),),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25.0,10.0,0.0,10.0),
                child: Text(
                  'XYZ Company',
                  style:GoogleFonts.rajdhani(
                    textStyle:TextStyle(
                        fontSize:ScreenUtil().setSp(16.0),
                        fontWeight: FontWeight.w500,
                        color: Colors.black),),
                ),
              ),


              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25.0,16.0,0.0,10.0),
                      child: Text(
                        confirm,
                        style:GoogleFonts.rajdhani(
                          textStyle:TextStyle(
                              fontSize:ScreenUtil().setSp(16.0),
                              fontWeight: FontWeight.w500,
                              color: Colors.black),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: RaisedButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: confirm));
                        Fluttertoast.showToast(
                            msg: "Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.black,
                            textColor: Colors.white);
                      },
                      child: Text("COPY",
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      color: Colors.black,
                    ),
                  )
                ],
              ),
          ],),
        );
  }
}
