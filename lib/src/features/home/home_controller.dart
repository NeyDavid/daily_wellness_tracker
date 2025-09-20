import 'dart:collection';

import 'package:daily_wellness_tracker/src/models/food_item.dart';
import 'package:flutter/material.dart';

import '../../models/nutrition_data.dart';

class HomeController extends ChangeNotifier {
  final List<NutritionData> _listNutritionData = [];

  UnmodifiableListView<NutritionData> get listNutritionData =>
      UnmodifiableListView(_listNutritionData);

  saveFoodItem(List<FoodItem> foodItems) {
    final today = DateTime.now();
    final todayDataIndex = _listNutritionData.indexWhere(
      (data) =>
          data.date.year == today.year &&
          data.date.month == today.month &&
          data.date.day == today.day,
    );

    if (todayDataIndex == -1) {
      final newNutritionData = NutritionData.forDate(
        today,
      ).addFoodItems(foodItems);
      _listNutritionData.add(newNutritionData);
    } else {
      _listNutritionData[todayDataIndex] = _listNutritionData[todayDataIndex]
          .addFoodItems(foodItems);
    }
    notifyListeners();
  }
}
