import 'package:flutter/material.dart';
import '../models/lecture.dart';
import '../models/cashflow.dart';
import '../services/lecture_service.dart';
import '../services/cashflow_service.dart';

class MasjidProvider with ChangeNotifier {
  List<Lecture> _lectures = [];
  List<Cashflow> _cashflows = [];
  bool _isLoading = false;

  List<Lecture> get lectures => _lectures;
  List<Cashflow> get cashflows => _cashflows;
  bool get isLoading => _isLoading;

  Future<void> loadLectures() async {
    _isLoading = true;
    notifyListeners();
    try {
      _lectures = await LectureService.getLectures();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCashflows() async {
    _isLoading = true;
    notifyListeners();
    try {
      _cashflows = await CashflowService.getCashflows();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLecture(
    String title,
    String speaker,
    DateTime date,
    String? description,
    String token,
  ) async {
    try {
      final newLecture = await LectureService.createLecture(
        title,
        speaker,
        date,
        description,
        token,
      );
      _lectures.add(newLecture);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> addCashflow(
    String title,
    int amount,
    String type,
    DateTime date,
    String token,
  ) async {
    try {
      final newCashflow = await CashflowService.createCashflow(
        title,
        amount,
        type,
        date,
        token,
      );
      _cashflows.add(newCashflow);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }
}
