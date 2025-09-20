import 'package:daily_wellness_tracker/src/models/food_item.dart';

class NutritionData {
  final DateTime date;
  final double calories;
  final double carbohydrates;
  final double proteins;
  final double fats;
  final double water;
  final List<FoodItem> foodItems;

  const NutritionData({
    required this.date,
    required this.calories,
    required this.carbohydrates,
    required this.proteins,
    required this.fats,
    required this.water,
    required this.foodItems,
  });

  // Construtor para criar uma instância vazia (valores zerados)
  NutritionData.empty()
    : date = DateTime.now(),
      calories = 0.0,
      carbohydrates = 0.0,
      proteins = 0.0,
      fats = 0.0,
      water = 0.0,
      foodItems = [];

  // Construtor para criar uma instância apenas com a data
  NutritionData.forDate(DateTime inputDate)
    : date = inputDate,
      calories = 0.0,
      carbohydrates = 0.0,
      proteins = 0.0,
      fats = 0.0,
      water = 0.0,
      foodItems = [];

  // Método para copiar e modificar valores
  NutritionData copyWith({
    DateTime? date,
    double? calories,
    double? carbohydrates,
    double? proteins,
    double? fats,
    double? water,
    List<FoodItem>? foodItems,
  }) {
    return NutritionData(
      date: date ?? this.date,
      calories: calories ?? this.calories,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      proteins: proteins ?? this.proteins,
      fats: fats ?? this.fats,
      water: water ?? this.water,
      foodItems: foodItems ?? this.foodItems,
    );
  }

  // Método para adicionar valores aos existentes
  NutritionData addValues({
    double calories = 0.0,
    double carbohydrates = 0.0,
    double proteins = 0.0,
    double fats = 0.0,
    double water = 0.0,
    List<FoodItem>? foodItems,
  }) {
    return NutritionData(
      date: date,
      calories: this.calories + calories,
      carbohydrates: this.carbohydrates + carbohydrates,
      proteins: this.proteins + proteins,
      fats: this.fats + fats,
      water: this.water + water,
      foodItems: foodItems ?? this.foodItems,
    );
  }

  // Método para adicionar food items e recalcular totais nutricionais
  NutritionData addFoodItems(List<FoodItem> newFoodItems) {
    final updatedFoodItems = [...foodItems, ...newFoodItems];

    // Calcular totais nutricionais baseados em todos os food items
    double totalCalories = 0;
    double totalCarbohydrates = 0;
    double totalProteins = 0;
    double totalFats = 0;

    for (final item in updatedFoodItems) {
      final nutritionValues = item.toNutritionValues();
      totalCalories += nutritionValues['calories']!;
      totalCarbohydrates += nutritionValues['carbohydrates']!;
      totalProteins += nutritionValues['proteins']!;
      totalFats += nutritionValues['fats']!;
    }

    return copyWith(
      foodItems: updatedFoodItems,
      calories: totalCalories,
      carbohydrates: totalCarbohydrates,
      proteins: totalProteins,
      fats: totalFats,
    );
  }

  // Converter para Map (útil para persistência de dados)
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'calories': calories,
      'carbohydrates': carbohydrates,
      'proteins': proteins,
      'fats': fats,
      'water': water,
    };
  }

  // Criar instância a partir de Map
  factory NutritionData.fromMap(Map<String, dynamic> map) {
    return NutritionData(
      date: DateTime.parse(map['date']),
      calories: map['calories']?.toDouble() ?? 0.0,
      carbohydrates: map['carbohydrates']?.toDouble() ?? 0.0,
      proteins: map['proteins']?.toDouble() ?? 0.0,
      fats: map['fats']?.toDouble() ?? 0.0,
      water: map['water']?.toDouble() ?? 0.0,
      foodItems: map['foodItems'] != null
          ? List<FoodItem>.from(
              (map['foodItems'] as List).map((item) => FoodItem.fromMap(item)),
            )
          : [],
    );
  }

  // Converter para JSON string
  String toJson() {
    return '''
{
  "date": "${date.toIso8601String()}",
  "calories": $calories,
  "carbohydrates": $carbohydrates,
  "proteins": $proteins,
  "fats": $fats,
  "water": $water
}''';
  }

  @override
  String toString() {
    return 'NutritionData(date: $date, calories: $calories, carbohydrates: $carbohydrates, proteins: $proteins, fats: $fats, water: $water)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NutritionData &&
        other.date == date &&
        other.calories == calories &&
        other.carbohydrates == carbohydrates &&
        other.proteins == proteins &&
        other.fats == fats &&
        other.water == water;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        calories.hashCode ^
        carbohydrates.hashCode ^
        proteins.hashCode ^
        fats.hashCode ^
        water.hashCode;
  }
}
