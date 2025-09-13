import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../utils/responsive_helper.dart';
import '../../config/app_theme.dart';

class ResponsiveRecipeCard extends StatelessWidget {
  final String title;
  final String? description;
  final String? imageUrl;
  final String? category;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool isLoading;

  const ResponsiveRecipeCard({
    super.key,
    required this.title,
    this.description,
    this.imageUrl,
    this.category,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteToggle,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Receita: $title',
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
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 16)),
            onTap: isLoading ? null : onTap,
            child: Container(
              padding: ResponsiveHelper.getCardPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagem da receita
                  ClipRRect(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 12)),
                    child: AspectRatio(
                      aspectRatio: ResponsiveHelper.getImageAspectRatio(context),
                      child: imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: AppTheme.backgroundColor,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppTheme.backgroundColor,
                                child: Icon(
                                  Icons.restaurant,
                                  size: ResponsiveHelper.getIconSize(context, 48),
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            )
                          : Container(
                              color: AppTheme.backgroundColor,
                              child: Icon(
                                Icons.restaurant,
                                size: ResponsiveHelper.getIconSize(context, 48),
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.getVerticalSpacing(context)),
                  
                  // Informações da receita
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                              maxLines: ResponsiveHelper.getMaxLines(context, 2),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (description != null) ...[
                              SizedBox(height: ResponsiveHelper.getVerticalSpacing(context) / 2),
                              Text(
                                description!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textSecondaryColor,
                                ),
                                maxLines: ResponsiveHelper.getMaxLines(context, 1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            if (category != null) ...[
                              SizedBox(height: ResponsiveHelper.getVerticalSpacing(context) / 2),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveHelper.getSpacing(context) / 2,
                                  vertical: ResponsiveHelper.getSpacing(context) / 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 8)),
                                  border: Border.all(
                                    color: AppTheme.primaryColor.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      AppTheme.getRecipeCategoryIcon(category!),
                                      size: ResponsiveHelper.getIconSize(context, 12),
                                      color: AppTheme.primaryColor,
                                    ),
                                    SizedBox(width: ResponsiveHelper.getSpacing(context) / 4),
                                    Text(
                                      category!,
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.getSpacing(context) / 2),
                      // Botão de favorito
                      Transform.scale(
                        scale: isFavorite ? 1.1 : 1.0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isFavorite 
                                ? AppTheme.errorColor.withOpacity(0.1)
                                : AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 8)),
                            border: Border.all(
                              color: isFavorite 
                                  ? AppTheme.errorColor.withOpacity(0.3)
                                  : AppTheme.borderColor,
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? AppTheme.errorColor : AppTheme.textSecondaryColor,
                              size: ResponsiveHelper.getIconSize(context, 20),
                            ),
                            onPressed: onFavoriteToggle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
