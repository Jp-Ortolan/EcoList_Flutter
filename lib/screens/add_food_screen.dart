import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../presentation/providers/food_provider.dart';
import '../widgets/atoms/custom_text_field.dart';
import '../widgets/atoms/custom_button.dart';
import '../utils/responsive_helper.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  
  FoodCategory _selectedCategory = FoodCategory.outros;
  UnitType _selectedUnit = UnitType.unidade;
  DateTime _purchaseDate = DateTime.now();
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 7));
  
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveFood() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final food = FoodItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        category: _selectedCategory,
        quantity: double.parse(_quantityController.text),
        unit: _selectedUnit,
        purchaseDate: _purchaseDate,
        expiryDate: _expiryDate,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      await context.read<FoodProvider>().addFood(food);

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alimento adicionado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao adicionar alimento: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoList'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: ResponsiveHelper.getPadding(context),
          children: [
            // Nome do alimento
            CustomTextField(
              label: 'Nome do Alimento *',
              hint: 'Ex: Tomate, Frango, Leite',
              controller: _nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'O nome é obrigatório';
                }
                if (value.trim().length < 2) {
                  return 'O nome deve ter pelo menos 2 caracteres';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context)),

            // Categoria
            _buildCategorySelector(),
            SizedBox(height: ResponsiveHelper.getSpacing(context)),

            // Quantidade
            CustomTextField(
              label: 'Quantidade *',
              hint: 'Ex: 1, 2.5, 10',
              controller: _quantityController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'A quantidade é obrigatória';
                }
                final quantity = double.tryParse(value);
                if (quantity == null || quantity <= 0) {
                  return 'Digite uma quantidade válida';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context)),

            // Unidade
            _buildUnitSelector(),
            SizedBox(height: ResponsiveHelper.getSpacing(context)),

            // Data de compra
            _buildDateSelector(
              label: 'Data de Compra',
              date: _purchaseDate,
              onDateChanged: (date) {
                setState(() {
                  _purchaseDate = date;
                });
              },
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context)),

            // Data de vencimento
            _buildDateSelector(
              label: 'Data de Vencimento',
              date: _expiryDate,
              onDateChanged: (date) {
                setState(() {
                  _expiryDate = date;
                });
              },
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context)),

            // Observações
            CustomTextField(
              label: 'Observações',
              hint: 'Informações adicionais (opcional)',
              controller: _notesController,
              maxLines: 3,
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context) * 2),

            // Botão salvar
            CustomButton(
              text: 'Adicionar Alimento',
              onPressed: _saveFood,
              isLoading: _isLoading,
              icon: Icons.add,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categoria *',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context) / 2),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context) / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 8)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<FoodCategory>(
              value: _selectedCategory,
              isExpanded: true,
              items: FoodCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Icon(_getCategoryIcon(category), size: 20),
                      SizedBox(width: ResponsiveHelper.getSpacing(context) / 2),
                      Text(_getCategoryName(category)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnitSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unidade *',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context) / 2),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context) / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 8)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<UnitType>(
              value: _selectedUnit,
              isExpanded: true,
              items: UnitType.values.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(_getUnitName(unit)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedUnit = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime date,
    required Function(DateTime) onDateChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context) / 2),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (selectedDate != null) {
              onDateChanged(selectedDate);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSpacing(context) / 2,
              vertical: ResponsiveHelper.getSpacing(context) / 2,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 8)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20),
                SizedBox(width: ResponsiveHelper.getSpacing(context) / 2),
                Text(
                  '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(FoodCategory category) {
    switch (category) {
      case FoodCategory.carne:
        return Icons.restaurant;
      case FoodCategory.verdura:
        return Icons.eco;
      case FoodCategory.fruta:
        return Icons.apple;
      case FoodCategory.laticinios:
        return Icons.local_drink;
      case FoodCategory.graos:
        return Icons.grain;
      case FoodCategory.temperos:
        return Icons.spa;
      case FoodCategory.bebidas:
        return Icons.local_bar;
      case FoodCategory.outros:
        return Icons.category;
    }
  }

  String _getCategoryName(FoodCategory category) {
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

  String _getUnitName(UnitType unit) {
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
}