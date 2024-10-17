import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:tractian_mobile_challenge/core/tree/node_types.dart';
import 'package:tractian_mobile_challenge/features/assets/assets.dart';

import 'tree_node.dart';

class Tree extends Equatable {
  const Tree._internal({required this.rootId, required this.rootNodes});

  final String rootId;
  final List<TreeNode> rootNodes;

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

    log("Generate Tree time elapsed: ${end.difference(init)}", name: "Tree");

    return Tree._internal(rootId: rootId, rootNodes: rootElements);
  }

  Tree filterBy(bool Function(TreeNode node) whereClosure) {
    final init = DateTime.now();

    final List<TreeNode> filteredTree = _filterNodes(rootNodes, whereClosure);

    final end = DateTime.now();
    log("Filter Tree time elapsed: ${end.difference(init)}", name: "Tree");
    return Tree._internal(rootId: rootId, rootNodes: filteredTree);
  }

  List<TreeNode> _filterNodes(
      List<TreeNode> nodes, bool Function(TreeNode) whereClosure) {
    final List<TreeNode> filtered = [];

    for (final node in nodes) {
      final filteredChildren = _filterNodes(node.children, whereClosure);

      if (whereClosure(node) || filteredChildren.isNotEmpty) {
        final newNode = TreeNode(
          id: node.id,
          type: node.type,
          value: node.value,
          isCritical: node.isCritical,
          isEnergy: node.isEnergy,
        );
        newNode.addChildren(filteredChildren);
        filtered.add(newNode);
      }
    }

    return filtered;
  }

  int getSize() {
    int size = 0;
    List<TreeNode> stack = [];

    stack.addAll(rootNodes);

    while (stack.isNotEmpty) {
      TreeNode currentNode = stack.removeLast();
      size++;

      stack.addAll(currentNode.children.where((node) => !node.isLeaf).toList());
    }

    return size;
  }

  @override
  List<Object?> get props => [rootId, rootNodes];
}
