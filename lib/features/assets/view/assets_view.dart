import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile_challenge/features/assets/bloc/assets_bloc.dart';
import 'package:tractian_mobile_challenge/features/assets/bloc/assets_event.dart';
import 'package:tractian_mobile_challenge/features/assets/bloc/assets_state.dart';
import 'package:tractian_mobile_challenge/features/assets/view/widgets/custom_toggle_buttons.dart';
import 'package:tractian_mobile_challenge/features/assets/view/widgets/tree_view.dart';
import 'package:tractian_mobile_challenge/theme/colors.dart';
import 'package:tractian_mobile_challenge/theme/icons.dart';
import 'package:tractian_mobile_challenge/theme/typography.dart';

class AssetsView extends StatelessWidget {
  const AssetsView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ChallengeColors.deepBlue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(ChallengeIcons.back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Assets",
          style: ChallengeTypography.regularLG(color: ChallengeColors.white),
        ),
      ),
      body: BlocBuilder<AssetsBloc, AssetsState>(builder: (context, state) {
        if (state.isLoading == false && state.assetsList.isNotEmpty) {
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SizedBox(
                          height: size.height * 0.05,
                          child: SearchBar(
                            backgroundColor: const WidgetStatePropertyAll(
                                ChallengeColors.gray100),
                            hintText: "Buscar Ativo ou Local",
                            hintStyle: WidgetStatePropertyAll(
                              ChallengeTypography.regularSM(
                                  color: ChallengeColors.gray500),
                            ),
                            textStyle: WidgetStatePropertyAll(
                              ChallengeTypography.regularSM(
                                  color: ChallengeColors.gray500),
                            ),
                            leading: const Icon(
                              Icons.search,
                              color: ChallengeColors.gray500,
                            ),
                            shape: const WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                            ),
                            shadowColor: const WidgetStatePropertyAll(
                              Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CustomToggleButtons(
                              isSelected: [state.energySensorFilter],
                              onPressed: (_) => context
                                  .read<AssetsBloc>()
                                  .add(const EnergySensorFilterEvent()),
                              height: size.height * 0.05,
                              color: ChallengeColors.blue,
                              radius: 3.0,
                              icon: ChallengeIcons.energy(
                                  color: state.energySensorFilter
                                      ? ChallengeColors.white
                                      : ChallengeColors.bodyText2),
                              text: Text(
                                "Sensor de Energia",
                                style: ChallengeTypography.mediumSM(
                                  color: state.energySensorFilter
                                      ? ChallengeColors.white
                                      : ChallengeColors.bodyText2,
                                ),
                              ),
                            ),
                          ),
                          CustomToggleButtons(
                            isSelected: [state.criticalFilter],
                            onPressed: (_) => context
                                .read<AssetsBloc>()
                                .add(const CriticalFilterEvent()),
                            color: ChallengeColors.blue,
                            height: size.height * 0.05,
                            radius: 3.0,
                            icon: ChallengeIcons.critical(
                                color: state.criticalFilter
                                    ? ChallengeColors.white
                                    : ChallengeColors.bodyText2),
                            text: Text(
                              "Crítico",
                              style: ChallengeTypography.mediumSM(
                                color: state.criticalFilter
                                    ? ChallengeColors.white
                                    : ChallengeColors.bodyText2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: TreeView(tree: context.read<AssetsBloc>().tree!),
              ),
            ],
          );
        }

        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
