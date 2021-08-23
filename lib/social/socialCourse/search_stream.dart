import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/social/socialContent/textConstants.dart';
import 'package:sparks/social/socialContent/user_gridView.dart';
import 'package:sparks/social/socialCourse/searchservice.dart';

class SearchStream extends StatefulWidget {
  @override
  _SearchStreamState createState() => _SearchStreamState();
}

class _SearchStreamState extends State<SearchStream> {
  List<DocumentSnapshot> queryResultSet = <DocumentSnapshot> [];
  List<DocumentSnapshot> tempSearchStore = <DocumentSnapshot> [];
 // var tempSearchStore = [];
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
  late List <dynamic> aoi;
late List <dynamic> spec;
late List <dynamic> hobby;
late List <dynamic> lang;
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue = value.substring(0, 1).toLowerCase() + value.substring(1);
    print(capitalizedValue);
    if (queryResultSet.length == 0 && value.length == 1) {

      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          print(docs.docs[0]['un']);
          queryResultSet.add(docs.docs[i]);
        }
      });
    } else {


      tempSearchStore = [];

      queryResultSet.forEach((element) {
        if (element['un'].startsWith(capitalizedValue)) {

          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }
  List<Widget> getImages(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < aoi.length; i++){
      Widget w =  Text(aoi[i].toString(),
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: kBlackcolor,
            fontSize: kFontSize14.sp,
          ),
        ),

      );
      list.add(w);
    }
    return list;
  }
  ///specialization

  List<Widget> getSpecialization(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < spec.length; i++){
      Widget w =  Text(spec[i].toString(),
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: kBlackcolor,
            fontSize: kFontSize14.sp,
          ),
        ),

      );
      list.add(w);
    }
    return list;
  }

  ///hobby

  List<Widget> getHobby(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < hobby.length; i++){
      Widget w =  Text(hobby[i].toString(),
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: kBlackcolor,
            fontSize: kFontSize14.sp,
          ),
        ),

      );
      list.add(w);
    }
    return list;
  }
  List<Widget> getLanguage(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < lang.length; i++){
      Widget w =  Text(lang[i].toString(),
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: kBlackcolor,
            fontSize: kFontSize14.sp,
          ),
        ),

      );
      list.add(w);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
        appBar: AppBar(
          backgroundColor: kStatusbar,
          title: Text('Search for a mentor',
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
            hintText: 'Search by username',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0))),
      ),
    ),
                  ),
              SliverList(
                delegate: SliverChildListDelegate([

                  tempSearchStore.length == 0?Text('empty'):
    ListView.builder(
    itemCount: tempSearchStore.length,
    shrinkWrap: true,
    physics: BouncingScrollPhysics(),
    itemBuilder: (context, int index) {
      aoi = tempSearchStore[index]['aoi'];
      spec = tempSearchStore[index]['spec'];
      hobby = tempSearchStore[index]['hobb'];
      lang = tempSearchStore[index]['lang'];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ListTile(
            onTap: () {
              Navigator.push(context, PageTransition(
                  type: PageTransitionType.fade,
                  child: SocialUserGridView(doc: tempSearchStore[index],)));
            },
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 30,
              child: ClipOval(
                child: CachedNetworkImage(

                  imageUrl: '${tempSearchStore[index]['pimg']}',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: 100.0,
                  height: 100.0,

                ),
              ),
            ),

            title: Text(tempSearchStore[index]['nm']['fn'],
              style: GoogleFonts.rajdhani(
                       fontSize:kFontsize.sp,
                color: kBlackcolor,
                fontWeight: FontWeight.bold,

              ),),

            subtitle: Text(tempSearchStore[index]['nm']['ln'],
              style: GoogleFonts.rajdhani(
                       fontSize:kFontsize.sp,
                color: kBlackcolor,
                fontWeight: FontWeight.bold,

              ),),

            trailing: RaisedButton(onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: kFbColor,
              child: Text(kFollow,
                style: GoogleFonts.rajdhani(
                  fontSize:14.sp,
                  color: kWhitecolor,
                  fontWeight: FontWeight.bold,

                ),),
            ),
          ),

          Divider(),

          space(),

          TextConstants(text1: 'Area of interest'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: getImages(),
          ),
          space(),

          TextConstants(text1: 'Area of specialization'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: getSpecialization(),
          ),
          space(),


          TextConstants(text1: 'Hobby'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: getHobby(),
          ),
          space(),

          TextConstants(text1: 'Language'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: getLanguage(),
          ),
          space(),
        ],
      );
    })])
              )])
    ));
  }
}

