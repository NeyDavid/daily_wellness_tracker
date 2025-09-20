import 'dart:collection';

import 'package:daily_wellness_tracker/src/models/food_item.dart';
import 'package:flutter/material.dart';

import '../../models/nutrition_data.dart';

class HomeController extends ChangeNotifier {
  final List<NutritionData> _listNutritionData = [];

  UnmodifiableListView<NutritionData> get listNutritionData =>
      UnmodifiableListView(_listNutritionData);

  NutritionData getNutritionDataByDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    final index = _listNutritionData.indexWhere(
      (data) =>
          data.date.year == normalizedDate.year &&
          data.date.month == normalizedDate.month &&
          data.date.day == normalizedDate.day,
    );

    if (index == -1) {
      final emptyData = NutritionData.forDate(normalizedDate);
      _listNutritionData.add(emptyData);

      return emptyData;
    }

    return _listNutritionData[index];
  }

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

  saveFoodItemForDate(List<FoodItem> foodItems, DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final dataIndex = _listNutritionData.indexWhere(
      (data) =>
          data.date.year == normalizedDate.year &&
          data.date.month == normalizedDate.month &&
          data.date.day == normalizedDate.day,
    );

    if (dataIndex == -1) {
      final newNutritionData = NutritionData.forDate(
        normalizedDate,
      ).addFoodItems(foodItems);
      _listNutritionData.add(newNutritionData);
    } else {
      _listNutritionData[dataIndex] = _listNutritionData[dataIndex]
          .addFoodItems(foodItems);
    }
    notifyListeners();
  }

  addWater(double waterAmount, {DateTime? date}) {
    final targetDate = date ?? DateTime.now();
    final normalizedDate = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    final dataIndex = _listNutritionData.indexWhere(
      (data) =>
          data.date.year == normalizedDate.year &&
          data.date.month == normalizedDate.month &&
          data.date.day == normalizedDate.day,
    );

    if (dataIndex == -1) {
      final newNutritionData = NutritionData.forDate(
        normalizedDate,
      ).addValues(water: waterAmount);
      _listNutritionData.add(newNutritionData);
    } else {
      _listNutritionData[dataIndex] = _listNutritionData[dataIndex].addValues(
        water: waterAmount,
      );
    }
    notifyListeners();
  }

  bool hasDataForDate(DateTime date) {
    return _listNutritionData.any(
      (data) =>
          data.date.year == date.year &&
          data.date.month == date.month &&
          data.date.day == date.day,
    );
  }

  List<DateTime> getDatesWithData() {
    return _listNutritionData.map((data) => data.date).toList()
      ..sort((a, b) => b.compareTo(a));
  }

  clearDataForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    _listNutritionData.removeWhere(
      (data) =>
          data.date.year == normalizedDate.year &&
          data.date.month == normalizedDate.month &&
          data.date.day == normalizedDate.day,
    );
    notifyListeners();
  }
}
