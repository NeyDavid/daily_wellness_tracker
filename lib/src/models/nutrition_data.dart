import 'package:daily_wellness_tracker/src/models/meal_item.dart';

class NutritionData {
  final DateTime date;
  final double calories;
  final double carbohydrates;
  final double proteins;
  final double fats;
  final double water;
  final List<MealItem> mealItems;

  const NutritionData({
    required this.date,
    required this.calories,
    required this.carbohydrates,
    required this.proteins,
    required this.fats,
    required this.water,
    required this.mealItems,
  });

  NutritionData.empty()
    : date = DateTime.now(),
      calories = 0.0,
      carbohydrates = 0.0,
      proteins = 0.0,
      fats = 0.0,
      water = 0.0,
      mealItems = [];

  NutritionData.forDate(DateTime inputDate)
    : date = inputDate,
      calories = 0.0,
      carbohydrates = 0.0,
      proteins = 0.0,
      fats = 0.0,
      water = 0.0,
      mealItems = [];

  NutritionData copyWith({
    DateTime? date,
    double? calories,
    double? carbohydrates,
    double? proteins,
    double? fats,
    double? water,
    List<MealItem>? mealItems,
  }) {
    return NutritionData(
      date: date ?? this.date,
      calories: calories ?? this.calories,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      proteins: proteins ?? this.proteins,
      fats: fats ?? this.fats,
      water: water ?? this.water,
      mealItems: mealItems ?? this.mealItems,
    );
  }

  NutritionData addValues({
    double calories = 0.0,
    double carbohydrates = 0.0,
    double proteins = 0.0,
    double fats = 0.0,
    double water = 0.0,
    List<MealItem>? mealItems,
  }) {
    return NutritionData(
      date: date,
      calories: this.calories + calories,
      carbohydrates: this.carbohydrates + carbohydrates,
      proteins: this.proteins + proteins,
      fats: this.fats + fats,
      water: this.water + water,
      mealItems: mealItems ?? this.mealItems,
    );
  }

  NutritionData addMealItems(List<MealItem> newMealItems) {
    final updatedMealItems = [...mealItems, ...newMealItems];

    double totalCalories = 0;
    double totalCarbohydrates = 0;
    double totalProteins = 0;
    double totalFats = 0;

    for (final item in updatedMealItems) {
      final nutritionValues = item.toNutritionValues();
      totalCalories += nutritionValues['calories']!;
      totalCarbohydrates += nutritionValues['carbohydrates']!;
      totalProteins += nutritionValues['proteins']!;
      totalFats += nutritionValues['fats']!;
    }

    return copyWith(
      mealItems: updatedMealItems,
      calories: totalCalories,
      carbohydrates: totalCarbohydrates,
      proteins: totalProteins,
      fats: totalFats,
    );
  }
}
