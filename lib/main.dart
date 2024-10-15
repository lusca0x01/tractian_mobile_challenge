import 'package:flutter/material.dart';
import 'package:tractian_mobile_challenge/config.dart';
import 'package:tractian_mobile_challenge/features/assets/assets.dart';
import 'package:tractian_mobile_challenge/features/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Config.init();

  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (_) => const HomePage(),
      "/assets": (context) {
        final arguments =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return AssetsPage(id: arguments!['id']);
      }
    },
    debugShowCheckedModeBanner: false,
  ));
}
