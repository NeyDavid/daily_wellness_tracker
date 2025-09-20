class NutritionGoals {
  final double caloriesGoal;
  final double carbohydratesGoal; // in grams
  final double proteinsGoal; // in grams
  final double fatsGoal; // in grams
  final double waterGoal; // in ml

  const NutritionGoals({
    required this.caloriesGoal,
    required this.carbohydratesGoal,
    required this.proteinsGoal,
    required this.fatsGoal,
    required this.waterGoal,
  });

  // Default goals
  factory NutritionGoals.defaultGoals() {
    return const NutritionGoals(
      caloriesGoal: 2000.0,
      carbohydratesGoal: 250.0,
      proteinsGoal: 150.0,
      fatsGoal: 65.0,
      waterGoal: 2000.0,
    );
  }

  // Method to copy and modify goals
  NutritionGoals copyWith({
    double? caloriesGoal,
    double? carbohydratesGoal,
    double? proteinsGoal,
    double? fatsGoal,
    double? waterGoal,
  }) {
    return NutritionGoals(
      caloriesGoal: caloriesGoal ?? this.caloriesGoal,
      carbohydratesGoal: carbohydratesGoal ?? this.carbohydratesGoal,
      proteinsGoal: proteinsGoal ?? this.proteinsGoal,
      fatsGoal: fatsGoal ?? this.fatsGoal,
      waterGoal: waterGoal ?? this.waterGoal,
    );
  }

  // Calculate progress percentage for each nutrient
  double getCaloriesProgress(double currentCalories) {
    return (currentCalories / caloriesGoal * 100).clamp(0, 100);
  }

  double getCarbsProgress(double currentCarbs) {
    return (currentCarbs / carbohydratesGoal * 100).clamp(0, 100);
  }

  double getProteinProgress(double currentProtein) {
    return (currentProtein / proteinsGoal * 100).clamp(0, 100);
  }

  double getFatProgress(double currentFat) {
    return (currentFat / fatsGoal * 100).clamp(0, 100);
  }

  double getWaterProgress(double currentWater) {
    return (currentWater / waterGoal * 100).clamp(0, 100);
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'caloriesGoal': caloriesGoal,
      'carbohydratesGoal': carbohydratesGoal,
      'proteinsGoal': proteinsGoal,
      'fatsGoal': fatsGoal,
      'waterGoal': waterGoal,
    };
  }

  // Create instance from Map
  factory NutritionGoals.fromMap(Map<String, dynamic> map) {
    return NutritionGoals(
      caloriesGoal: map['caloriesGoal']?.toDouble() ?? 2000.0,
      carbohydratesGoal: map['carbohydratesGoal']?.toDouble() ?? 250.0,
      proteinsGoal: map['proteinsGoal']?.toDouble() ?? 150.0,
      fatsGoal: map['fatsGoal']?.toDouble() ?? 65.0,
      waterGoal: map['waterGoal']?.toDouble() ?? 2000.0,
    );
  }

  @override
  String toString() {
    return 'NutritionGoals(caloriesGoal: $caloriesGoal, carbohydratesGoal: $carbohydratesGoal, proteinsGoal: $proteinsGoal, fatsGoal: $fatsGoal, waterGoal: $waterGoal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NutritionGoals &&
        other.caloriesGoal == caloriesGoal &&
        other.carbohydratesGoal == carbohydratesGoal &&
        other.proteinsGoal == proteinsGoal &&
        other.fatsGoal == fatsGoal &&
        other.waterGoal == waterGoal;
  }

  @override
  int get hashCode {
    return caloriesGoal.hashCode ^
        carbohydratesGoal.hashCode ^
        proteinsGoal.hashCode ^
        fatsGoal.hashCode ^
        waterGoal.hashCode;
  }
}
