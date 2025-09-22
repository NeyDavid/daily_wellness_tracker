import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../nutrition_data_controller.dart';
import '../../models/nutrition_data.dart';
import '../../models/meal_item.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B68EE), Color(0xFF9370DB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Histórico',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: _showDatePicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getFormattedDate(selectedDate),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Consumer<NutritionDataController>(
                      builder: (context, controller, child) {
                        final nutritionData = controller.getNutritionDataByDate(
                          selectedDate,
                        );
                        return _buildHistoryContent(nutritionData);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryContent(NutritionData nutritionData) {
    final mealsByPeriod = _groupMealItemsByMealPeriod(nutritionData.mealItems);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getDateDisplayText(selectedDate),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '${nutritionData.mealItems.length} refeições',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Icon(Icons.restaurant, color: Colors.grey[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Calorias',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                '${nutritionData.calories.toInt()}/2000',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Icon(Icons.water_drop, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Água',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                '${nutritionData.water.toInt()}/2000ml',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              if (nutritionData.water > 0) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showDeleteWaterDialog(nutritionData.water),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: Colors.red[600],
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMacroColumn(
                '${nutritionData.carbohydrates.toInt()}g',
                'Carbs',
              ),
              _buildMacroColumn(
                '${nutritionData.proteins.toInt()}g',
                'Protein',
              ),
              _buildMacroColumn('${nutritionData.fats.toInt()}g', 'Fat'),
            ],
          ),

          const SizedBox(height: 24),

          if (nutritionData.mealItems.isNotEmpty) ...[
            const Text(
              'Meals:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: [
                  // Group meals by period and show them
                  ...mealsByPeriod.entries.map((entry) {
                    return _buildMealGroupCard(entry.key, entry.value);
                  }),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Icon(Icons.no_meals, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma refeição registrada',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  Text(
                    'neste dia',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMacroColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildMealGroupCard(String mealPeriod, List<MealItem> items) {
    final totalCalories = items.fold<double>(
      0.0,
      (sum, item) => sum + (item.calories * item.portions),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mealPeriod,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${totalCalories.toInt()} cal',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showDeleteMealGroupDialog(mealPeriod, items),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: Colors.red[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (items.length > 1) ...[
            const SizedBox(height: 4),
            Text(
              '(${items.length} itens)',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 12,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat('HH:mm').format(item.dateTime),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                '${(item.calories * item.portions).toInt()} cal',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (item.portions != 1)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${item.portions.toString().replaceAll(RegExp(r'\.0$'), '')} porções',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.orange[800],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              if (item.portions != 1 && item.weight > 0)
                                const SizedBox(width: 4),
                              if (item.weight > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${(item.weight * item.portions).toStringAsFixed(0)}g',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green[800],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _showDeleteFoodItemDialog(item),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: Colors.red[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<MealItem>> _groupMealItemsByMealPeriod(
    List<MealItem> mealItems,
  ) {
    final Map<String, List<MealItem>> grouped = {};

    for (final item in mealItems) {
      final period = item.getMealPeriod();
      if (!grouped.containsKey(period)) {
        grouped[period] = [];
      }
      grouped[period]!.add(item);
    }

    for (final key in grouped.keys) {
      grouped[key]!.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    }

    return grouped;
  }

  String _getFormattedDate(DateTime date) {
    if (_isToday(date)) {
      return 'Hoje';
    } else if (_isYesterday(date)) {
      return 'Ontem';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  String _getDateDisplayText(DateTime date) {
    if (_isToday(date)) {
      return 'Hoje';
    } else if (_isYesterday(date)) {
      return 'Ontem';
    } else {
      return DateFormat('dd \'de\' MMMM', 'pt_BR').format(date);
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showDeleteWaterDialog(double currentWater) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Água'),
          content: Text(
            'Deseja excluir toda a água registrada hoje (${currentWater.toInt()}ml)?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final controller = context.read<NutritionDataController>();
                controller.removeAllWater(selectedDate);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteMealGroupDialog(String mealPeriod, List<MealItem> items) {
    final totalCalories = items.fold<double>(
      0.0,
      (sum, item) => sum + (item.calories * item.portions),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir $mealPeriod'),
          content: Text(
            'Deseja excluir toda a refeição de $mealPeriod com ${items.length} ${items.length == 1 ? 'item' : 'itens'} (${totalCalories.toInt()} calorias)?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final controller = context.read<NutritionDataController>();
                for (final item in items) {
                  controller.removeMealItem(selectedDate, item);
                }
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteFoodItemDialog(MealItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Item'),
          content: Text(
            'Deseja excluir "${item.name}" (${(item.calories * item.portions).toInt()} calorias)?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final controller = context.read<NutritionDataController>();
                controller.removeMealItem(selectedDate, item);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}
