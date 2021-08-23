import 'package:flutter/material.dart';

class PostRender extends StatelessWidget {
  const PostRender({Key? key, required this.postData}) : super(key: key);

  final Map<String, dynamic> postData;

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
