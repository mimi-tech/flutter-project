import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class SearchService {
  searchByName(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('Personal')
        .where('sk', isEqualTo: searchField.substring(0, 1).toLowerCase()).orderBy('crAt')
        .get();
  }


  searchByClassName(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('expertClasses')
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase()).orderBy('date')
        .get();
  }

  searchByCourseName(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('userCourses')
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase()).orderBy('date')
        .get();
  }

  searchByTutorialTitle(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('userSessionUploads')
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase()).orderBy('ts')
        .get();
  }

  searchByStudentsName(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('userSessionUploads')
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase()).orderBy('ts')
        .get();
  }

  searchByStudentsPost(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('campusPost')
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase()).orderBy('ts')
        .get();
  }

  searchByStudentsLessons(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('schoolLessons')
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase())
        .where('tsl', isEqualTo: SchClassConstant.schDoc['lv'])
        .where('tcl', isEqualTo: SchClassConstant.schDoc['cl'])
        .where('ass', isEqualTo: true)
        .orderBy('ts')
        .get();
  }

  searchByStudentSocialClass(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('schoolSocials')
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase())
        .where('tsl', isEqualTo: SchClassConstant.schDoc['lv'])
        .where('tcl', isEqualTo: SchClassConstant.schDoc['cl'])
        .where('ass', isEqualTo: true)
        .orderBy('ts')
        .get();
  }

  searchByStudentsEClass(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('savedOnlineClasses')
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase())
        .where('cl',isEqualTo: SchClassConstant.schDoc['cl'])
        .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
        .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
        .orderBy('ts')
        .get();
  }

  searchByStudents(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('campusStudents')
        .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase()).orderBy('ts')
        .get();
  }
  searchByTeachers(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('tutors')
        .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase()).orderBy('ts')
        .get();
  }

  searchByStudentsAttendedClasses(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('classList')
        .where('stId',isEqualTo: SchClassConstant.schDoc['id'])
        .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
        .where('cl',isEqualTo: SchClassConstant.schDoc['cl'])
        .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase()).orderBy('ts')
        .get();
  }


  searchByTeacherAttendedClasses(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('savedOnlineClasses')
        .where('cl',isEqualTo: SchClassConstant.schDoc['cl'])
        .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
        .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
        .where('close',isEqualTo: true)
        .where('tcId',isEqualTo: SchClassConstant.schDoc['id'] )
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase()).orderBy('ts')
        .get();
  }

}