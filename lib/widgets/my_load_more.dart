import 'package:flutter/material.dart';

Widget MyLoadMore(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 20),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}