import 'dart:collection';

import 'package:daily_wellness_tracker/src/models/meal_item.dart';
import 'package:flutter/material.dart';

import 'models/nutrition_data.dart';
import 'repositories/i_nutrition_repository.dart';
import 'repositories/nutrition_repository.dart';

class NutritionDataController extends ChangeNotifier {
  final INutritionRepository _repository = NutritionRepository();

  UnmodifiableListView<NutritionData> get listNutritionData =>
      UnmodifiableListView(_repository.getAllNutritionData());

  NutritionData getNutritionDataByDate(DateTime date) {
    return _repository.getNutritionDataByDate(date);
  }

  void saveMealItem(List<MealItem> mealItems) {
    _repository.saveMealItem(mealItems);
    notifyListeners();
  }

  void addWater(double waterAmount, {DateTime? date}) {
    _repository.addWater(waterAmount, date: date);
    notifyListeners();
  }

  void removeAllWater(DateTime date) {
    _repository.removeAllWater(date);
    notifyListeners();
  }

  void removeMealItem(DateTime date, MealItem itemToRemove) {
    _repository.removeMealItem(date, itemToRemove);
    notifyListeners();
  }
}
