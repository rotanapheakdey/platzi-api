import 'package:flutter/material.dart';
import '../apps/myapp.dart';
import '../logics/product_logic.dart';
import '../widgets/my_error.dart';
import '../widgets/my_logo.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future? _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _loadData();
  }

  Future _loadData() async {
    await Future.delayed(Duration(seconds: 2), () {});
    return Future.any([context.read<ProductLogic>().readProductPagination()]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _futureData == null
          ? MyLogo(context)
          : FutureBuilder(
              future: _futureData,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return MyError(
                    context,
                    error: snapshot.error.toString(),
                    onPressed: () {
                      setState(() {
                        _futureData = _loadData();
                      });
                    },
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return MyApp();
                } else {
                  return MyLogo(context);
                }
              },
            ),
    );
  }
}
