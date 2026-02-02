import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui'; 

// 1. IMPORTS for ALL your Logics
import '../logics/product_logic.dart';
import '../logics/category_logic.dart'; 
import '../logics/search_product_logic.dart'; // <--- Was missing
import '../logics/theme_logic.dart';          // <--- Was missing
import '../logics/textsize_logic.dart';       // <--- Was missing

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
      // 2. Register ALL Logics here
      ChangeNotifierProvider(create: (_) => ProductLogic()),
      ChangeNotifierProvider(create: (_) => CategoryLogic()),
      ChangeNotifierProvider(create: (_) => SearchProductLogic()), // <--- ADDED
      ChangeNotifierProvider(create: (_) => ThemeLogic()),         // <--- ADDED
      ChangeNotifierProvider(create: (_) => TextSizeLogic()),      // <--- ADDED
    ],
    child: const MyApp(), // Separated MaterialApp into a widget for cleaner code
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch ThemeLogic to switch between Light/Dark mode
    // (If ThemeLogic isn't ready, remove 'context.watch' and use 'ThemeMode.system')
    final themeMode = context.watch<ThemeLogic>().mode; 

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ten11 Store',
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true), // Basic Dark Theme
      themeMode: themeMode, 
      home: const SplashScreen(),
    );
  }
}