// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CounterClass extends ChangeNotifier { // ChangeNotifier를 extends한다.

  int _solvedProblemCount = 0;

  int get solvedProblemCount => _solvedProblemCount;

  // count ++
  void incrementSolvedProblemCount() {
    _solvedProblemCount++;
    notifyListeners(); // 숫자가 증가했다는 것을 ChangeNotifierProvider에 알려주기 위해 notifyListeners()를 호출한다.
  }

  // count reset
  void resetSolvedProblemCount() {
    _solvedProblemCount = 0;
    notifyListeners(); // 숫자 0으로 재 세팅
  }

}