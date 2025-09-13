import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/food_item.dart';
import '../services/food_service.dart';
import '../services/recipe_service.dart';
import '../utils/responsive_helper.dart';
import 'recipe_detail_screen.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodItem food;

  const FoodDetailScreen({
    super.key,
    required this.food,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  List<String> _suggestedRecipes = [];
  bool _isLoadingRecipes = false;

  @override
  void initState() {
    super.initState();
    _loadSuggestedRecipes();
  }

  Future<void> _loadSuggestedRecipes() async {
    setState(() {
      _isLoadingRecipes = true;
    });

    try {
      final suggestions = await FoodService.suggestRecipesFromIngredients([widget.food]);
      setState(() {
        _suggestedRecipes = suggestions;
        _isLoadingRecipes = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingRecipes = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoList'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: AnimationLimiter(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.getPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 600),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                // Card principal do alimento
                _buildFoodCard(),
                SizedBox(height: ResponsiveHelper.getSpacing(context) * 2),

                // Informações detalhadas
                _buildDetailsSection(),
                SizedBox(height: ResponsiveHelper.getSpacing(context) * 2),

                // Sugestões de receitas
                _buildSuggestedRecipesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: widget.food.statusColor.withOpacity(0.3),
          width: 3,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context) * 1.5),
        child: Column(
          children: [
            // Ícone da categoria
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                _getCategoryIcon(widget.food.category),
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context)),

            // Nome do alimento
            Text(
              widget.food.name,
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, 24),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context) / 2),

            // Categoria
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.food.categoryName,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, 16),
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context)),

            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: widget.food.statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: widget.food.statusColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getStatusIcon(),
                    color: widget.food.statusColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.food.statusText,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, 16),
                      color: widget.food.statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações Detalhadas',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context)),
        
        _buildInfoRow(
          Icons.scale,
          'Quantidade',
          '${widget.food.quantity} ${widget.food.unitName}',
        ),
        _buildInfoRow(
          Icons.shopping_cart,
          'Data de Compra',
          _formatDate(widget.food.purchaseDate),
        ),
        _buildInfoRow(
          Icons.schedule,
          'Data de Vencimento',
          _formatDate(widget.food.expiryDate),
        ),
        _buildInfoRow(
          Icons.timer,
          'Dias até vencer',
          _getDaysUntilExpiry(),
        ),
        
        if (widget.food.notes != null && widget.food.notes!.isNotEmpty) ...[
          SizedBox(height: ResponsiveHelper.getSpacing(context)),
          _buildInfoRow(
            Icons.note,
            'Observações',
            widget.food.notes!,
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.getSpacing(context)),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, 14),
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, 16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedRecipesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Receitas Sugeridas',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context)),
        
        if (_isLoadingRecipes)
          const Center(child: CircularProgressIndicator())
        else if (_suggestedRecipes.isEmpty)
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.grey.shade600),
                SizedBox(width: ResponsiveHelper.getSpacing(context)),
                Expanded(
                  child: Text(
                    'Nenhuma receita sugerida encontrada para este alimento.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: ResponsiveHelper.getFontSize(context, 14),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ..._suggestedRecipes.map((recipeName) {
            return Card(
              margin: EdgeInsets.only(bottom: ResponsiveHelper.getSpacing(context) / 2),
              child: ListTile(
                leading: Icon(
                  Icons.restaurant,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  recipeName,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, 16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Receita sugerida com ${widget.food.name}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, 12),
                    color: Colors.grey.shade600,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _searchRecipe(recipeName);
                },
              ),
            );
          }).toList(),
      ],
    );
  }

  Future<void> _searchRecipe(String recipeName) async {
    try {
      final recipes = await RecipeService.searchRecipes(recipeName);
      if (recipes.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipe: recipes.first),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Receita "$recipeName" não encontrada'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar receita: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  IconData _getCategoryIcon(FoodCategory category) {
    switch (category) {
      case FoodCategory.carne:
        return Icons.restaurant;
      case FoodCategory.verdura:
        return Icons.eco;
      case FoodCategory.fruta:
        return Icons.apple;
      case FoodCategory.laticinios:
        return Icons.local_drink;
      case FoodCategory.graos:
        return Icons.grain;
      case FoodCategory.temperos:
        return Icons.spa;
      case FoodCategory.bebidas:
        return Icons.local_bar;
      case FoodCategory.outros:
        return Icons.category;
    }
  }

  IconData _getStatusIcon() {
    if (widget.food.isExpiredCheck) return Icons.error;
    if (widget.food.isNearExpiryCheck) return Icons.warning;
    return Icons.check_circle;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getDaysUntilExpiry() {
    final now = DateTime.now();
    final difference = widget.food.expiryDate.difference(now).inDays;
    
    if (difference == 0) {
      return 'Vence hoje';
    } else if (difference == 1) {
      return 'Vence amanhã';
    } else if (difference > 0) {
      return '$difference dias';
    } else {
      return 'Vencido há ${-difference} dias';
    }
  }
}
