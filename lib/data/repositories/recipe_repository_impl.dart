import '../../domain/repositories/recipe_repository.dart';
import '../../models/recipe.dart';
import '../datasources/recipe_remote_datasource.dart';

/// Implementação do repositório de receitas (Data Layer)
class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource _dataSource;

  RecipeRepositoryImpl(this._dataSource);

  @override
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    return await _dataSource.getRecipesByCategory(category);
  }

  @override
  Future<Recipe?> getRecipeById(String id) async {
    return await _dataSource.getRecipeById(id);
  }

  @override
  Future<List<Recipe>> getRandomRecipes(int count) async {
    return await _dataSource.getRandomRecipes(count);
  }

  @override
  Future<List<String>> getCategories() async {
    return await _dataSource.getCategories();
  }

  @override
  Future<List<Recipe>> searchRecipes(String query) async {
    return await _dataSource.searchRecipes(query);
  }
}

