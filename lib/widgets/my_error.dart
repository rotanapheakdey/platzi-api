import 'package:flutter/material.dart';

Widget MyError(BuildContext context, {required String error, required void Function()? onPressed}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 32),
                Text(error),
                ElevatedButton.icon(
                  onPressed: onPressed,
                  icon: Icon(Icons.refresh),
                  label: Text("RETRY"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
