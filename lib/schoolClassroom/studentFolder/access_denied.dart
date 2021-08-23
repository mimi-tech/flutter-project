import 'package:flutter/material.dart';

class AccessDenied extends StatefulWidget {
  @override
  _AccessDeniedState createState() => _AccessDeniedState();
}

class _AccessDeniedState extends State<AccessDenied> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: Container(
      child: Text('Access denied'),
    )));
  }
}
