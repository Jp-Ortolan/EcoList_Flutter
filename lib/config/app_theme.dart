import 'package:flutter/material.dart';

class AppTheme {
  // Cores principais
  static const Color primaryColor = Color(0xFF2E7D32); // Verde escuro
  static const Color primaryLightColor = Color(0xFF4CAF50); // Verde claro
  static const Color primaryDarkColor = Color(0xFF1B5E20); // Verde mais escuro
  
  // Cores de status
  static const Color successColor = Color(0xFF4CAF50); // Verde
  static const Color warningColor = Color(0xFFFF9800); // Laranja
  static const Color errorColor = Color(0xFFF44336); // Vermelho
  static const Color infoColor = Color(0xFF2196F3); // Azul
  
  // Cores neutras
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  
  // Cores de texto
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textHintColor = Color(0xFFBDBDBD);
  
  // Cores de borda
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color dividerColor = Color(0xFFE0E0E0);
  
  // Cores de status para alimentos
  static const Color freshColor = Color(0xFF4CAF50); // Verde
  static const Color nearExpiryColor = Color(0xFFFF9800); // Laranja
  static const Color expiredColor = Color(0xFFF44336); // Vermelho
  
  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryLightColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Colors.white, Color(0xFFFAFAFA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Tema principal
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Cores principais
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        primaryContainer: primaryLightColor,
        secondary: primaryLightColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryColor,
        onBackground: textPrimaryColor,
        onError: Colors.white,
      ),
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      // Textos
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimaryColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textPrimaryColor,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textSecondaryColor,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondaryColor,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textHintColor,
        ),
      ),
      
      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Bottom navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
  
  // Cores de status para alimentos
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'fresco':
        return freshColor;
      case 'próximo do vencimento':
        return nearExpiryColor;
      case 'vencido':
        return expiredColor;
      default:
        return textSecondaryColor;
    }
  }
  
  // Ícones para categorias de alimentos
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'carne':
        return Icons.restaurant;
      case 'verdura':
        return Icons.eco;
      case 'fruta':
        return Icons.apple;
      case 'laticínios':
        return Icons.local_drink;
      case 'grãos':
        return Icons.grain;
      case 'temperos':
        return Icons.spa;
      case 'bebidas':
        return Icons.local_bar;
      default:
        return Icons.category;
    }
  }
  
  // Ícones para categorias de receitas
  static IconData getRecipeCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'carne bovina':
        return Icons.restaurant;
      case 'frango':
        return Icons.restaurant;
      case 'massas':
        return Icons.restaurant_menu;
      case 'vegetariano':
        return Icons.eco;
      case 'vegano':
        return Icons.eco;
      case 'café da manhã':
        return Icons.free_breakfast;
      case 'sobremesa':
        return Icons.cake;
      case 'entrada':
        return Icons.restaurant_menu;
      default:
        return Icons.restaurant;
    }
  }
}
