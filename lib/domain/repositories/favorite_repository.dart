/// Interface do repositório de favoritos (Domain Layer)
abstract class FavoriteRepository {
  /// Carrega lista de IDs de receitas favoritas
  Future<List<String>> loadFavorites();

  /// Adiciona receita aos favoritos
  Future<void> addToFavorites(String recipeId);

  /// Remove receita dos favoritos
  Future<void> removeFromFavorites(String recipeId);

  /// Verifica se uma receita está nos favoritos
  Future<bool> isFavorite(String recipeId);
}

