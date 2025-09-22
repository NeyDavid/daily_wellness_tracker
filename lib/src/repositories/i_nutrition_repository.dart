import '../models/meal_item.dart';
import '../models/nutrition_data.dart';

abstract class INutritionRepository {
  List<NutritionData> getAllNutritionData();
  NutritionData getNutritionDataByDate(DateTime date);
  void saveMealItem(List<MealItem> mealItems);
  void addWater(double waterAmount, {DateTime? date});
  void removeAllWater(DateTime date);
  void removeMealItem(DateTime date, MealItem itemToRemove);
}
