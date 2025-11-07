import 'package:flutter_test/flutter_test.dart';
import 'package:lista_receitas/data/repositories/food_repository_impl.dart';
import 'package:lista_receitas/data/datasources/food_local_datasource.dart';
import 'package:lista_receitas/models/food_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('FoodRepositoryImpl Tests', () {
    late FoodRepositoryImpl repository;
    late FoodLocalDataSource dataSource;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      dataSource = FoodLocalDataSource();
      repository = FoodRepositoryImpl(dataSource);
    });

    test('deve adicionar alimento corretamente', () async {
      final food = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 2.5,
        unit: UnitType.kg,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      );

      await repository.addFood(food);
      final foods = await repository.loadFoods();

      expect(foods.length, 1);
      expect(foods.first.id, '1');
      expect(foods.first.name, 'Tomate');
    });

    test('deve carregar alimentos corretamente', () async {
      final food1 = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 2.5,
        unit: UnitType.kg,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      );

      final food2 = FoodItem(
        id: '2',
        name: 'Leite',
        category: FoodCategory.laticinios,
        quantity: 1,
        unit: UnitType.litros,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 5)),
      );

      await repository.addFood(food1);
      await repository.addFood(food2);
      final foods = await repository.loadFoods();

      expect(foods.length, 2);
    });

    test('deve atualizar alimento corretamente', () async {
      final food = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 2.5,
        unit: UnitType.kg,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      );

      await repository.addFood(food);

      final updatedFood = food.copyWith(name: 'Tomate Orgânico', quantity: 3.0);
      await repository.updateFood(updatedFood);

      final foods = await repository.loadFoods();
      expect(foods.length, 1);
      expect(foods.first.name, 'Tomate Orgânico');
      expect(foods.first.quantity, 3.0);
    });

    test('deve remover alimento corretamente', () async {
      final food1 = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 2.5,
        unit: UnitType.kg,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      );

      final food2 = FoodItem(
        id: '2',
        name: 'Leite',
        category: FoodCategory.laticinios,
        quantity: 1,
        unit: UnitType.litros,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 5)),
      );

      await repository.addFood(food1);
      await repository.addFood(food2);

      await repository.deleteFood('1');
      final foods = await repository.loadFoods();

      expect(foods.length, 1);
      expect(foods.first.id, '2');
    });

    test('deve filtrar alimentos por categoria corretamente', () async {
      final food1 = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 2.5,
        unit: UnitType.kg,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      );

      final food2 = FoodItem(
        id: '2',
        name: 'Leite',
        category: FoodCategory.laticinios,
        quantity: 1,
        unit: UnitType.litros,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 5)),
      );

      await repository.addFood(food1);
      await repository.addFood(food2);

      final fruits = await repository.getFoodsByCategory(FoodCategory.fruta);
      expect(fruits.length, 1);
      expect(fruits.first.category, FoodCategory.fruta);
    });

    test('deve buscar alimentos por nome corretamente', () async {
      final food1 = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 2.5,
        unit: UnitType.kg,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      );

      final food2 = FoodItem(
        id: '2',
        name: 'Tomate Cereja',
        category: FoodCategory.fruta,
        quantity: 1,
        unit: UnitType.kg,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 5)),
      );

      await repository.addFood(food1);
      await repository.addFood(food2);

      final results = await repository.searchFoods('Tomate');
      expect(results.length, 2);
    });

    test('deve obter alimentos próximos do vencimento corretamente', () async {
      final now = DateTime.now();

      final nearExpiryFood = FoodItem(
        id: '1',
        name: 'Leite',
        category: FoodCategory.laticinios,
        quantity: 1,
        unit: UnitType.litros,
        purchaseDate: now.subtract(const Duration(days: 5)),
        expiryDate: now.add(const Duration(days: 2)),
      );

      final freshFood = FoodItem(
        id: '2',
        name: 'Arroz',
        category: FoodCategory.graos,
        quantity: 1,
        unit: UnitType.kg,
        purchaseDate: now.subtract(const Duration(days: 1)),
        expiryDate: now.add(const Duration(days: 10)),
      );

      await repository.addFood(nearExpiryFood);
      await repository.addFood(freshFood);

      final nearExpiryFoods = await repository.getNearExpiryFoods();
      expect(nearExpiryFoods.length, 1);
      expect(nearExpiryFoods.first.id, '1');
    });

    test('deve obter estatísticas corretamente', () async {
      final now = DateTime.now();

      final nearExpiryFood = FoodItem(
        id: '1',
        name: 'Leite',
        category: FoodCategory.laticinios,
        quantity: 1,
        unit: UnitType.litros,
        purchaseDate: now.subtract(const Duration(days: 5)),
        expiryDate: now.add(const Duration(days: 2)),
      );

      final expiredFood = FoodItem(
        id: '2',
        name: 'Iogurte',
        category: FoodCategory.laticinios,
        quantity: 1,
        unit: UnitType.unidade,
        purchaseDate: now.subtract(const Duration(days: 10)),
        expiryDate: now.subtract(const Duration(days: 2)),
      );

      final freshFood = FoodItem(
        id: '3',
        name: 'Arroz',
        category: FoodCategory.graos,
        quantity: 1,
        unit: UnitType.kg,
        purchaseDate: now.subtract(const Duration(days: 1)),
        expiryDate: now.add(const Duration(days: 10)),
      );

      await repository.addFood(nearExpiryFood);
      await repository.addFood(expiredFood);
      await repository.addFood(freshFood);

      final stats = await repository.getStatistics();
      expect(stats['total'], 3);
      expect(stats['nearExpiry'], 1);
      expect(stats['expired'], 1);
      expect(stats['fresh'], 1);
    });
  });
}

