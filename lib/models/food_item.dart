import 'package:flutter/material.dart';

enum FoodCategory {
  carne,
  verdura,
  fruta,
  laticinios,
  graos,
  temperos,
  bebidas,
  outros,
}

enum UnitType {
  unidade,
  kg,
  gramas,
  litros,
  ml,
  colherSopa,
  colherCha,
  xicara,
  lata,
  pacote,
}

class FoodItem {
  final String id;
  final String name;
  final FoodCategory category;
  final double quantity;
  final UnitType unit;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final String? notes;
  final String? imageUrl;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.purchaseDate,
    required this.expiryDate,
    this.notes,
    this.imageUrl,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: FoodCategory.values.firstWhere(
        (e) => e.toString() == 'FoodCategory.${json['category']}',
        orElse: () => FoodCategory.outros,
      ),
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: UnitType.values.firstWhere(
        (e) => e.toString() == 'UnitType.${json['unit']}',
        orElse: () => UnitType.unidade,
      ),
      purchaseDate: DateTime.parse(json['purchaseDate'] ?? DateTime.now().toIso8601String()),
      expiryDate: DateTime.parse(json['expiryDate'] ?? DateTime.now().add(const Duration(days: 7)).toIso8601String()),
      notes: json['notes'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.toString().split('.').last,
      'quantity': quantity,
      'unit': unit.toString().split('.').last,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'notes': notes,
      'imageUrl': imageUrl,
    };
  }

  FoodItem copyWith({
    String? id,
    String? name,
    FoodCategory? category,
    double? quantity,
    UnitType? unit,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    String? notes,
    String? imageUrl,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Verificar se está próximo do vencimento (3 dias)
  bool get isNearExpiryCheck {
    final now = DateTime.now();
    final daysUntilExpiry = expiryDate.difference(now).inDays;
    return daysUntilExpiry <= 3 && daysUntilExpiry >= 0;
  }

  // Verificar se está vencido
  bool get isExpiredCheck {
    return DateTime.now().isAfter(expiryDate);
  }

  // Obter categoria em português
  String get categoryName {
    switch (category) {
      case FoodCategory.carne:
        return 'Carne';
      case FoodCategory.verdura:
        return 'Verdura';
      case FoodCategory.fruta:
        return 'Fruta';
      case FoodCategory.laticinios:
        return 'Laticínios';
      case FoodCategory.graos:
        return 'Grãos';
      case FoodCategory.temperos:
        return 'Temperos';
      case FoodCategory.bebidas:
        return 'Bebidas';
      case FoodCategory.outros:
        return 'Outros';
    }
  }

  // Obter unidade em português
  String get unitName {
    switch (unit) {
      case UnitType.unidade:
        return 'Unidade';
      case UnitType.kg:
        return 'Kg';
      case UnitType.gramas:
        return 'Gramas';
      case UnitType.litros:
        return 'Litros';
      case UnitType.ml:
        return 'Ml';
      case UnitType.colherSopa:
        return 'Colher de Sopa';
      case UnitType.colherCha:
        return 'Colher de Chá';
      case UnitType.xicara:
        return 'Xícara';
      case UnitType.lata:
        return 'Lata';
      case UnitType.pacote:
        return 'Pacote';
    }
  }

  // Obter status do alimento
  String get statusText {
    if (isExpiredCheck) return 'Vencido';
    if (isNearExpiryCheck) return 'Próximo do vencimento';
    return 'Fresco';
  }

  // Obter cor do status
  Color get statusColor {
    if (isExpiredCheck) return Colors.red;
    if (isNearExpiryCheck) return Colors.orange;
    return Colors.green;
  }
}
