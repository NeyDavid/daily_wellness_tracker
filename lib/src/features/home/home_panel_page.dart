import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../food/add_food_page.dart';
import 'home_controller.dart';

class HomePanelPage extends StatefulWidget {
  const HomePanelPage({super.key});

  @override
  State<HomePanelPage> createState() => _HomePanelPageState();
}

class _HomePanelPageState extends State<HomePanelPage>
    with SingleTickerProviderStateMixin {
  late final HomeController controller;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    controller = context.read<HomeController>();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<HomeController>(
        builder: (context, controller, child) {
          final todayNutritionData = controller.getNutritionDataByDate(
            DateTime.now(),
          );

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7B68EE), Color(0xFF9370DB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Progresso de Hoje',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getFormattedDate(),
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 32),
                    Center(
                      child: AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          final currentProgress =
                              (todayNutritionData.calories / 2000).clamp(
                                0.0,
                                1.0,
                              );
                          final animatedProgress =
                              currentProgress * _progressAnimation.value;

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 160,
                                height: 160,
                                child: CircularProgressIndicator(
                                  value: animatedProgress,
                                  strokeWidth: 8,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.3,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getProgressColor(currentProgress),
                                  ),
                                ),
                              ),

                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        todayNutritionData.calories
                                            .toInt()
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        'de 2000\ncalorias',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 32),

                    _buildMacroCard(
                      'Carboidratos',
                      todayNutritionData.carbohydrates.toInt(),
                      250,
                      'g',
                    ),
                    SizedBox(height: 12),
                    _buildMacroCard(
                      'Proteína',
                      todayNutritionData.proteins.toInt(),
                      150,
                      'g',
                    ),
                    SizedBox(height: 12),
                    _buildMacroCard(
                      'Gordura',
                      todayNutritionData.fats.toInt(),
                      65,
                      'g',
                    ),
                    SizedBox(height: 12),
                    _buildWaterCard(todayNutritionData.water.toInt()),

                    SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: Icon(Icons.restaurant),
                            label: Text('Adicionar Refeição'),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AddFoodPage(),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2196F3),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: Icon(Icons.water_drop),
                            label: Text('Adicionar Água'),
                            onPressed: () {
                              // Adicionar 250ml de água
                              controller.addWater(250.0);
                            },
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildBottomNavItem(Icons.home, 'Painel', true),
                          _buildBottomNavItem(
                            Icons.history,
                            'Histórico',
                            false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d \'de\' MMMM', 'pt_BR');
    return formatter.format(now);
  }

  Color _getProgressColor(double progress) {
    if (progress <= 0.3) {
      return const Color(0xFFE53E3E);
    } else if (progress <= 0.6) {
      return const Color(0xFFF56500);
    } else if (progress <= 0.9) {
      return const Color(0xFF4CAF50);
    } else if (progress <= 1.0) {
      return const Color(0xFF4CAF50);
    } else {
      return const Color(0xFF1976D2);
    }
  }

  // Cores específicas para cada macronutriente
  Color _getMacroProgressColor(String macroName, double progress) {
    Color baseColor;

    switch (macroName.toLowerCase()) {
      case 'carboidratos':
        baseColor = const Color(0xFF2196F3); // Azul
        break;
      case 'proteína':
        baseColor = const Color(0xFF4CAF50); // Verde
        break;
      case 'gordura':
        baseColor = const Color(0xFFFF9800); // Laranja
        break;
      default:
        baseColor = const Color(0xFF9C27B0); // Roxo padrão
    }

    // Ajustar opacidade baseado no progresso
    if (progress < 0.3) {
      return baseColor.withOpacity(0.4);
    } else if (progress < 0.7) {
      return baseColor.withOpacity(0.7);
    } else {
      return baseColor;
    }
  }

  // Cor específica para água
  Color _getWaterProgressColor(double progress) {
    const baseColor = Color(0xFF03A9F4); // Azul água

    if (progress < 0.3) {
      return baseColor.withOpacity(0.4);
    } else if (progress < 0.7) {
      return baseColor.withOpacity(0.7);
    } else {
      return baseColor;
    }
  }

  Widget _buildMacroCard(String name, int current, int target, String unit) {
    final progress = (current / target).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$current/$target$unit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Barra de progresso
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getMacroProgressColor(name, progress),
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterCard(int currentWater) {
    final progress = (currentWater / 2000).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.water_drop, color: Colors.blue[600], size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Água',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Text(
                '$currentWater/2000ml',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Barra de progresso da água
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getWaterProgressColor(progress),
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? Colors.black87 : Colors.black54, size: 24),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.black87 : Colors.black54,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
