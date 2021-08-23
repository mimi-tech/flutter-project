import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlumniTabs extends StatelessWidget {
  final String tabName;

  AlumniTabs({required this.tabName});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        tabName.toUpperCase(),
        style: TextStyle(
          fontSize: 14.sp,
          fontFamily: 'Rajdhani',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
