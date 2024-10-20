import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile_challenge/features/home/bloc/home_bloc.dart';
import 'package:tractian_mobile_challenge/features/home/bloc/home_event.dart';
import 'package:tractian_mobile_challenge/features/home/bloc/home_state.dart';
import 'package:tractian_mobile_challenge/theme/colors.dart';
import 'package:tractian_mobile_challenge/theme/icons.dart';
import 'package:tractian_mobile_challenge/theme/typography.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ChallengeColors.deepBlue,
        centerTitle: true,
        title: ChallengeIcons.logo,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: SizedBox(
              height: 64,
              width: 64,
              child: CircularProgressIndicator(
                color: ChallengeColors.blue,
              ),
            ),
          );
        }
        if (state.companiesList.isEmpty && !state.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  ChallengeIcons.noWifi,
                  size: 60,
                ),
                Text(
                  "Sem Internet",
                  style: ChallengeTypography.regularLG(
                      color: ChallengeColors.black),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 22),
          physics: const BouncingScrollPhysics(),
          itemCount: state.companiesList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 22.0),
              child: Card(
                clipBehavior: Clip.hardEdge,
                color: ChallengeColors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: InkWell(
                  splashColor: ChallengeColors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.pushNamed(context, '/assets',
                        arguments: {"id": state.companiesList[index].id!}).then(
                      (_) {
                        if (context.mounted) {
                          context
                              .read<HomeBloc>()
                              .add(const FetchCompaniesEvent());
                        }
                      },
                    );
                  },
                  child: SizedBox(
                    height: size.height * 0.10,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 32, right: 16),
                          child: ChallengeIcons.company(),
                        ),
                        Text(
                          state.companiesList[index].name!,
                          style: ChallengeTypography.mediumLG(
                              color: ChallengeColors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
