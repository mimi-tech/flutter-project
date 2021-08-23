import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sticky_headers.dart';
import 'package:sparks/schoolClassroom/studentFolder/viewNote.dart';
import 'package:sticky_headers/sticky_headers.dart';

class StudentsResult extends StatefulWidget {
  StudentsResult({required this. doc});
  final DocumentSnapshot doc;
  @override
  _StudentsResultState createState() => _StudentsResultState();
}

class _StudentsResultState extends State<StudentsResult> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "downloading");


    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      /* setState(() {
        progress = message[2];
      });*/

    });


    FlutterDownloader.registerCallback(downloadingCallback);
    getLocalPath();
  }
  var _documents = <DocumentSnapshot>[];
  bool progress = false;

  var itemsData = <dynamic>[];


  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort!.send([id, status, progress]);
  }





  late String _localPath;
  Future<String> _findLocalPath() async {
    final directory = defaultTargetPlatform == TargetPlatform.android
        ? await (getExternalStorageDirectory() as Future<Directory>)
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  getLocalPath() async {
    _localPath = (await _findLocalPath());

    print('Download Path: $_localPath');


    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
    duration: Duration(milliseconds: 400),
    curve: Curves.decelerate,
    child: Container(
      height: MediaQuery.of(context).size.height * 0.8,
    margin: EdgeInsets.symmetric(vertical: 10,horizontal: kHorizontal),
    child: SingleChildScrollView(
      child: Column(
      children: [
        itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
        itemsData.length == 0 && progress == true ? Text('No result found for ${widget.doc['fn']} ${widget.doc['ln']}'):

          StickyHeader(
          header:  SchoolHeader(title: '${widget.doc['fn']} results [${widget.doc['lv']}]'.toUpperCase()),


      content:ListView.builder(
          physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: _documents.length,
      itemBuilder: (context, int index) {

return Container(


      child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation:5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(itemsData[index]['title'],
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kBlackcolor,
                          fontSize: kFontSize14.sp,
                        ),
                      ),

                    ),
                    ListTile(
                        leading:  CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                              image: ('${widget.doc['logo']}'.toString()),
                              placeholder: 'images/classroom/user.png',),
                          ),

                        ),


                        title: Text(DateFormat("yyyy-MM-dd hh:mma").format(DateTime.parse(itemsData[index]['ts'])),
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: klistnmber,
                              fontSize: kFontSize14.sp,
                            ),
                          ),

                        ),
                        subtitle: Text(itemsData[index]['tc'],
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kExpertColor,
                              fontSize: kFontSize14.sp,
                            ),
                          ),

                        ),

                        trailing:Stack(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 40),
                                  child: IconButton(icon:Icon(Icons.view_agenda), onPressed: (){

                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewClassNote(note:itemsData[index]['re'],doc:_documents[index])));

                                  },color: kFbColor,)
                              ),

                              Container(
                                  margin: EdgeInsets.only(right: 30),
                                  child: IconButton(icon: Icon(Icons.download_rounded), onPressed: () async {
                                    final id = await FlutterDownloader.enqueue(
                                      url:itemsData[index]['re'],
                                      savedDir: _localPath,//externalDir.path,
                                      fileName: '${widget.doc['fn']} result.pdf',
                                      showNotification: true,
                                      openFileFromNotification: true,
                                    );

                                  },color: kLightGreen,)),
                              //IconButton(icon: Icon(Icons.upload_outlined), onPressed: (){},color: kLightGreen,)


                            ])
                    ),
                  ],
                ),
              ),
            )


          ]
      ));
        })

          )]),
    )
    )
    )
    );
  }

  Future<void> getData() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("studentResult").doc(SchClassConstant.schDoc['schId']).collection('results')
        .where('stId', isEqualTo: widget.doc['id'])
        .where('stun', isEqualTo: widget.doc['un'])

        .orderBy('ts',descending: true)

        .get();

    final List <DocumentSnapshot> documents = result.docs;
    if(documents.length != 0){



      for (DocumentSnapshot document in documents) {
        setState(() {
          _documents.add(document);
          itemsData.add(document.data());


        });



      }
    }


    //getting the result that is general for all students

    final QuerySnapshot res = await FirebaseFirestore.instance
        .collection("studentResult").doc(SchClassConstant.schDoc['schId']).collection('results')
        .where('schId', isEqualTo: widget.doc['schId'])
        .where('cl', isEqualTo: widget.doc['cl'])
        .where('lv', isEqualTo: widget.doc['lv'])
        .where('gen', isEqualTo: true)
        .orderBy('ts',descending: true)

        .get();

    final List <DocumentSnapshot> doc = res.docs;
    if(doc.length == 0){
      setState(() {
        progress = true;
      });

    }else {
      for (DocumentSnapshot doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        setState(() {
          _documents.add(doc);
          itemsData.add(data);


        });



      }
    }
  }
}
