import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Add 'shimmer' to pubspec.yaml if you can, or use Container color

Widget MyLoading(BuildContext context, {int crossAxisCount = 2, double childAspectRatio = 2/3}) {
  return GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
    ),
    itemCount: 6,
    itemBuilder: (context, index) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(child: Container(color: Colors.grey[300])),
              const SizedBox(height: 10),
              Container(height: 10, width: 80, color: Colors.grey[300]),
              const SizedBox(height: 5),
              Container(height: 10, width: 40, color: Colors.grey[300]),
            ],
          ),
        ),
      );
    },
  );
}