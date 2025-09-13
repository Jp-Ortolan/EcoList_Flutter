class AppConfig {
  // Configurações de performance
  static const int maxRandomRecipes = 4;
  static const int maxCategoryRecipes = 10;
  static const int maxSearchResults = 8;
  static const int categoryCacheHours = 1;
  
  // Timeouts para requisições HTTP
  static const Duration httpTimeout = Duration(seconds: 10);
  
  // Configurações de cache
  static const int maxCacheSize = 100;
  
  // Configurações de UI
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration staggeredAnimationDuration = Duration(milliseconds: 600);
}
