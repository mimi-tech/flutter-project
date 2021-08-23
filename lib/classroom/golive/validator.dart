class Validator {



  static String? validateTitle(String? value) {
  if(value!.isEmpty) {
  return "Title can't be empty";
  }
  if(value.length < 2) {
  return "Title is too short";
  }

  return null;
  }



  static String? validateCourseName(String? value) {
    if(value!.isEmpty) {
      return "Course name can't be empty";
    }
    if(value.length < 2) {
      return "Course name is too short";
    }

    return null;
  }

  static String? validateCourseTopic(String? value) {
    if(value!.isEmpty) {
      return "Course topic name can't be empty";
    }
    if(value.length < 2) {
      return "Course topic is too short";
    }

    return null;
  }

  static String? validateSchUn(String? value) {
    if(value!.isEmpty) {
      return "field can't be empty";
    }


    return null;
  }


  static String? validateSchTeacher(String? value) {
    if(value!.isEmpty) {
      return "Pin can't be empty";
    }


    return null;
  }

  static String? validateCourseSubTopic(String? value) {
    if(value!.isEmpty) {
      return "Course sub topic name can't be empty";
    }
    if(value.length < 2) {
      return "Course sub topic is too short";
    }

    return null;
  }

  static String? validateDesc(String? value) {
    if(value!.isEmpty) {
      return "Description can't be empty";
    }
    if(value.length < 2) {
      return "Description is too short";
    }

    return null;
  }

  static String? validateWelcome(String? value) {
    if(value!.isEmpty) {
      return "Welcome your students.";
    }
    if(value.length < 2) {
      return "Welcome message is too short";
    }

    return null;
  }


  static String? validateCong(String? value) {
    if(value!.isEmpty) {
      return "Congratulate your students";
    }
    if(value.length < 2) {
      return "Congratulatory message is too short";
    }

    return null;
  }

  static String? validateCate(String value) {
    if(value.isEmpty) {
      return "Category can't be empty";
    }
    if(value.length < 2) {
      return "Category is too short";
    }

    return null;
  }


  static String? validateStudent1(String? value) {
    if(value!.isEmpty) {
      return "Enter student's first name";
    }

    return null;
  }

  static String? validateStudent2(String? value) {
    if(value!.isEmpty) {
      return "Enter student's last name";
    }

    return null;
  }

  static String? validateStudent3(String? value) {
    if(value!.isEmpty) {
      return "Enter students level";
    }

    return null;
  }


  static String? validateStudent4(String? value) {
    if(value!.isEmpty) {
      return "Student class can't be empty";
    }

    return null;
  }

  static String? validateStudent5(String? value) {
    if(value!.isEmpty) {
      return "Field can't be empty";
    }

    return null;
  }

}