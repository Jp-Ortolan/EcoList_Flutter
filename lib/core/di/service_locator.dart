import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../data/datasources/food_local_datasource.dart';
import '../../data/datasources/recipe_remote_datasource.dart';
import '../../data/datasources/favorite_local_datasource.dart';
import '../../data/repositories/food_repository_impl.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../data/repositories/favorite_repository_impl.dart';
import '../../domain/repositories/food_repository.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../../presentation/providers/food_provider.dart';
import '../../presentation/providers/recipe_provider.dart';
import '../../presentation/providers/favorite_provider.dart';

/// Service Locator para injeção de dependências
/// Configura todas as dependências seguindo Clean Architecture
class ServiceLocator {
  /// Configura todos os providers necessários
  static List<ChangeNotifierProvider<ChangeNotifier>> getProviders() {
    // Data Sources
    final foodDataSource = FoodLocalDataSource();
    final recipeDataSource = RecipeRemoteDataSource();
    final favoriteDataSource = FavoriteLocalDataSource();

    // Repositories
    final foodRepository = FoodRepositoryImpl(foodDataSource);
    final recipeRepository = RecipeRepositoryImpl(recipeDataSource);
    final favoriteRepository = FavoriteRepositoryImpl(favoriteDataSource);

    // Providers
    return [
      ChangeNotifierProvider<FoodProvider>(
        create: (_) => FoodProvider(foodRepository),
      ),
      ChangeNotifierProvider<RecipeProvider>(
        create: (_) => RecipeProvider(recipeRepository),
      ),
      ChangeNotifierProvider<FavoriteProvider>(
        create: (_) => FavoriteProvider(favoriteRepository),
      ),
    ];
  }
}

