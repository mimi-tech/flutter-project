import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/market/components/market_appbar.dart';

class MarketNotifications extends StatelessWidget {
  static String id = "market_notifications";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            MarketAppBar(),
            SliverToBoxAdapter(
              child: Text(
                "Notifications",
                style: GoogleFonts.rajdhani(
                  fontWeight: FontWeight.w700,
                  fontSize: 28.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
