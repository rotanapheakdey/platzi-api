import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui'; 

// IMPORTS (Check your file names, I saw 'categpry_logic' in your tree!)
import '../logics/product_logic.dart';
import '../logics/category_logic.dart'; // Make sure file is named category_logic.dart
// import '../logics/search_product_logic.dart'; // Uncomment if you have this file
// import '../logics/theme_logic.dart';          // Uncomment if you have this file

import '../screens/splash_screen.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

Widget appProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProductLogic()),
      ChangeNotifierProvider(create: (_) => CategoryLogic()),
      // Add other providers here if you have them in your 'logics' folder
      // ChangeNotifierProvider(create: (_) => SearchProductLogic()),
      // ChangeNotifierProvider(create: (_) => ThemeLogic()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ten11 Store',
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    ),
  );
}