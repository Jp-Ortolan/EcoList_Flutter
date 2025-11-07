import 'package:flutter/foundation.dart';
import '../../domain/repositories/food_repository.dart';
import '../../models/food_item.dart';

/// Provider para gerenciamento de estado dos alimentos (Presentation Layer)
class FoodProvider with ChangeNotifier {
  final FoodRepository _repository;

  FoodProvider(this._repository);

  List<FoodItem> _foods = [];
  List<FoodItem> _filteredFoods = [];
  bool _isLoading = false;
  String? _error;

  List<FoodItem> get foods => _foods;
  List<FoodItem> get filteredFoods => _filteredFoods;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Carrega todos os alimentos
  Future<void> loadFoods() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _foods = await _repository.loadFoods();
      _filteredFoods = _foods;
      _error = null;
    } catch (e) {
      _error = 'Erro ao carregar alimentos: $e';
      _foods = [];
      _filteredFoods = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adiciona um novo alimento
  Future<void> addFood(FoodItem food) async {
    try {
      await _repository.addFood(food);
      await loadFoods(); // Recarrega a lista
    } catch (e) {
      _error = 'Erro ao adicionar alimento: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Atualiza um alimento
  Future<void> updateFood(FoodItem food) async {
    try {
      await _repository.updateFood(food);
      await loadFoods(); // Recarrega a lista
    } catch (e) {
      _error = 'Erro ao atualizar alimento: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Remove um alimento
  Future<void> deleteFood(String foodId) async {
    try {
      await _repository.deleteFood(foodId);
      await loadFoods(); // Recarrega a lista
    } catch (e) {
      _error = 'Erro ao remover alimento: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Filtra alimentos por categoria
  void filterByCategory(FoodCategory? category) {
    if (category == null) {
      _filteredFoods = _foods;
    } else {
      _filteredFoods = _foods.where((food) => food.category == category).toList();
    }
    notifyListeners();
  }

  /// Busca alimentos por nome
  void searchFoods(String query) {
    if (query.isEmpty) {
      _filteredFoods = _foods;
    } else {
      _filteredFoods = _foods
          .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  /// Obtém alimentos próximos do vencimento
  Future<List<FoodItem>> getNearExpiryFoods() async {
    try {
      return await _repository.getNearExpiryFoods();
    } catch (e) {
      _error = 'Erro ao buscar alimentos próximos do vencimento: $e';
      notifyListeners();
      return [];
    }
  }

  /// Obtém alimentos vencidos
  Future<List<FoodItem>> getExpiredFoods() async {
    try {
      return await _repository.getExpiredFoods();
    } catch (e) {
      _error = 'Erro ao buscar alimentos vencidos: $e';
      notifyListeners();
      return [];
    }
  }

  /// Obtém estatísticas
  Future<Map<String, int>> getStatistics() async {
    try {
      return await _repository.getStatistics();
    } catch (e) {
      _error = 'Erro ao obter estatísticas: $e';
      notifyListeners();
      return {'total': 0, 'fresh': 0, 'nearExpiry': 0, 'expired': 0};
    }
  }

  /// Limpa o erro
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

