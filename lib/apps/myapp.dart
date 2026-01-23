import 'package:flutter/material.dart';
import '../screens/product_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(builder: (context) => ProductScreen());
          default:
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: Text("Page Not Found")),
                body: Center(child: Text("Route might be wrong")),
              ),
              fullscreenDialog: true,
              settings: settings,
            );
        }
      },
    );
  }
}
