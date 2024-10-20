import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:tractian_mobile_challenge/core/tree/node_types.dart';
import 'package:tractian_mobile_challenge/features/assets/assets.dart';

import 'tree_node.dart';

/// The [Tree] class represents a tree data structure, where each node is a
/// [TreeNode].
///
/// It build it's tree from the data models provided on the models present on
/// the assets feature.
class Tree extends Equatable {
  const Tree._internal({required this.rootId, required this.rootNodes});

  final String rootId;
  final List<TreeNode> rootNodes;

  /// Factory method to generate a tree from a list of locations, assets, and
  /// components.
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

  /// Filters the tree based on a condition provided by the [whereClosure].
  ///
  /// The conditions are: value (text filtering), if it's a critical node or an
  /// energy one.
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

  /// Returns the total number of nodes in the tree.
  ///
  /// The [withLeaves] define if the method will count the leaves or not in the
  /// tree size.
  int getSize({bool withLeaves = false}) {
    int size = 0;
    List<TreeNode> stack = [];

    stack.addAll(rootNodes);

    while (stack.isNotEmpty) {
      TreeNode currentNode = stack.removeLast();
      size++;

      if (!withLeaves) {
        stack.addAll(
            currentNode.children.where((child) => !child.isLeaf).toList());
        continue;
      }

      stack.addAll(currentNode.children.toList());
    }

    return size;
  }

  @override
  List<Object?> get props => [rootId, rootNodes];
}
