import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:juniorproj/shared/styles/colors.dart';


ThemeData lightTheme(context) => ThemeData(
    primarySwatch: defaultColor,
    scaffoldBackgroundColor: defaultHomeColor,
    appBarTheme:  AppBarTheme(
      titleSpacing: 16.0,
      backgroundColor: defaultHomeColor,
      elevation: 0.0,
      iconTheme: const IconThemeData(color: Colors.black),

      titleTextStyle: TextStyle(color: defaultColor, fontWeight: FontWeight.bold, fontSize: 20),

      systemOverlayStyle:  SystemUiOverlayStyle(
          statusBarColor: defaultHomeColor,
          statusBarIconBrightness: Brightness.dark
      ),

    ),

    bottomNavigationBarTheme:  BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: defaultColor,
      elevation: 20,
    ),

    // floatingActionButtonTheme: const FloatingActionButtonThemeData(
    //     backgroundColor: Colors.deepOrange
    // ),

    progressIndicatorTheme:  ProgressIndicatorThemeData(
      color: defaultColor,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: defaultColor
    ),

    textTheme: Theme.of(context).textTheme.apply(
      fontFamily: 'Jannah',
      bodyColor: Colors.black,
      displayColor: Colors.black,)

);


ThemeData darkTheme(context)=> ThemeData(

    backgroundColor: defaultHomeDarkColor,
    primarySwatch: defaultDarkColor,
    scaffoldBackgroundColor: defaultHomeDarkColor,
    appBarTheme:  AppBarTheme(
      titleSpacing: 16.0,
      backgroundColor: defaultHomeDarkColor,
      elevation: 0.0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle:TextStyle(color: defaultDarkColor, fontWeight: FontWeight.bold, fontSize: 20),

      actionsIconTheme: const IconThemeData(color: Colors.white),
      systemOverlayStyle:  SystemUiOverlayStyle(
          statusBarColor: defaultHomeDarkColor,
          statusBarIconBrightness: Brightness.light
      ),

    ),

    bottomNavigationBarTheme:  BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: defaultHomeDarkColor,
      selectedItemColor: defaultDarkColor,
      unselectedIconTheme: const IconThemeData(color: Colors.white,),
      unselectedItemColor: Colors.white,
      elevation: 20,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: defaultDarkColor,
    ),

    progressIndicatorTheme:  ProgressIndicatorThemeData(
      color: defaultDarkColor,
    ),

    switchTheme: SwitchThemeData(

      thumbColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        if (states.contains(MaterialState.disabled)) {
          return Colors.white;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.black;
        }
        if (states.contains(MaterialState.disabled)) {
          return Colors.white;
        }
        return Colors.white;
      }),
    ),

    iconTheme: const IconThemeData(
      color: Colors.white
    ),

    inputDecorationTheme: const InputDecorationTheme(
      prefixIconColor: Colors.grey,
      labelStyle: TextStyle(
        color: Colors.white
      ),

      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
      ),

      ),

    bottomSheetTheme:  BottomSheetThemeData(
      backgroundColor: defaultHomeDarkColor,
      modalBackgroundColor: Colors.white,
    ),

    navigationBarTheme:  NavigationBarThemeData(
      backgroundColor: defaultHomeDarkColor,
      indicatorColor: Colors.white,
    ),
    textTheme: Theme.of(context).textTheme.apply(
      bodyColor: Colors.white,
      fontFamily: 'Jannah',
      displayColor: Colors.white,

    )

);
