import 'package:flutter/foundation.dart';
import '../../domain/repositories/favorite_repository.dart';

/// Provider para gerenciamento de estado dos favoritos (Presentation Layer)
class FavoriteProvider with ChangeNotifier {
  final FavoriteRepository _repository;

  FavoriteProvider(this._repository);

  List<String> _favoriteIds = [];
  bool _isLoading = false;
  String? _error;

  List<String> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Carrega favoritos
  Future<void> loadFavorites() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _favoriteIds = await _repository.loadFavorites();
      _error = null;
    } catch (e) {
      _error = 'Erro ao carregar favoritos: $e';
      _favoriteIds = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adiciona receita aos favoritos
  Future<void> addToFavorites(String recipeId) async {
    try {
      await _repository.addToFavorites(recipeId);
      if (!_favoriteIds.contains(recipeId)) {
        _favoriteIds.add(recipeId);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Erro ao adicionar favorito: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Remove receita dos favoritos
  Future<void> removeFromFavorites(String recipeId) async {
    try {
      await _repository.removeFromFavorites(recipeId);
      _favoriteIds.remove(recipeId);
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao remover favorito: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Alterna favorito (adiciona se não estiver, remove se estiver)
  Future<void> toggleFavorite(String recipeId) async {
    if (_favoriteIds.contains(recipeId)) {
      await removeFromFavorites(recipeId);
    } else {
      await addToFavorites(recipeId);
    }
  }

  /// Verifica se uma receita está nos favoritos
  bool isFavorite(String recipeId) {
    return _favoriteIds.contains(recipeId);
  }

  /// Limpa o erro
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

