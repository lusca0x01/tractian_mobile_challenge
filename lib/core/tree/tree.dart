import 'dart:developer';

import 'package:tractian_mobile_challenge/core/tree/node_types.dart';
import 'package:tractian_mobile_challenge/features/assets/assets.dart';

import 'tree_node.dart';

class Tree {
  Tree._internal({required this.rootId, required this.nodes});

  final String rootId;
  final List<TreeNode> nodes;

  factory Tree.generateTree(
    String rootId,
    List<LocationModel> locationList,
    List<AssetModel> assetsList,
    List<ComponentModel> componentList,
  ) {
    final Map<String, TreeNode> nodeMap = {};

    final init = DateTime.now();

    for (var location in locationList) {
      nodeMap[location.id!] = TreeNode(
        id: location.id!,
        type: NodeTypes.location,
        value: location.name!,
      );
    }

    for (var component in componentList) {
      nodeMap[component.id!] = TreeNode(
        id: component.id!,
        type: NodeTypes.component,
        value: component.name!,
        isCritical: component.status == "alert",
        isEnergy: component.sensorType == "energy",
      );
    }

    for (var asset in assetsList) {
      nodeMap[asset.id!] = TreeNode(
        id: asset.id!,
        type: NodeTypes.asset,
        value: asset.name!,
      );
    }

    locationList
        .where((location) => location.parentId != null)
        .forEach((location) {
      final parentNode = nodeMap[location.parentId!];
      parentNode?.addChild(nodeMap[location.id!]!);
    });

    componentList
        .where((component) =>
            component.parentId != null || component.locationId != null)
        .forEach((component) {
      final parentNode = nodeMap[component.parentId ?? component.locationId];
      parentNode?.addChild(nodeMap[component.id!]!);
    });

    assetsList
        .where((asset) => asset.parentId != null || asset.locationId != null)
        .forEach((asset) {
      final parentNode = nodeMap[asset.parentId ?? asset.locationId];
      parentNode?.addChild(nodeMap[asset.id!]!);
    });

    final List<TreeNode> rootElements = [];

    locationList.where((location) => location.parentId == null).forEach(
          (location) => rootElements.add(nodeMap[location.id!]!),
        );

    componentList
        .where((component) =>
            component.parentId == null && component.locationId == null)
        .forEach(
          (component) => rootElements.add(nodeMap[component.id!]!),
        );

    final end = DateTime.now();

    log(end.difference(init).toString());

    return Tree._internal(rootId: rootId, nodes: rootElements);
  }
}
