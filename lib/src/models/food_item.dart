// ignore_for_file: prefer_initializing_formals

class FoodItem {
  final String id;
  final String name;
  final double calories;
  final double portions;
  final double carbohydrates;
  final double proteins;
  final double fats;
  final DateTime dateTime; // Data e hora da refeição

  const FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.portions,
    required this.carbohydrates,
    required this.proteins,
    required this.fats,
    required this.dateTime,
  });

  FoodItem.empty()
    : id = '',
      name = '',
      calories = 0.0,
      portions = 1.0,
      carbohydrates = 0.0,
      proteins = 0.0,
      fats = 0.0,
      dateTime = DateTime.now();

  // Construtor para criar com data/hora específica
  FoodItem.create({
    required String name,
    required double calories,
    required double portions,
    required double carbohydrates,
    required double proteins,
    required double fats,
    DateTime? dateTime,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString(),
       name = name,
       calories = calories,
       portions = portions,
       carbohydrates = carbohydrates,
       proteins = proteins,
       fats = fats,
       dateTime = dateTime ?? DateTime.now();

  FoodItem copyWith({
    String? id,
    String? name,
    double? calories,
    double? portions,
    double? carbohydrates,
    double? proteins,
    double? fats,
    DateTime? dateTime,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      portions: portions ?? this.portions,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      proteins: proteins ?? this.proteins,
      fats: fats ?? this.fats,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  FoodItem calculateTotalNutrition() {
    return copyWith(
      calories: calories * portions,
      carbohydrates: carbohydrates * portions,
      proteins: proteins * portions,
      fats: fats * portions,
    );
  }

  Map<String, double> toNutritionValues() {
    final total = calculateTotalNutrition();
    return {
      'calories': total.calories,
      'carbohydrates': total.carbohydrates,
      'proteins': total.proteins,
      'fats': total.fats,
    };
  }

  // Métodos para trabalhar com data e hora
  String getFormattedTime() {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String getFormattedDate() {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  String getFormattedDateTime() {
    return '${getFormattedDate()} às ${getFormattedTime()}';
  }

  // Verificar se a refeição é de hoje
  bool isFromToday() {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  // Categorizar por período do dia
  String getMealPeriod() {
    final hour = dateTime.hour;
    if (hour >= 6 && hour < 12) {
      return 'Café da manhã';
    } else if (hour >= 12 && hour < 15) {
      return 'Almoço';
    } else if (hour >= 15 && hour < 18) {
      return 'Lanche da tarde';
    } else if (hour >= 18 && hour < 22) {
      return 'Jantar';
    } else {
      return 'Lanche noturno';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'portions': portions,
      'carbohydrates': carbohydrates,
      'proteins': proteins,
      'fats': fats,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      calories: map['calories']?.toDouble() ?? 0.0,
      portions: map['portions']?.toDouble() ?? 1.0,
      carbohydrates: map['carbohydrates']?.toDouble() ?? 0.0,
      proteins: map['proteins']?.toDouble() ?? 0.0,
      fats: map['fats']?.toDouble() ?? 0.0,
      dateTime: map['dateTime'] != null
          ? DateTime.parse(map['dateTime'])
          : DateTime.now(),
    );
  }
}
