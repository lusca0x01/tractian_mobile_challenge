import 'package:flutter/material.dart';
import 'package:tractian_mobile_challenge/config.dart';
import 'package:tractian_mobile_challenge/features/assets/assets.dart';
import 'package:tractian_mobile_challenge/features/home/home.dart';

void main() async {
  await Config.init();

  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => const HomePage(),
      "/assets": (context) => const AssetsPage(),
    },
    debugShowCheckedModeBanner: false,
  ));
}
