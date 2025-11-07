import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_local_datasource.dart';

/// Implementação do repositório de favoritos (Data Layer)
class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteLocalDataSource _dataSource;

  FavoriteRepositoryImpl(this._dataSource);

  @override
  Future<List<String>> loadFavorites() async {
    return await _dataSource.loadFavorites();
  }

  @override
  Future<void> addToFavorites(String recipeId) async {
    await _dataSource.addToFavorites(recipeId);
  }

  @override
  Future<void> removeFromFavorites(String recipeId) async {
    await _dataSource.removeFromFavorites(recipeId);
  }

  @override
  Future<bool> isFavorite(String recipeId) async {
    return await _dataSource.isFavorite(recipeId);
  }
}

