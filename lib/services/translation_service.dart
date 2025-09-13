class TranslationService {
  static const Map<String, String> _categoryTranslations = {
    'Beef': 'Carne Bovina',
    'Chicken': 'Frango',
    'Lamb': 'Cordeiro',
    'Pasta': 'Massas',
    'Pork': 'Porco',
    'Seafood': 'Frutos do Mar',
    'Vegetarian': 'Vegetariano',
    'Vegan': 'Vegano',
    'Breakfast': 'Café da Manhã',
    'Dessert': 'Sobremesa',
    'Miscellaneous': 'Diversos',
    'Goat': 'Cabra',
    'Starter': 'Entrada',
    'Side': 'Acompanhamento',
    'Soup': 'Sopa',
    'Salad': 'Salada',
    'Sandwich': 'Sanduíche',
    'Snack': 'Lanche',
    'Drink': 'Bebida',
  };

  static const Map<String, String> _areaTranslations = {
    'American': 'Americana',
    'British': 'Britânica',
    'Chinese': 'Chinesa',
    'French': 'Francesa',
    'Indian': 'Indiana',
    'Italian': 'Italiana',
    'Japanese': 'Japonesa',
    'Mexican': 'Mexicana',
    'Spanish': 'Espanhola',
    'Thai': 'Tailandesa',
    'Turkish': 'Turca',
    'Unknown': 'Desconhecida',
  };

  static String translateCategory(String? category) {
    if (category == null) return 'Diversos';
    return _categoryTranslations[category] ?? category;
  }

  static String translateArea(String? area) {
    if (area == null) return 'Internacional';
    return _areaTranslations[area] ?? area;
  }

  static String translateInstructions(String instructions) {
    // Traduzir algumas palavras comuns nas instruções
    String translated = instructions;
    
    final translations = {
      // Verbos de cozinha
      'Preheat': 'Pré-aqueça',
      'Heat': 'Aqueça',
      'Add': 'Adicione',
      'Mix': 'Misture',
      'Stir': 'Mexa',
      'Cook': 'Cozinhe',
      'Bake': 'Asse',
      'Fry': 'Frite',
      'Boil': 'Ferva',
      'Simmer': 'Cozinhe em fogo baixo',
      'Roast': 'Asse',
      'Grill': 'Grelhe',
      'Steam': 'Cozinhe no vapor',
      'Blend': 'Bata no liquidificador',
      'Chop': 'Pique',
      'Slice': 'Corte',
      'Dice': 'Corte em cubos',
      'Grate': 'Rale',
      'Season': 'Tempere',
      'Serve': 'Sirva',
      'Garnish': 'Decore',
      
      // Temperaturas e tempos
      'oven': 'forno',
      'degrees': 'graus',
      'minutes': 'minutos',
      'seconds': 'segundos',
      'hours': 'horas',
      'medium heat': 'fogo médio',
      'high heat': 'fogo alto',
      'low heat': 'fogo baixo',
      
      // Ingredientes comuns
      'Salt': 'Sal',
      'Pepper': 'Pimenta',
      'Oil': 'Óleo',
      'Butter': 'Manteiga',
      'Flour': 'Farinha',
      'Sugar': 'Açúcar',
      'Eggs': 'Ovos',
      'Milk': 'Leite',
      'Water': 'Água',
      'Garlic': 'Alho',
      'Onion': 'Cebola',
      'Tomato': 'Tomate',
      'Cheese': 'Queijo',
      'Meat': 'Carne',
      'Chicken': 'Frango',
      'Fish': 'Peixe',
      'Rice': 'Arroz',
      'Pasta': 'Massa',
      'Bread': 'Pão',
      'Vegetables': 'Legumes',
      'Fruits': 'Frutas',
      'Potato': 'Batata',
      'Carrot': 'Cenoura',
      'Lettuce': 'Alface',
      'Cucumber': 'Pepino',
      'Lemon': 'Limão',
      'Orange': 'Laranja',
      'Apple': 'Maçã',
      'Banana': 'Banana',
      
      // Utensílios
      'pan': 'frigideira',
      'pot': 'panela',
      'bowl': 'tigela',
      'plate': 'prato',
      'spoon': 'colher',
      'fork': 'garfo',
      'knife': 'faca',
      'cutting board': 'tábua de corte',
    };

    for (final entry in translations.entries) {
      translated = translated.replaceAll(entry.key, entry.value);
    }

    return translated;
  }

  // Traduzir nomes de receitas comuns
  static String translateRecipeName(String recipeName) {
    final translations = {
      'Chicken': 'Frango',
      'Beef': 'Carne Bovina',
      'Pork': 'Porco',
      'Fish': 'Peixe',
      'Rice': 'Arroz',
      'Pasta': 'Massa',
      'Soup': 'Sopa',
      'Salad': 'Salada',
      'Sandwich': 'Sanduíche',
      'Pizza': 'Pizza',
      'Cake': 'Bolo',
      'Bread': 'Pão',
      'Eggs': 'Ovos',
      'Potato': 'Batata',
      'Tomato': 'Tomate',
      'Onion': 'Cebola',
      'Garlic': 'Alho',
      'Cheese': 'Queijo',
      'Milk': 'Leite',
      'Butter': 'Manteiga',
      'Oil': 'Óleo',
      'Salt': 'Sal',
      'Pepper': 'Pimenta',
      'Sugar': 'Açúcar',
      'Flour': 'Farinha',
    };

    String translated = recipeName;
    for (final entry in translations.entries) {
      translated = translated.replaceAll(entry.key, entry.value);
    }

    return translated;
  }
}
