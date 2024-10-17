import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tractian_mobile_challenge/core/tree/node_types.dart';
import 'package:tractian_mobile_challenge/core/tree/tree_node.dart';
import 'package:tractian_mobile_challenge/theme/colors.dart';
import 'package:tractian_mobile_challenge/theme/icons.dart';
import 'package:tractian_mobile_challenge/theme/typography.dart';

class TreeNodeWidget extends StatefulWidget {
  final TreeNode node;
  final bool initiallyExpanded;
  final bool isBig;

  const TreeNodeWidget({
    super.key,
    required this.node,
    required this.initiallyExpanded,
    required this.isBig,
  });

  @override
  State<TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<TreeNodeWidget> {
  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    final initiallyExpanded = widget.initiallyExpanded;
    final isBig = widget.isBig;

    return ExpansionTile(
      key: ValueKey("${node.id}.${widget.initiallyExpanded}"),
      title: Row(
        children: [
          _getNodeIcon(node.type),
          const SizedBox(width: 4.0),
          Flexible(
            child: Text(
              node.value,
              style: ChallengeTypography.mediumSM(color: ChallengeColors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 4.0),
          if (node.isEnergy)
            ChallengeIcons.energyFilled(
              color: ChallengeColors.green,
              width: 12,
              height: 12,
            ),
          if (node.isCritical)
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: ChallengeColors.red,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      maintainState: !node.isLeaf && initiallyExpanded,
      initiallyExpanded: initiallyExpanded,
      controlAffinity: ListTileControlAffinity.leading,
      leading: node.isLeaf ? const SizedBox.shrink() : null,
      iconColor: ChallengeColors.blue,
      tilePadding: const EdgeInsets.only(left: 4.0),
      enabled: !node.isLeaf,
      childrenPadding: const EdgeInsets.only(left: 16.0),
      collapsedShape: const RoundedRectangleBorder(
        side: BorderSide.none,
      ),
      shape: const RoundedRectangleBorder(
        side: BorderSide.none,
      ),
      children: initiallyExpanded && isBig
          ? [
              ...node.children.take(node.visibleChildrenCount).map((childNode) {
                return TreeNodeWidget(
                  node: childNode,
                  initiallyExpanded: initiallyExpanded,
                  isBig: isBig,
                );
              }),
              if (node.visibleChildrenCount < node.children.length)
                ListTile(
                  title: TextButton(
                    onPressed: () {
                      setState(() {
                        node.visibleChildrenCount += 10;
                        if (node.visibleChildrenCount > node.children.length) {
                          node.visibleChildrenCount = node.children.length;
                        }
                      });
                    },
                    child: Text(
                      'Carregar mais (${node.children.length - node.visibleChildrenCount})',
                      style: ChallengeTypography.mediumSM(
                          color: ChallengeColors.blue),
                    ),
                  ),
                ),
            ]
          : node.children.map((childNode) {
              return TreeNodeWidget(
                node: childNode,
                initiallyExpanded: initiallyExpanded,
                isBig: isBig,
              );
            }).toList(),
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
        throw Exception("No provided icon error");
    }
  }
}
