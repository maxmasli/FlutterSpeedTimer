import 'package:flutter/material.dart';
import 'package:speedtimer_fltr/resources/colors.dart';

enum AppTheme {
  defaultTheme, darkTheme, sunsetTheme
}

ThemeData defaultTheme() => ThemeData(
  primaryColor: AppColors.blue,
);

ThemeData darkTheme() => ThemeData(
  primaryColor: AppColors.grey,

  scaffoldBackgroundColor: AppColors.darkGrey,

  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: AppColors.grey
  ),

  textTheme: const TextTheme(
    subtitle1: TextStyle(
      color: AppColors.white
    ),
    bodyText1: TextStyle(
      color: AppColors.white
    ),
    bodyText2: TextStyle(
      color: AppColors.white,
    )
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(AppColors.grey)
    )
  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(AppColors.darkGrey),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: AppColors.lightGrey),
        ),
      ),
    ),
  ),

);

ThemeData sunsetTheme() => ThemeData(
  primaryColor: AppColors.ssPink,
  scaffoldBackgroundColor: AppColors.ssPurple,

  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(AppColors.ssPink),
      ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(AppColors.ssPurple),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: const BorderSide(color: AppColors.ssDarkPurple),
        ),
      ),
    ),
  ),
);