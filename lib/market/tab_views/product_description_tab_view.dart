import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparks/market/utilities/market_const.dart';

class ProductDescriptionTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productDetailSnapshot = Provider.of<QuerySnapshot>(context);

    String? productDescription;

    for (DocumentSnapshot testingTwo in productDetailSnapshot.docs) {
      if (testingTwo['pDes'] != null) {
        productDescription = testingTwo['pDes'];
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Text(
        productDescription!,
        textAlign: TextAlign.justify,
        style: GoogleFonts.rajdhani(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: kMarketSecondaryColor,
          height: 1.5,
        ),
      ),
    );
  }
}
