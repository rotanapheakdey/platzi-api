import 'package:flutter/material.dart';

Widget MyLogo(BuildContext context) {

  final logo = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNRHMRbBL8BAcMYo3mmhwF-yp9Qku7B6v0hQ&s";

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CircleAvatar(
            //   radius: 70,
            //   backgroundImage: NetworkImage(logo),
            // ),
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Loading..."),
            ),
          ],
        ),
      ),
    );
  }