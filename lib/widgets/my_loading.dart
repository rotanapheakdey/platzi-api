import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget MyLoading(
  BuildContext context, {
  int itemCount = 10,
  int crossAxisCount = 2,
  double childAspectRatio = 2 / 3,
}) {
  return Skeletonizer(
    child: GridView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text("sadsadasdasdsadsadasdasdasdas"),
            subtitle: Text(
              "sadsadasdasdsad sasadsadasdasdsadsada sdasdasd asdasdasdasdas",
            ),
          ),
        );
      },
    ),
  );
}
