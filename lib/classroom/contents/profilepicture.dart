import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';

class ProfilePicture extends StatefulWidget {
  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(UploadVariables.currentUser)
            .collection('Personal')
            .where('id', isEqualTo: UploadVariables.currentUser)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Map<String, dynamic>> listOfData = snapshot.data as List<Map<String, dynamic>>;
            return CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 32,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: '${listOfData[0]['pimg']}',
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: 40.0,
                  height: 40.0,
                ),
              ),
            );
          }
        });
  }
}
/*
;*/
