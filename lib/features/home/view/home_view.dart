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
          return const Center(child: CircularProgressIndicator());
        }
        if (state.companiesList.isEmpty && !state.isLoading) {
          return const Center(
            child: Text("Sem Internet"),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 22),
          itemCount: state.companiesList.length,
          itemBuilder: (context, index) {
            return Card(
              clipBehavior: Clip.hardEdge,
              color: ChallengeColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: InkWell(
                splashColor: ChallengeColors.blue.withAlpha(30),
                onTap: () {
                  Navigator.pushNamed(context, '/assets').then(
                    (_) {
                      if (context.mounted) {
                        context.read<HomeBloc>().add(const HomeInitEvent());
                      }
                    },
                  );
                },
                child: SizedBox(
                  height: size.height * 0.12,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 32, right: 16),
                        child: ChallengeIcons.company,
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
            );
          },
          separatorBuilder: (BuildContext context, int index) => SizedBox(
            height: size.height * 0.05,
          ),
        );
      }),
    );
  }
}
