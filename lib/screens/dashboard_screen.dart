import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../services/local_storage_service.dart';
import '../services/food_service.dart';
import '../widgets/molecules/responsive_recipe_card.dart';
import '../widgets/atoms/custom_button.dart';
import '../config/app_config.dart';
import '../utils/responsive_helper.dart';
import '../config/app_theme.dart';
import 'favorites_screen.dart';
import 'recipe_detail_screen.dart';
import 'category_recipes_screen.dart';
import 'foods_screen.dart';
import '../services/translation_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Recipe> _apiRecipes = [];
  List<String> _favoriteIds = [];
  List<String> _categories = [];
  int _foodCount = 0;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Carregar dados da API em paralelo
      await Future.wait([
        _loadCategories(),
        _loadRandomRecipes(),
        _loadFavorites(),
        _loadFoodCount(),
      ]);
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar dados: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await RecipeService.getCategories();
      setState(() {
        _categories = categories.map((c) => c).toList();
      });
    } catch (e) {
      print('Erro ao carregar categorias: $e');
    }
  }

  Future<void> _loadRandomRecipes() async {
    try {
      // Usar configuração para melhor performance
      final recipes = await RecipeService.getRandomRecipes(AppConfig.maxRandomRecipes);
      setState(() {
        _apiRecipes = recipes;
      });
    } catch (e) {
      print('Erro ao carregar receitas da API: $e');
    }
  }


  Future<void> _loadFavorites() async {
    try {
      final favorites = await LocalStorageService.loadFavorites();
      setState(() {
        _favoriteIds = favorites;
      });
    } catch (e) {
      print('Erro ao carregar favoritos: $e');
    }
  }

  Future<void> _loadFoodCount() async {
    try {
      final foods = await FoodService.loadFoods();
      setState(() {
        _foodCount = foods.length;
      });
    } catch (e) {
      print('Erro ao carregar quantidade de alimentos: $e');
    }
  }

  void _toggleFavorite(Recipe recipe) async {
    if (_favoriteIds.contains(recipe.id)) {
      await LocalStorageService.removeFromFavorites(recipe.id);
      setState(() {
        _favoriteIds.remove(recipe.id);
      });
    } else {
      await LocalStorageService.addToFavorites(recipe.id);
      setState(() {
        _favoriteIds.add(recipe.id);
      });
    }
  }

  bool _isFavorite(Recipe recipe) {
    return _favoriteIds.contains(recipe.id);
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget()
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: ResponsiveHelper.getPadding(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                            _buildWelcomeSection(),
                            SizedBox(height: ResponsiveHelper.getSpacing(context) * 2),
                            _buildApiRecipesSection(),
                            SizedBox(height: ResponsiveHelper.getSpacing(context) * 2),
                            _buildCategoriesSection(),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: "Alimentos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoritos",
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const FoodsScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const FavoritesScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      margin: ResponsiveHelper.getScreenPadding(context),
      child: Card(
        elevation: ResponsiveHelper.getElevation(context, 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 20)),
        ),
        child: Container(
          padding: ResponsiveHelper.getCardPadding(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 20)),
            gradient: AppTheme.primaryGradient,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 50)),
                ),
                child: Icon(
                  Icons.restaurant_menu,
                  size: ResponsiveHelper.getIconSize(context, 48),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: ResponsiveHelper.getVerticalSpacing(context)),
              Text(
                'Bem-vindo ao EcoList!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveHelper.getVerticalSpacing(context) / 2),
              Text(
                'Gerencie seus alimentos e descubra receitas incríveis',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveHelper.getVerticalSpacing(context) / 2),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getSpacing(context),
                  vertical: ResponsiveHelper.getSpacing(context) / 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 20)),
                ),
                child: Text(
                  '${_foodCount} alimentos • ${_favoriteIds.length} favoritos',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildApiRecipesSection() {
    if (_apiRecipes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Receitas Sugeridas',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 18),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context)),
        ResponsiveHelper.isMobile(context)
            ? Column(
                children: _apiRecipes.take(3).map((recipe) {
                  return ResponsiveRecipeCard(
                    title: recipe.title,
                    description: recipe.description,
                    imageUrl: recipe.imageUrl,
                    category: recipe.category,
                    isFavorite: _isFavorite(recipe),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                    onFavoriteToggle: () => _toggleFavorite(recipe),
                  );
                }).toList(),
              )
            : SizedBox(
                height: ResponsiveHelper.getCardHeight(context),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _apiRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _apiRecipes[index];
                    return SizedBox(
                      width: ResponsiveHelper.getCardWidth(context),
                      child: ResponsiveRecipeCard(
                        title: recipe.title,
                        description: recipe.description,
                        imageUrl: recipe.imageUrl,
                        category: recipe.category,
                        isFavorite: _isFavorite(recipe),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(recipe: recipe),
                            ),
                          );
                        },
                        onFavoriteToggle: () => _toggleFavorite(recipe),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    if (_categories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context) / 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 12)),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3), width: 1),
              ),
              child: Icon(
                Icons.category,
                color: AppTheme.primaryColor,
                size: ResponsiveHelper.getIconSize(context, 20),
              ),
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context) / 2),
            Text(
              'Categorias',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context)),
        ResponsiveHelper.isMobile(context)
            ? Center(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: ResponsiveHelper.getSpacing(context) / 2,
                    mainAxisSpacing: ResponsiveHelper.getSpacing(context) / 2,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: _categories.take(6).length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return _buildCategoryCard(category);
                  },
                ),
              )
            : SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Padding(
                      padding: EdgeInsets.only(right: ResponsiveHelper.getSpacing(context) / 2),
                      child: SizedBox(
                        width: 140,
                        child: _buildCategoryCard(category),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildCategoryCard(String category) {
    final translatedCategory = TranslationService.translateCategory(category);
    final categoryIcon = AppTheme.getRecipeCategoryIcon(translatedCategory);
    
    return Card(
      elevation: ResponsiveHelper.getElevation(context, 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 12)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 12)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryRecipesScreen(categoryKey: category),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context) / 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 12)),
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.05),
                AppTheme.primaryLightColor.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context) / 3),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 8)),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3), width: 1),
                ),
                child: Icon(
                  categoryIcon,
                  color: AppTheme.primaryColor,
                  size: ResponsiveHelper.getIconSize(context, 18),
                ),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context) / 3),
              Expanded(
                child: Text(
                  translatedCategory,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _error!,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Tentar Novamente',
            onPressed: _loadData,
            icon: Icons.refresh,
          ),
        ],
      ),
    );
  }
}
