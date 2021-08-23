import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

class AppbarSwitchComponent extends StatefulWidget {
  const AppbarSwitchComponent({Key? key}) : super(key: key);

  @override
  _AppbarComponentSwitchState createState() => _AppbarComponentSwitchState();
}

class _AppbarComponentSwitchState extends State<AppbarSwitchComponent> {
  static bool fontScale = true;

  void toggleSwitch(bool value) {
    if (Variables.switchControl == false) {
      setState(() {
        Variables.switchControl = true;
      });
      print('Switch is ON');
      // Put your code here which you want to execute on Switch ON event.
      setState(() {
        Variables.menteesVal = true;
      });
    } else {
      setState(() {
        Variables.switchControl = false;
      });
      print('Switch is OFF');
      // Put your code here which you want to execute on Switch OFF event.
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Switch(
      onChanged: toggleSwitch,
      value: Variables.switchControl,
      activeColor: kMaincolor,
      activeTrackColor: kSwitchfadecolor,
      inactiveThumbColor: kSwitchoffColor,
      inactiveTrackColor: kSwitchoffColors,
    );
  }
}
