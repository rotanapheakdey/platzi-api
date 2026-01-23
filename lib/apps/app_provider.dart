import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logics/product_logic.dart';
import '../screens/splash_screen.dart';

Widget appProvider() {
  return MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => ProductLogic())],
    child: SplashScreen(),
  );
}
