import 'package:flutter/material.dart';

class CustomSmallFAB extends StatelessWidget {
  const CustomSmallFAB({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(
          right: 12.0,
          bottom: MediaQuery.of(context).size.height * 0.12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
