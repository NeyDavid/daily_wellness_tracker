import 'dart:collection';

import '../models/meal_item.dart';
import '../models/nutrition_data.dart';
import 'i_nutrition_repository.dart';

class NutritionRepository implements INutritionRepository {
  final List<NutritionData> _listNutritionData = [];

  @override
  List<NutritionData> getAllNutritionData() {
    return UnmodifiableListView(_listNutritionData);
  }

  @override
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

  @override
  void saveMealItem(List<MealItem> mealItems) {
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
      ).addMealItems(mealItems);
      _listNutritionData.add(newNutritionData);
    } else {
      _listNutritionData[todayDataIndex] = _listNutritionData[todayDataIndex]
          .addMealItems(mealItems);
    }
  }

  @override
  void addWater(double waterAmount, {DateTime? date}) {
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
  }

  @override
  void removeAllWater(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final dataIndex = _listNutritionData.indexWhere(
      (data) =>
          data.date.year == normalizedDate.year &&
          data.date.month == normalizedDate.month &&
          data.date.day == normalizedDate.day,
    );

    if (dataIndex != -1) {
      _listNutritionData[dataIndex] = _listNutritionData[dataIndex].copyWith(
        water: 0.0,
      );
    }
  }

  @override
  void removeMealItem(DateTime date, MealItem itemToRemove) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final dataIndex = _listNutritionData.indexWhere(
      (data) =>
          data.date.year == normalizedDate.year &&
          data.date.month == normalizedDate.month &&
          data.date.day == normalizedDate.day,
    );

    if (dataIndex != -1) {
      final currentData = _listNutritionData[dataIndex];
      final updatedMealItems = List<MealItem>.from(currentData.mealItems);

      final itemIndex = updatedMealItems.indexWhere(
        (item) => item.id == itemToRemove.id,
      );

      if (itemIndex != -1) {
        updatedMealItems.removeAt(itemIndex);
      }

      double totalCalories = 0.0;
      double totalCarbs = 0.0;
      double totalProteins = 0.0;
      double totalFats = 0.0;

      for (final item in updatedMealItems) {
        totalCalories += item.calories * item.portions;
        totalCarbs += item.carbohydrates * item.portions;
        totalProteins += item.proteins * item.portions;
        totalFats += item.fats * item.portions;
      }

      _listNutritionData[dataIndex] = currentData.copyWith(
        mealItems: updatedMealItems,
        calories: totalCalories,
        carbohydrates: totalCarbs,
        proteins: totalProteins,
        fats: totalFats,
      );
    }
  }
}
