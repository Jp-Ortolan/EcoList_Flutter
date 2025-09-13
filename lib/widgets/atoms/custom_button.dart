import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive_helper.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48,
    this.borderRadius,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: text,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 12)),
          color: backgroundColor ?? AppTheme.primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: ResponsiveHelper.getElevation(context, 8),
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: borderRadius ?? BorderRadius.circular(ResponsiveHelper.getBorderRadius(context, 12)),
            onTap: isLoading ? null : onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            Icon(
                              icon,
                              color: textColor ?? Colors.white,
                              size: ResponsiveHelper.getIconSize(context, 20),
                            ),
                            SizedBox(width: ResponsiveHelper.getSpacing(context) / 2),
                          ],
                          Text(
                            text,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: textColor ?? Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
