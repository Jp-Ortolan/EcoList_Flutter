import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Data source local para favoritos (Data Layer)
class FavoriteLocalDataSource {
  static const String _favoritesKey = 'favorite_recipes';

  /// Carrega lista de IDs de receitas favoritas
  Future<List<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesString = prefs.getString(_favoritesKey);
    
    if (favoritesString == null) return [];
    
    try {
      final favoritesJson = jsonDecode(favoritesString) as List;
      return favoritesJson.map((id) => id as String).toList();
    } catch (e) {
      return [];
    }
  }

  /// Salva lista de IDs de receitas favoritas
  Future<void> saveFavorites(List<String> favoriteIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favoritesKey, jsonEncode(favoriteIds));
  }

  /// Adiciona receita aos favoritos
  Future<void> addToFavorites(String recipeId) async {
    final favorites = await loadFavorites();
    if (!favorites.contains(recipeId)) {
      favorites.add(recipeId);
      await saveFavorites(favorites);
    }
  }

  /// Remove receita dos favoritos
  Future<void> removeFromFavorites(String recipeId) async {
    final favorites = await loadFavorites();
    favorites.remove(recipeId);
    await saveFavorites(favorites);
  }

  /// Verifica se uma receita está nos favoritos
  Future<bool> isFavorite(String recipeId) async {
    final favorites = await loadFavorites();
    return favorites.contains(recipeId);
  }
}

