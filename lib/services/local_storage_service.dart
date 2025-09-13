import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _favoritesKey = 'favorite_recipes';

  // Salvar favoritos
  static Future<void> saveFavorites(List<String> favoriteIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, favoriteIds);
  }

  // Carregar favoritos
  static Future<List<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  // Adicionar aos favoritos
  static Future<void> addToFavorites(String recipeId) async {
    final favorites = await loadFavorites();
    if (!favorites.contains(recipeId)) {
      favorites.add(recipeId);
      await saveFavorites(favorites);
    }
  }

  // Remover dos favoritos
  static Future<void> removeFromFavorites(String recipeId) async {
    final favorites = await loadFavorites();
    favorites.remove(recipeId);
    await saveFavorites(favorites);
  }

  // Verificar se é favorito
  static Future<bool> isFavorite(String recipeId) async {
    final favorites = await loadFavorites();
    return favorites.contains(recipeId);
  }
}
