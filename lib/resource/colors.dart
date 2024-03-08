import 'package:flutter/material.dart';

abstract class AppColor {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const black30 = Color(0xFF121212);
  static const transparent = Color(0x00000000);

  static const primary = Color(0xFF021937);
  static const secondary = Color(0xFF0E519E);


  static const primaryText = Color(0xFF043C7A);
  static const background = Color(0xFFE5E5E5);

  static const lightBoxBg = Color(0xFFFCFBFC);
  static final darkBoxBg = const Color(0xFF0E519E).withOpacity(.25);
  static final darkBoxBgDrawer = const Color(0xFF0E519E).withOpacity(.4);

  static const textDark = Color(0xFF333333);
  static const textLight = Color(0xFF898F97);
  static const textTitle = Color(0xFF636363);
  static const textPrimary = Color(0xFF7E7E7E);
  static const dividerColor = Color(0xFF929191);
  static const greyBg = Color(0xFFF4F4F4);

  static const grey = Color(0xFF898F97);
  static const greyLight = Color(0xFFDEDEDE);

  static const red = Color(0xFFEE3D3D);
  static const skyBlue = Color(0xFF74CAFC);
  static const orange = Color(0xFFEF711F);
  static const yellow = Color(0xFFF0BD02);
  static const green = Color(0xFF1EAC3D);
  static const greenLight = Color(0xFF7FFF00);
  static const purple = Color(0xFF9253C8);
  static const darkPurple = Color(0xFF021937);
  static const blue = Color(0xFF4875FF);
  static const deselected = Color(0xFF78838E);

  static const facebookBlue = Color(0xFF1877F2);
  static const dislike = Color(0xFF626169);
  static const favourite = Color(0xFF828C5E);

  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF043C7A),Color(0xFF032857),Color(0xFF020B27),],
    begin: AlignmentDirectional.topCenter,
    end: AlignmentDirectional.bottomCenter,
    stops: [.3,.6,1]
  );

  static const primaryGradient1 = LinearGradient(
    colors: [AppColor.secondary,AppColor.primary,],
    begin: AlignmentDirectional.topCenter,
    end: AlignmentDirectional.bottomCenter,
    stops: [.4,1],
    tileMode: TileMode.clamp
  );
}
