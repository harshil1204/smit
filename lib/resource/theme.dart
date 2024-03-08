import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

const kFontFamily = 'Outfit';
abstract class AppTheme {
  static ThemeData get theme => ThemeData(
    primaryColor: AppColor.primary,   //use
    primaryColorDark: AppColor.primary,
    primaryColorLight: AppColor.primary,
    cardTheme: cardTheme,
    dividerTheme: dividerTheme,
    fontFamily: kFontFamily,
    colorScheme:  ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColor.primary,  //header bg
      onPrimary: AppColor.white,  //header text
      secondary: AppColor.secondary,
      onSecondary: AppColor.white,
      background: AppColor.lightBoxBg.withOpacity(.3),  //use box bg
      onBackground: AppColor.darkBoxBgDrawer,  //drawer bg color
      surface: AppColor.greyLight,
      onSurface: AppColor.black,  // header body text color
      error: AppColor.red,
      onError: AppColor.white,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColor.primary,
      selectionColor: AppColor.primary.withOpacity(0.3),
      selectionHandleColor: AppColor.primary,
    ),
    elevatedButtonTheme: elevatedButtonTheme,
    outlinedButtonTheme: outlinedButtonThemeData,
    textButtonTheme: textButtonThemeData,
    scaffoldBackgroundColor: AppColor.background,
    shadowColor: AppColor.greyLight.withOpacity(0.5),
    dialogTheme: dialogTheme,
    bottomSheetTheme: bottomSheetTheme,
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(
        color: AppColor.black,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        fontFamily: kFontFamily,
      ),
      errorStyle: const TextStyle(
        color: AppColor.red,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        fontFamily: kFontFamily,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.primary),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.primary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.red),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.primary),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.red),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      fillColor: AppColor.black,
      filled: false,
    ),
    radioTheme: radioTheme,
    checkboxTheme: checkBoxTheme,
    bottomAppBarTheme: const BottomAppBarTheme(elevation: 0, color: AppColor.background),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      textStyle: const TextStyle(
        color: AppColor.textDark,
        fontSize: 14,
        fontFamily: kFontFamily,
        fontWeight: FontWeight.w600,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColor.primary,
      foregroundColor: AppColor.white,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColor.white,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      actionTextColor: AppColor.primary,
      elevation: 4,
      contentTextStyle: const TextStyle(
        color: AppColor.textDark,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: kFontFamily,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.primary,
      elevation: 0,
      titleSpacing: 8,
      centerTitle: true,
      shadowColor: AppColor.greyLight,
      iconTheme: IconThemeData(color: AppColor.white),
      foregroundColor: AppColor.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: AppColor.primary,
        statusBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: TextStyle(
        fontSize: 18,
        color: AppColor.white,
        fontWeight: FontWeight.w700,
        fontFamily: kFontFamily,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: AppColor.primary,
      unselectedLabelColor: AppColor.textLight,
      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: kFontFamily),
      unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: kFontFamily),
      indicatorColor: AppColor.primary
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColor.greyLight,
      disabledColor: AppColor.grey.withAlpha(150),
      selectedColor: AppColor.primary,
      secondarySelectedColor: AppColor.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: const TextStyle(
        fontFamily: kFontFamily,
        fontSize: 12,
        color: AppColor.textLight,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: const TextStyle(
        fontFamily: kFontFamily,
        fontSize: 12,
        color: AppColor.white,
        fontWeight: FontWeight.w500,
      ),
      brightness: Brightness.light,
    ),
    bottomNavigationBarTheme: bottomNavigationBarTheme,
    scrollbarTheme: const ScrollbarThemeData(
      radius: Radius.circular(8),
      crossAxisMargin: 2,
      mainAxisMargin: 4,
    ),
  );

  static ThemeData get darktheme => ThemeData(
    primaryColor: AppColor.white,
    primaryColorDark: AppColor.yellow,
    primaryColorLight: AppColor.primary,
    //cardTheme: darkcardTheme,
    //dividerTheme: darkdividerTheme,
    fontFamily: kFontFamily,
    colorScheme: ColorScheme.dark(
      brightness: Brightness.dark,
      primary: AppColor.primary,
      onPrimary: AppColor.white,   //text color
     // secondary: AppColor.darkbackground,
      onSecondary: AppColor.white,
      background: AppColor.darkBoxBg,
      onBackground: AppColor.lightBoxBg,  //drawer bg
      surface: AppColor.greyLight,
      onSurface: AppColor.textLight,
      error: AppColor.red,
      onError: AppColor.white,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColor.primary,
      selectionColor: AppColor.primary.withOpacity(0.3),
      selectionHandleColor: AppColor.primary,
    ),
    elevatedButtonTheme: elevatedButtonTheme,
    outlinedButtonTheme: outlinedButtonThemeData,
    textButtonTheme: textButtonThemeData,
    scaffoldBackgroundColor: AppColor.white,
    shadowColor: AppColor.greyLight.withOpacity(0.5),
    dialogTheme: dialogTheme,
    bottomSheetTheme: bottomSheetTheme,
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: AppColor.textLight.withOpacity(0.5),
        fontWeight: FontWeight.w500,
        fontSize: 14,
        fontFamily: kFontFamily,
      ),
      errorStyle: const TextStyle(
        color: AppColor.red,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        fontFamily: kFontFamily,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.greyLight),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.greyLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.greyLight),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.red),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.primary),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.red),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      fillColor: AppColor.white,
      filled: false,
    ),
    radioTheme: radioTheme,
    checkboxTheme: checkBoxTheme,
    bottomAppBarTheme: const BottomAppBarTheme(elevation: 0, color: AppColor.background),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      textStyle: const TextStyle(
        color: AppColor.textDark,
        fontSize: 14,
        fontFamily: kFontFamily,
        fontWeight: FontWeight.w600,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColor.primary,
      foregroundColor: AppColor.white,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColor.white,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      actionTextColor: AppColor.primary,
      elevation: 4,
      contentTextStyle: const TextStyle(
        color: AppColor.textDark,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: kFontFamily,
      ),
    ),
    appBarTheme:  const AppBarTheme(
      backgroundColor: AppColor.transparent,
      elevation: 0,
      titleSpacing: 8,
      centerTitle: true,
      shadowColor: AppColor.greyLight,
      iconTheme: IconThemeData(color: AppColor.primary),
      foregroundColor: AppColor.background,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
        fontSize: 18,
        color: AppColor.white,
        fontWeight: FontWeight.w700,
        fontFamily: kFontFamily,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: AppColor.primary,
      unselectedLabelColor: AppColor.textLight,
      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: kFontFamily),
      unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: kFontFamily),
        indicatorColor: AppColor.primary,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColor.greyLight,
      disabledColor: AppColor.grey.withAlpha(150),
      selectedColor: AppColor.primary,
      secondarySelectedColor: AppColor.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: const TextStyle(
        fontFamily: kFontFamily,
        fontSize: 12,
        color: AppColor.textLight,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: const TextStyle(
        fontFamily: kFontFamily,
        fontSize: 12,
        color: AppColor.white,
        fontWeight: FontWeight.w500,
      ),
      brightness: Brightness.light,
    ),
    bottomNavigationBarTheme: bottomNavigationBarTheme,
    scrollbarTheme: const ScrollbarThemeData(
      radius: Radius.circular(8),
      crossAxisMargin: 2,
      mainAxisMargin: 4,
    ),
  );

  static const BottomNavigationBarThemeData bottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: AppColor.white,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,fontFamily: kFontFamily),
    unselectedLabelStyle: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,fontFamily: kFontFamily),
    elevation: 8,
    selectedItemColor: AppColor.primary,
    unselectedItemColor: AppColor.greyLight,
    landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
  );

  static const BottomSheetThemeData bottomSheetTheme = BottomSheetThemeData(
    backgroundColor: AppColor.white,
    clipBehavior: Clip.hardEdge,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    modalElevation: 8,
    modalBackgroundColor: AppColor.white,
  );

  static RadioThemeData radioTheme = RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.hovered) ||
          states.contains(MaterialState.selected) ||
          states.contains(MaterialState.focused)) {
        return AppColor.primary;
      }
      return AppColor.greyLight;
    }),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  static CheckboxThemeData checkBoxTheme = CheckboxThemeData(
    fillColor: MaterialStateProperty.all(AppColor.primary),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );

  static CardTheme cardTheme = CardTheme(
    elevation: 8,
    shadowColor: AppColor.greyLight.withOpacity(0.5),
    clipBehavior: Clip.hardEdge,
    color: AppColor.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    margin: EdgeInsets.zero,
  );

  static DialogTheme dialogTheme = DialogTheme(
    elevation: 16,
    backgroundColor: AppColor.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    titleTextStyle: const TextStyle(fontSize: 16, color: AppColor.textDark, fontWeight: FontWeight.w600),
    contentTextStyle: const TextStyle(fontSize: 14, color: AppColor.textLight, fontWeight: FontWeight.w500),
  );

  static DividerThemeData dividerTheme = const DividerThemeData(color: AppColor.greyLight, space: 1, thickness: 1);

  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.resolveWith((states) => 0),
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColor.primary.withAlpha(150);
        }
        return AppColor.primary;
      }),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColor.white.withOpacity(0.2);
        } else if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
          return AppColor.white.withOpacity(0.1);
        } else {
          return AppColor.transparent;
        }
      }),
      textStyle: MaterialStateProperty.all(const TextStyle(
        fontFamily: kFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      )),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      )),
    ),
  );

  static OutlinedButtonThemeData outlinedButtonThemeData = OutlinedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColor.primary.withOpacity(0.2);
        } else if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
          return AppColor.primary.withOpacity(0.1);
        } else {
          return AppColor.transparent;
        }
      }),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      )),
      textStyle: MaterialStateProperty.all(const TextStyle(
        fontFamily: kFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      )),
      side: MaterialStateProperty.all(const BorderSide(color: AppColor.greyLight, width: 2)),
    ),
  );

  static TextButtonThemeData textButtonThemeData = TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: const TextStyle(
        fontFamily: kFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
