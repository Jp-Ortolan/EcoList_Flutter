import 'package:flutter_test/flutter_test.dart';
import 'package:lista_receitas/models/food_item.dart';

void main() {
  group('FoodItem Model Tests', () {
    test('deve criar um FoodItem corretamente', () {
      final food = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 2.5,
        unit: UnitType.kg,
        purchaseDate: DateTime(2024, 1, 1),
        expiryDate: DateTime(2024, 1, 8),
        notes: 'Tomates frescos',
      );

      expect(food.id, '1');
      expect(food.name, 'Tomate');
      expect(food.category, FoodCategory.fruta);
      expect(food.quantity, 2.5);
      expect(food.unit, UnitType.kg);
      expect(food.notes, 'Tomates frescos');
    });

    test('deve converter FoodItem para JSON corretamente', () {
      final food = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 2.5,
        unit: UnitType.kg,
        purchaseDate: DateTime(2024, 1, 1),
        expiryDate: DateTime(2024, 1, 8),
        notes: 'Tomates frescos',
      );

      final json = food.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Tomate');
      expect(json['category'], 'fruta');
      expect(json['quantity'], 2.5);
      expect(json['unit'], 'kg');
      expect(json['notes'], 'Tomates frescos');
    });

    test('deve criar FoodItem a partir de JSON corretamente', () {
      final json = {
        'id': '1',
        'name': 'Tomate',
        'category': 'fruta',
        'quantity': 2.5,
        'unit': 'kg',
        'purchaseDate': '2024-01-01T00:00:00.000',
        'expiryDate': '2024-01-08T00:00:00.000',
        'notes': 'Tomates frescos',
      };

      final food = FoodItem.fromJson(json);

      expect(food.id, '1');
      expect(food.name, 'Tomate');
      expect(food.category, FoodCategory.fruta);
      expect(food.quantity, 2.5);
      expect(food.unit, UnitType.kg);
      expect(food.notes, 'Tomates frescos');
    });

    test('deve verificar se alimento está próximo do vencimento corretamente', () {
      final now = DateTime.now();
      
      // Alimento que vence em 2 dias (próximo do vencimento)
      final nearExpiryFood = FoodItem(
        id: '1',
        name: 'Leite',
        category: FoodCategory.laticinios,
        quantity: 1,
        unit: UnitType.litros,
        purchaseDate: now.subtract(const Duration(days: 5)),
        expiryDate: now.add(const Duration(days: 2)),
      );

      expect(nearExpiryFood.isNearExpiryCheck, true);

      // Alimento que vence em 5 dias (não está próximo)
      final freshFood = FoodItem(
        id: '2',
        name: 'Arroz',
        category: FoodCategory.graos,
        quantity: 1,
        unit: UnitType.kg,
        purchaseDate: now.subtract(const Duration(days: 1)),
        expiryDate: now.add(const Duration(days: 5)),
      );

      expect(freshFood.isNearExpiryCheck, false);
    });

    test('deve verificar se alimento está vencido corretamente', () {
      final now = DateTime.now();

      // Alimento vencido
      final expiredFood = FoodItem(
        id: '1',
        name: 'Iogurte',
        category: FoodCategory.laticinios,
        quantity: 1,
        unit: UnitType.unidade,
        purchaseDate: now.subtract(const Duration(days: 10)),
        expiryDate: now.subtract(const Duration(days: 2)),
      );

      expect(expiredFood.isExpiredCheck, true);

      // Alimento não vencido
      final freshFood = FoodItem(
        id: '2',
        name: 'Arroz',
        category: FoodCategory.graos,
        quantity: 1,
        unit: UnitType.kg,
        purchaseDate: now.subtract(const Duration(days: 1)),
        expiryDate: now.add(const Duration(days: 5)),
      );

      expect(freshFood.isExpiredCheck, false);
    });

    test('deve retornar status correto do alimento', () {
      final now = DateTime.now();

      // Alimento vencido
      final expiredFood = FoodItem(
        id: '1',
        name: 'Iogurte',
        category: FoodCategory.laticinios,
        quantity: 1,
        unit: UnitType.unidade,
        purchaseDate: now.subtract(const Duration(days: 10)),
        expiryDate: now.subtract(const Duration(days: 2)),
      );

      expect(expiredFood.statusText, 'Vencido');

      // Alimento próximo do vencimento
      final nearExpiryFood = FoodItem(
        id: '2',
        name: 'Leite',
        category: FoodCategory.laticinios,
        quantity: 1,
        unit: UnitType.litros,
        purchaseDate: now.subtract(const Duration(days: 5)),
        expiryDate: now.add(const Duration(days: 2)),
      );

      expect(nearExpiryFood.statusText, 'Próximo do vencimento');

      // Alimento fresco
      final freshFood = FoodItem(
        id: '3',
        name: 'Arroz',
        category: FoodCategory.graos,
        quantity: 1,
        unit: UnitType.kg,
        purchaseDate: now.subtract(const Duration(days: 1)),
        expiryDate: now.add(const Duration(days: 10)),
      );

      expect(freshFood.statusText, 'Fresco');
    });

    test('deve retornar nome da categoria em português corretamente', () {
      final food = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 1,
        unit: UnitType.kg,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      );

      expect(food.categoryName, 'Fruta');
    });

    test('deve retornar nome da unidade em português corretamente', () {
      final food = FoodItem(
        id: '1',
        name: 'Leite',
        category: FoodCategory.laticinios,
        quantity: 1,
        unit: UnitType.litros,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      );

      expect(food.unitName, 'Litros');
    });

    test('deve criar cópia do FoodItem com copyWith corretamente', () {
      final original = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 2.5,
        unit: UnitType.kg,
        purchaseDate: DateTime(2024, 1, 1),
        expiryDate: DateTime(2024, 1, 8),
        notes: 'Tomates frescos',
      );

      final copy = original.copyWith(
        name: 'Tomate Orgânico',
        quantity: 3.0,
      );

      expect(copy.id, original.id);
      expect(copy.name, 'Tomate Orgânico');
      expect(copy.quantity, 3.0);
      expect(copy.category, original.category);
      expect(copy.unit, original.unit);
      expect(copy.notes, original.notes);
    });
  });
}

