import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile_challenge/config.dart';
import 'package:tractian_mobile_challenge/features/home/bloc/home_bloc.dart';
import 'package:tractian_mobile_challenge/features/home/bloc/home_event.dart';
import 'package:tractian_mobile_challenge/features/home/view/home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => HomeBloc(
          connectivityChecker: Config.connectivityChecker,
          apiService: Config.apiService,
        )..add(const FetchCompaniesEvent()),
        child: const HomeView(),
      ),
    );
  }
}
