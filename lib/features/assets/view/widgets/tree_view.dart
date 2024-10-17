import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile_challenge/core/tree/tree.dart';
import 'package:tractian_mobile_challenge/features/assets/bloc/assets_bloc.dart';
import 'package:tractian_mobile_challenge/features/assets/view/widgets/tree_node_widget.dart';

class TreeView extends StatelessWidget {
  const TreeView({
    super.key,
    required this.tree,
  });

  final Tree tree;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AssetsBloc>().state;
    final shouldExpand = (state.energySensorFilter ||
        state.criticalFilter ||
        state.searchTextFilter.isNotEmpty);

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: tree.rootNodes.length,
      itemBuilder: (context, index) {
        return TreeNodeWidget(
          node: tree.rootNodes[index],
          initiallyExpanded: shouldExpand,
          bigTree: tree.getSize(withLeaves: false) > 100,
        );
      },
    );
  }
}
