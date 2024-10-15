import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tractian_mobile_challenge/core/tree/node_types.dart';
import 'package:tractian_mobile_challenge/core/tree/tree_node.dart';
import 'package:tractian_mobile_challenge/theme/colors.dart';
import 'package:tractian_mobile_challenge/theme/icons.dart';
import 'package:tractian_mobile_challenge/theme/typography.dart';

class TreeNodeWidget extends StatelessWidget {
  final TreeNode node;

  const TreeNodeWidget({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(children: [
        _getNodeIcon(node.type),
        const SizedBox(width: 6.0),
        Flexible(
          child: Text(
            node.value,
            style: ChallengeTypography.mediumSM(color: Colors.black),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(width: 6.0),
        if (node.isEnergy)
          ChallengeIcons.energyFilled(color: ChallengeColors.green),
        if (node.isCritical)
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: ChallengeColors.red,
              shape: BoxShape.circle,
            ),
          )
      ]),
      controlAffinity: ListTileControlAffinity.leading,
      leading: node.isLeaf ? const SizedBox.shrink() : null,
      tilePadding: const EdgeInsets.only(left: 4.0),
      enabled: !node.isLeaf,
      childrenPadding: const EdgeInsets.only(left: 16.0),
      collapsedShape: const RoundedRectangleBorder(
        side: BorderSide.none,
      ),
      shape: const RoundedRectangleBorder(
        side: BorderSide.none,
      ),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: node.children.length,
          itemBuilder: (context, index) {
            return TreeNodeWidget(node: node.children[index]);
          },
        ),
      ],
    );
  }

  SvgPicture _getNodeIcon(NodeTypes type) {
    switch (type) {
      case NodeTypes.location:
        return ChallengeIcons.location(color: ChallengeColors.blue);
      case NodeTypes.component:
        return ChallengeIcons.component(color: ChallengeColors.blue);
      case NodeTypes.asset:
        return ChallengeIcons.asset(color: ChallengeColors.blue);
      default:
        throw "Error";
    }
  }
}
