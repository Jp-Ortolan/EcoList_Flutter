import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/food_item.dart';
import '../presentation/providers/food_provider.dart';
import '../widgets/molecules/food_card.dart';
import '../widgets/atoms/custom_button.dart';
import '../utils/responsive_helper.dart';
import '../config/app_theme.dart';
import 'add_food_screen.dart';
import 'food_detail_screen.dart';

class FoodsScreen extends StatefulWidget {
  const FoodsScreen({super.key});

  @override
  State<FoodsScreen> createState() => _FoodsScreenState();
}

class _FoodsScreenState extends State<FoodsScreen> with TickerProviderStateMixin {
  FoodCategory? _selectedCategory;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodProvider>().loadFoods();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _filterByCategory(FoodCategory? category) {
    setState(() {
      _selectedCategory = category;
    });
    context.read<FoodProvider>().filterByCategory(category);
  }

  List<FoodItem> _getFoodsByTab(int index, List<FoodItem> filteredFoods) {
    switch (index) {
      case 0: // Todos
        return filteredFoods;
      case 1: // Próximos do vencimento
        return filteredFoods.where((food) => food.isNearExpiryCheck).toList();
      case 2: // Vencidos
        return filteredFoods.where((food) => food.isExpiredCheck).toList();
      case 3: // Frescos
        return filteredFoods.where((food) => !food.isNearExpiryCheck && !food.isExpiredCheck).toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoList'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, size: 24),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddFoodScreen(),
                  ),
                );
                if (result == true) {
                  context.read<FoodProvider>().loadFoods();
                }
              },
              tooltip: 'Adicionar alimento',
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          tabs: [
            Tab(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.list, size: 20),
                  const SizedBox(height: 4),
                  const Text('Todos'),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning, size: 20, color: AppTheme.warningColor),
                  const SizedBox(height: 4),
                  const Text('Próximos'),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error, size: 20, color: AppTheme.errorColor),
                  const SizedBox(height: 4),
                  const Text('Vencidos'),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 20, color: AppTheme.successColor),
                  const SizedBox(height: 4),
                  const Text('Frescos'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filtro de categorias
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: FoodCategory.values.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedCategory == null
                            ? AppTheme.primaryColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _selectedCategory == null
                              ? AppTheme.primaryColor
                              : AppTheme.borderColor,
                          width: 2,
                        ),
                        boxShadow: _selectedCategory == null
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: _selectedCategory == null ? null : () => _filterByCategory(null),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.list,
                                  size: 16,
                                  color: _selectedCategory == null
                                      ? Colors.white
                                      : AppTheme.textSecondaryColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Todas',
                                  style: TextStyle(
                                    color: _selectedCategory == null
                                        ? Colors.white
                                        : AppTheme.textPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final category = FoodCategory.values[index - 1];
                final isSelected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _filterByCategory(category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                AppTheme.getCategoryIcon(_getCategoryName(category)),
                                size: 16,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textSecondaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _getCategoryName(category),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.textPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Lista de alimentos
          Expanded(
            child: Consumer<FoodProvider>(
              builder: (context, foodProvider, child) {
                return TabBarView(
                  controller: _tabController,
                  children: List.generate(4, (index) {
                    return _buildFoodList(
                      _getFoodsByTab(index, foodProvider.filteredFoods),
                      foodProvider.isLoading,
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList(List<FoodItem> foods, bool isLoading) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppTheme.primaryColor,
              strokeWidth: 3,
            ),
            SizedBox(height: ResponsiveHelper.getVerticalSpacing(context)),
            Text(
              'Carregando alimentos...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    if (foods.isEmpty) {
      return Center(
        child: Padding(
          padding: ResponsiveHelper.getScreenPadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.borderColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.restaurant,
                  size: ResponsiveHelper.getIconSize(context, 64),
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              SizedBox(height: ResponsiveHelper.getVerticalSpacing(context) * 2),
              Text(
                'Nenhum alimento encontrado',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveHelper.getVerticalSpacing(context)),
              Text(
                'Adicione alimentos para começar a gerenciar seu estoque',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveHelper.getVerticalSpacing(context) * 2),
              CustomButton(
                text: 'Adicionar Primeiro Alimento',
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddFoodScreen(),
                    ),
                  );
                  if (result == true) {
                    context.read<FoodProvider>().loadFoods();
                  }
                },
                icon: Icons.add,
                backgroundColor: AppTheme.primaryColor,
                width: double.infinity,
              ),
            ],
          ),
        ),
      );
    }

    return ResponsiveHelper.isMobile(context)
        ? AnimationLimiter(
            child: ListView.builder(
              padding: ResponsiveHelper.getPadding(context),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 600),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: FoodCard(
                        food: food,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodDetailScreen(food: food),
                            ),
                          );
                        },
                        onEdit: () async {
                          // TODO: Implementar edição
                        },
                        onDelete: () async {
                          await _deleteFood(food);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : AnimationLimiter(
            child: GridView.builder(
              padding: ResponsiveHelper.getPadding(context),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveHelper.getCrossAxisCount(context),
                childAspectRatio: 0.8,
                crossAxisSpacing: ResponsiveHelper.getSpacing(context),
                mainAxisSpacing: ResponsiveHelper.getSpacing(context),
              ),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 600),
                  columnCount: ResponsiveHelper.getCrossAxisCount(context),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: FoodCard(
                        food: food,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodDetailScreen(food: food),
                            ),
                          );
                        },
                        onEdit: () async {
                          // TODO: Implementar edição
                        },
                        onDelete: () async {
                          await _deleteFood(food);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  Future<void> _deleteFood(FoodItem food) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir "${food.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await context.read<FoodProvider>().deleteFood(food.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Alimento excluído com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir alimento: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String _getCategoryName(FoodCategory category) {
    switch (category) {
      case FoodCategory.carne:
        return 'Carne';
      case FoodCategory.verdura:
        return 'Verdura';
      case FoodCategory.fruta:
        return 'Fruta';
      case FoodCategory.laticinios:
        return 'Laticínios';
      case FoodCategory.graos:
        return 'Grãos';
      case FoodCategory.temperos:
        return 'Temperos';
      case FoodCategory.bebidas:
        return 'Bebidas';
      case FoodCategory.outros:
        return 'Outros';
    }
  }
}
