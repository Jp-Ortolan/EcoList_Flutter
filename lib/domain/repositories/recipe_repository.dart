import '../../models/recipe.dart';

/// Interface do repositório de receitas (Domain Layer)
/// Define os contratos que devem ser implementados pela camada de dados
abstract class RecipeRepository {
  /// Busca receitas por categoria
  Future<List<Recipe>> getRecipesByCategory(String category);

  /// Busca receita por ID
  Future<Recipe?> getRecipeById(String id);

  /// Busca receitas aleatórias
  Future<List<Recipe>> getRandomRecipes(int count);

  /// Busca categorias disponíveis
  Future<List<String>> getCategories();

  /// Busca receitas por nome
  Future<List<Recipe>> searchRecipes(String query);
}

