import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_landing_screen.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/market/components/badge_counter.dart';
import 'package:sparks/market/screens/market_home.dart';
import 'package:sparks/market/screens/market_notifications.dart';
import 'package:sparks/market/screens/market_profile.dart';
import 'package:sparks/market/screens/market_search.dart';
import 'package:sparks/market/screens/shopping_cart_screen.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/strings.dart';
import 'package:sparks/market/components/new_used_button.dart';
import 'package:sparks/market/providers/new_used_provider.dart';
import 'package:sparks/market/providers/shopping_cart.dart';

class MarketAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kAppBarHeight);

  @override
  Widget build(BuildContext context) {
    final screenData = MediaQuery.of(context).size;
    final newUsedState = Provider.of<NewUsedProvider>(context);

    return SliverAppBar(
      pinned: true,
      backgroundColor: kMarketDarkPrimaryColor,
      automaticallyImplyLeading: true,
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.only(
//          bottomLeft: Radius.circular(10.0),
//          bottomRight: Radius.circular(10.0),
//        ),
//      ),
      leading: ModalRoute.of(context)?.settings?.name ==
                  SparksLandingScreen.id ||
              ModalRoute.of(context)?.settings?.name == MarketHome.id
          ? Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: SvgPicture.asset('images/market_images/menu_icon.svg'),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                    // TODO: Get the design for the Market Drawer, design and implement the logic
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            )
          : Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                );
              },
            ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              print('profile picture tapped');
              Navigator.pushNamed(context, MarketProfile.id);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: CachedNetworkImage(
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white70,
                    value: progress.progress,
                  ),
                ),

                /// TODO: Use profile image of the currently logged in user
                imageUrl:
                    "https://image.freepik.com/free-vector/head-man_1308-33466.jpg",
                width: ScreenUtil().setWidth(40),
                height: ScreenUtil().setHeight(40),
                fit: BoxFit.cover,
              ),
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(
              'images/market_images/search_right.svg',
              color: Colors.white,
              width: ScreenUtil().setWidth(20.0),
              height: ScreenUtil().setHeight(20.0),
            ),
            onPressed: () {
              //showSearch(context: context, delegate: MarketSearchNormal());
              Navigator.pushNamed(context, MarketSearch.id);
            },
          ),
          Row(
            children: <Widget>[
              NewUsedButton(
                buttonText: kNew,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0))),
                textColor: newUsedState.newUsedSwitch
                    ? Color(0xffFFE07D)
                    : Colors.white,
                elevation: newUsedState.newUsedSwitch ? 2.0 : 15.0,
                onPressed: () {
                  newUsedState.newSwitch();
                },
              ),
              NewUsedButton(
                buttonText: kUsed,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0))),
                textColor: newUsedState.newUsedSwitch
                    ? Colors.white
                    : Color(0xffFFE07D),
                elevation: newUsedState.newUsedSwitch ? 15.0 : 2.0,
                onPressed: () {
                  newUsedState.usedSwitch();
                },
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        Consumer<ShoppingCart>(
          builder: (_, cart, __) => BadgeCounter(
            badgeText: cart.numOfItems.toString(),
            iconData: Icons.shopping_cart,
            showBadge: cart.numOfItems >= 1 ? true : false,
            onTap: () {
              /// Checks to see if the user is already on the shopping cart screen
              if (ModalRoute.of(context)?.settings?.name !=
                  ShoppingCartScreen.id) {
                Navigator.pushNamed(context, ShoppingCartScreen.id);
              }
            },
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(16),
        ),
        BadgeCounter(
          badgeText: '',
          iconData: Icons.notifications_none,
          showBadge: false,
          onTap: () {
            /// Checking to see what the current screen is
            if (ModalRoute.of(context)?.settings?.name !=
                MarketNotifications.id) {
              Navigator.pushNamed(context, MarketNotifications.id);
            }
          },
        ),
        SizedBox(
          width: ScreenUtil().setWidth(8.0),
        ),
      ],
    );
  }
}
