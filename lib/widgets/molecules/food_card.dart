import 'package:flutter/material.dart';
import '../../models/food_item.dart';
import '../../utils/responsive_helper.dart';
import '../../config/app_theme.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const FoodCard({
    super.key,
    required this.food,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return Semantics(
      button: true,
      label: 'Alimento: ${food.name}',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getSpacing(context) / 2,
          vertical: ResponsiveHelper.getSpacing(context) / 4,
        ),
        child: Card(
          elevation: ResponsiveHelper.getElevation(context, 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 16)),
            side: BorderSide(
              color: AppTheme.getStatusColor(food.statusText).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 16)),
            onTap: onTap,
            child: Container(
              padding: ResponsiveHelper.getCardPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header com status e ações
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                              maxLines: ResponsiveHelper.getMaxLines(context, 2),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              food.categoryName,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Status indicator
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.getSpacing(context) / 2,
                          vertical: ResponsiveHelper.getSpacing(context) / 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.getStatusColor(food.statusText).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 12)),
                          border: Border.all(
                            color: AppTheme.getStatusColor(food.statusText).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getStatusIcon(food.statusText),
                              size: ResponsiveHelper.getIconSize(context, 12),
                              color: AppTheme.getStatusColor(food.statusText),
                            ),
                            SizedBox(width: ResponsiveHelper.getSpacing(context) / 4),
                            Text(
                              food.statusText,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppTheme.getStatusColor(food.statusText),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: ResponsiveHelper.getVerticalSpacing(context)),
                  
                  // Informações do alimento
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context) / 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 10)),
                          border: Border.all(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          AppTheme.getCategoryIcon(food.categoryName),
                          size: ResponsiveHelper.getIconSize(context, 22),
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.getSpacing(context)),
                      Expanded(
                        child: Text(
                          '${food.quantity} ${food.unitName}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: ResponsiveHelper.getVerticalSpacing(context) / 2),
                  
                  // Data de vencimento
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.textSecondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.schedule,
                          size: ResponsiveHelper.getIconSize(context, 16),
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.getSpacing(context) / 2),
                      Expanded(
                        child: Text(
                          'Vence: ${_formatDate(food.expiryDate)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  if (food.notes != null && food.notes!.isNotEmpty) ...[
                    SizedBox(height: ResponsiveHelper.getVerticalSpacing(context) / 2),
                    Container(
                      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context) / 2),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 8)),
                        border: Border.all(
                          color: AppTheme.borderColor.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: AppTheme.textSecondaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.note,
                              size: ResponsiveHelper.getIconSize(context, 14),
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.getSpacing(context) / 2),
                          Expanded(
                            child: Text(
                              food.notes!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondaryColor,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: ResponsiveHelper.getMaxLines(context, 2),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  // Ações (se não for mobile, mostrar sempre)
                  if (!isMobile) ...[
                    SizedBox(height: ResponsiveHelper.getVerticalSpacing(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (onEdit != null)
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.infoColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 8)),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: ResponsiveHelper.getIconSize(context, 18),
                                color: AppTheme.infoColor,
                              ),
                              onPressed: onEdit,
                            ),
                          ),
                        SizedBox(width: ResponsiveHelper.getSpacing(context) / 2),
                        if (onDelete != null)
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 8)),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: ResponsiveHelper.getIconSize(context, 18),
                                color: AppTheme.errorColor,
                              ),
                              onPressed: onDelete,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'fresco':
        return Icons.check_circle;
      case 'próximo do vencimento':
        return Icons.warning;
      case 'vencido':
        return Icons.error;
      default:
        return Icons.help;
    }
  }


  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return 'Hoje';
    } else if (difference == 1) {
      return 'Amanhã';
    } else if (difference == -1) {
      return 'Ontem';
    } else if (difference > 0) {
      return 'Em $difference dias';
    } else {
      return 'Há ${-difference} dias';
    }
  }
}
