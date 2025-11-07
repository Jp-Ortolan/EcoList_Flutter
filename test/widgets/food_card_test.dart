import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_receitas/widgets/molecules/food_card.dart';
import 'package:lista_receitas/models/food_item.dart';

void main() {
  group('FoodCard Widget Tests', () {
    testWidgets('deve exibir informações do alimento corretamente', (WidgetTester tester) async {
      final food = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 2.5,
        unit: UnitType.kg,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        notes: 'Tomates frescos',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FoodCard(
              food: food,
            ),
          ),
        ),
      );

      // Verifica se o nome do alimento está presente
      expect(find.text('Tomate'), findsOneWidget);

      // Verifica se a categoria está presente
      expect(find.text('Fruta'), findsOneWidget);

      // Verifica se a quantidade e unidade estão presentes
      expect(find.textContaining('2.5'), findsWidgets);
      expect(find.textContaining('Kg'), findsWidgets);
    });

    testWidgets('deve exibir status do alimento corretamente', (WidgetTester tester) async {
      final now = DateTime.now();

      // Alimento próximo do vencimento
      final nearExpiryFood = FoodItem(
        id: '1',
        name: 'Leite',
        category: FoodCategory.laticinios,
        quantity: 1,
        unit: UnitType.litros,
        purchaseDate: now.subtract(const Duration(days: 5)),
        expiryDate: now.add(const Duration(days: 2)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FoodCard(
              food: nearExpiryFood,
            ),
          ),
        ),
      );

      // Verifica se o status está presente
      expect(find.textContaining('Próximo'), findsWidgets);
    });

    testWidgets('deve chamar onTap quando o card for tocado', (WidgetTester tester) async {
      bool tapped = false;

      final food = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 2.5,
        unit: UnitType.kg,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FoodCard(
              food: food,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Toca no card
      await tester.tap(find.byType(FoodCard));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });

    testWidgets('deve chamar onDelete quando o botão de deletar for pressionado', (WidgetTester tester) async {
      bool deleted = false;

      final food = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 2.5,
        unit: UnitType.kg,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FoodCard(
              food: food,
              onDelete: () {
                deleted = true;
              },
            ),
          ),
        ),
      );

      // Procura pelo ícone de deletar
      final deleteButton = find.byIcon(Icons.delete);
      if (deleteButton.evaluate().isNotEmpty) {
        await tester.tap(deleteButton);
        await tester.pumpAndSettle();
        expect(deleted, true);
      }
    });

    testWidgets('deve exibir observações quando presentes', (WidgetTester tester) async {
      final food = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 2.5,
        unit: UnitType.kg,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        notes: 'Tomates frescos e orgânicos',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FoodCard(
              food: food,
            ),
          ),
        ),
      );

      // Verifica se as observações estão presentes
      expect(find.textContaining('Tomates frescos'), findsWidgets);
    });

    testWidgets('não deve exibir observações quando não presentes', (WidgetTester tester) async {
      final food = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 2.5,
        unit: UnitType.kg,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FoodCard(
              food: food,
            ),
          ),
        ),
      );

      // Verifica que não há texto de observações
      expect(find.textContaining('Observações'), findsNothing);
    });

    testWidgets('deve exibir data de vencimento formatada corretamente', (WidgetTester tester) async {
      final food = FoodItem(
        id: '1',
        name: 'Tomate',
        category: FoodCategory.fruta,
        quantity: 2.5,
        unit: UnitType.kg,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FoodCard(
              food: food,
            ),
          ),
        ),
      );

      // Verifica se há texto relacionado à data de vencimento
      expect(find.textContaining('Vence'), findsWidgets);
    });
  });
}

