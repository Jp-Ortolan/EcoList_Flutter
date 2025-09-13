import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop, largeDesktop }

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 && 
           MediaQuery.of(context).size.width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Retorna o número de colunas baseado no tamanho da tela
  static int getCrossAxisCount(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }

  // Retorna o espaçamento baseado no tamanho da tela
  static double getSpacing(BuildContext context) {
    if (isMobile(context)) return 8.0;
    if (isTablet(context)) return 12.0;
    return 16.0;
  }

  // Retorna o padding baseado no tamanho da tela
  static EdgeInsets getPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(12.0);
    if (isTablet(context)) return const EdgeInsets.all(16.0);
    return const EdgeInsets.all(20.0);
  }

  // Retorna o tamanho da fonte baseado no tamanho da tela
  static double getFontSize(BuildContext context, double baseFontSize) {
    if (isMobile(context)) return baseFontSize;
    if (isTablet(context)) return baseFontSize * 1.1;
    return baseFontSize * 1.2;
  }

  // Retorna a largura do card baseada no tamanho da tela
  static double getCardWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (isMobile(context)) return screenWidth * 0.8;
    if (isTablet(context)) return screenWidth * 0.4;
    return screenWidth * 0.3;
  }

  // Retorna a altura do card baseada no tamanho da tela
  static double getCardHeight(BuildContext context) {
    if (isMobile(context)) return 280;
    if (isTablet(context)) return 320;
    return 360;
  }

  // Retorna o número de itens por linha baseado no tamanho da tela
  static int getItemsPerRow(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }

  // Obter tipo de dispositivo
  static DeviceType getDeviceType(BuildContext context) {
    if (isMobile(context)) return DeviceType.mobile;
    if (isTablet(context)) return DeviceType.tablet;
    if (isDesktop(context)) return DeviceType.desktop;
    return DeviceType.largeDesktop;
  }

  // Retorna o espaçamento vertical baseado no tamanho da tela
  static double getVerticalSpacing(BuildContext context) {
    if (isMobile(context)) return 8.0;
    if (isTablet(context)) return 12.0;
    return 16.0;
  }

  // Retorna o espaçamento horizontal baseado no tamanho da tela
  static double getHorizontalSpacing(BuildContext context) {
    if (isMobile(context)) return 12.0;
    if (isTablet(context)) return 16.0;
    return 20.0;
  }

  // Retorna o padding específico para cards
  static EdgeInsets getCardPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(12.0);
    if (isTablet(context)) return const EdgeInsets.all(16.0);
    return const EdgeInsets.all(20.0);
  }

  // Retorna o padding específico para telas
  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(16.0);
    if (isTablet(context)) return const EdgeInsets.all(24.0);
    return const EdgeInsets.all(32.0);
  }

  // Retorna o tamanho do ícone baseado no tamanho da tela
  static double getIconSize(BuildContext context, double baseSize) {
    if (isMobile(context)) return baseSize;
    if (isTablet(context)) return baseSize * 1.2;
    return baseSize * 1.4;
  }

  // Retorna o border radius baseado no tamanho da tela
  static double getBorderRadius(BuildContext context, double baseRadius) {
    if (isMobile(context)) return baseRadius;
    if (isTablet(context)) return baseRadius * 1.2;
    return baseRadius * 1.4;
  }

  // Retorna a elevação baseada no tamanho da tela
  static double getElevation(BuildContext context, double baseElevation) {
    if (isMobile(context)) return baseElevation;
    if (isTablet(context)) return baseElevation * 1.2;
    return baseElevation * 1.4;
  }

  // Retorna o aspect ratio para imagens baseado no tamanho da tela
  static double getImageAspectRatio(BuildContext context) {
    if (isMobile(context)) return 16 / 9;
    if (isTablet(context)) return 4 / 3;
    return 3 / 2;
  }

  // Retorna o número máximo de caracteres por linha baseado no tamanho da tela
  static int getMaxCharactersPerLine(BuildContext context) {
    if (isMobile(context)) return 30;
    if (isTablet(context)) return 40;
    return 50;
  }

  // Retorna o número de linhas máximo para textos baseado no tamanho da tela
  static int getMaxLines(BuildContext context, int baseLines) {
    if (isMobile(context)) return baseLines;
    if (isTablet(context)) return baseLines + 1;
    return baseLines + 2;
  }
}
