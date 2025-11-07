import 'package:flutter/foundation.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../models/recipe.dart';
import '../../config/app_config.dart';

/// Provider para gerenciamento de estado das receitas (Presentation Layer)
class RecipeProvider with ChangeNotifier {
  final RecipeRepository _repository;

  RecipeProvider(this._repository);

  List<Recipe> _recipes = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Recipe> get recipes => _recipes;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Carrega receitas aleatórias
  Future<void> loadRandomRecipes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _recipes = await _repository.getRandomRecipes(AppConfig.maxRandomRecipes);
      _error = null;
    } catch (e) {
      _error = 'Erro ao carregar receitas: $e';
      _recipes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Carrega categorias
  Future<void> loadCategories() async {
    try {
      _categories = await _repository.getCategories();
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar categorias: $e';
      notifyListeners();
    }
  }

  /// Busca receitas por categoria
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    try {
      return await _repository.getRecipesByCategory(category);
    } catch (e) {
      _error = 'Erro ao buscar receitas por categoria: $e';
      notifyListeners();
      return [];
    }
  }

  /// Busca receita por ID
  Future<Recipe?> getRecipeById(String id) async {
    try {
      return await _repository.getRecipeById(id);
    } catch (e) {
      _error = 'Erro ao buscar receita: $e';
      notifyListeners();
      return null;
    }
  }

  /// Busca receitas por nome
  Future<List<Recipe>> searchRecipes(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await _repository.searchRecipes(query);
      _isLoading = false;
      notifyListeners();
      return results;
    } catch (e) {
      _error = 'Erro ao buscar receitas: $e';
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  /// Limpa o erro
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

