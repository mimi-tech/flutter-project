class Course {
  List<Lecture> lectures = [];
}

class Lecture {
  int? index;
  late int sectionLength;
  String name = '';
  List<Section> sections = [];
}

class Section {
  String? vido;
  int? sectionCount;
  String? title;
  String? at;
  String? name;
  int? lCount;
}
