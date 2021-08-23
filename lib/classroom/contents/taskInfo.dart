
import 'package:flutter_downloader/flutter_downloader.dart';

class TaskInfo {

  final String? name;
  final String? link;
  final String? lectureNumber;
  final String? sectionNumber;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  TaskInfo({
    this.name,
    this.link,
    this.lectureNumber,
    this.sectionNumber,
  });

}

class ItemHolder {

  final String? name;
  final TaskInfo? task;

  ItemHolder({this.name, this.task});

}

class MyDownloadableItem {

  String? name;
  String? link;

  String? taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  MyDownloadableItem({this.name, this.link});


}