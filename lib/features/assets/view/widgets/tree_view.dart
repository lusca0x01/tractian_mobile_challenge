import 'package:flutter/material.dart';
import 'package:tractian_mobile_challenge/core/tree/tree.dart';
import 'package:tractian_mobile_challenge/features/assets/view/widgets/tree_node_widget.dart';

class TreeView extends StatelessWidget {
  final Tree tree;

  const TreeView({super.key, required this.tree});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tree.nodes.length,
      itemBuilder: (context, index) {
        return TreeNodeWidget(node: tree.nodes[index]);
      },
    );
  }
}
