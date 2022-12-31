import 'package:Hutaf/models/courses/course_model.dart';
import 'package:Hutaf/models/courses/trainer_model.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrainerProvider with ChangeNotifier {
  List<CourseModel> _trainerCourses = [];

  TrainerModel _trainer = TrainerModel(
    id: '',
    name: '',
    description: '',
    image: '',
    job: '',
  );
  bool _isTrainerError = false;
  bool _isTrainerEmpty = false;
  bool _isTrainerCoursesError = false;
  bool _isTrainerCoursesEmpty = false;
  bool _isCourseDetailsError = false;
  bool _isCourseDetailsEmpty = false;

  ///
  ///
  ///
  Future getTrainer(String trainerId) async {
    _isTrainerEmpty = false;
    _isTrainerError = false;
    clearTrainerData();
    await FirebaseFirestore.instance
        .collection('trainers')
        .doc(trainerId)
        .get()
        .then((doc) async {
      if (doc.exists) {
        if (doc.data().isNotEmpty) {
          _trainer = TrainerModel.fromSnapshot(doc.id, doc.data());
          try {
            String url = Assets.getPublicMedia(doc.data()['image']);
            _trainer.image = url;
          } catch (error) {
            // print(error.toString());
          }
        } else {
          _isCourseDetailsEmpty = true;
        }
      } else {
        _isCourseDetailsEmpty = true;
      }
    }).catchError((error) {
      _isCourseDetailsError = true;
    });
    notifyListeners();

    loadTrainerCourses(trainerId);
  }

  ///
  ///
  ///
  Future loadTrainerCourses(String trainerId) async {
    _trainerCourses.clear();
    _isTrainerCoursesError = false;
    await FirebaseFirestore.instance
        .collection('courses')
        .where('trainer_id', isEqualTo: trainerId)
        .limit(10)
        .get()
        .then((documents) async {
      if (documents.docs.length == 0) {
        _trainerCourses = [];
        _isTrainerCoursesEmpty = true;
      }

      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            _trainerCourses.add(CourseModel.fromSnapshot(doc.id, doc.data()));
            try {
              String url = Assets.getPublicMedia(doc.data()['image']);
              _trainerCourses[_trainerCourses.length - 1].image = url;
            } catch (error) {
              // print(error.toString());
            }
          }
        }
      }
      if (_trainerCourses.length == 0) {
        _isTrainerCoursesEmpty = true;
      }
    }).catchError((error) {
      _isTrainerCoursesError = true;
    });
    notifyListeners();
  }

  ///
  ///
  ///
  void clearTrainerData() {
    _trainer = TrainerModel(
      id: '',
      name: '',
      description: '',
      image: '',
      job: '',
    );
  }

  ///
  ///
  ///
  TrainerModel get trainer {
    return _trainer;
  }

  ///
  ///
  ///
  List<CourseModel> get trainerCourses {
    return [..._trainerCourses];
  }

  ///
  ///
  ///
  bool get isTrainerEmpty {
    return _isTrainerEmpty;
  }

  ///
  ///
  ///
  bool get isTrainerError {
    return _isTrainerError;
  }

  ///
  ///
  ///
  bool get isTrainerCoursesEmpty {
    return _isTrainerCoursesEmpty;
  }

  ///
  ///
  ///
  bool get isTrainerCoursesError {
    return _isTrainerCoursesError;
  }

  ///
  ///
  ///
  bool get isCourseDetailsEmpty {
    return _isCourseDetailsEmpty;
  }

  ///
  ///
  ///
  bool get isCourseDetailsError {
    return _isCourseDetailsError;
  }
}
