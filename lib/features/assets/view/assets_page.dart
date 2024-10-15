import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile_challenge/config.dart';
import 'package:tractian_mobile_challenge/features/assets/bloc/assets_bloc.dart';
import 'package:tractian_mobile_challenge/features/assets/bloc/assets_event.dart';
import 'package:tractian_mobile_challenge/features/assets/view/assets_view.dart';

class AssetsPage extends StatelessWidget {
  const AssetsPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => AssetsBloc(
          id: id,
          connectivityChecker: Config.connectivityChecker,
          apiService: Config.apiService,
        )..add(const FetchAssetsEvent()),
        child: const AssetsView(),
      ),
    );
  }
}
