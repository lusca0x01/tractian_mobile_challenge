import 'node_types.dart';

class TreeNode {
  TreeNode({
    required this.id,
    required this.type,
    required this.value,
    this.isCritical = false,
    this.isEnergy = false,
  });

  final String id;
  final bool isCritical;
  final bool isEnergy;
  final List<TreeNode> children = [];
  final NodeTypes type;
  final String value;

  void addChild(TreeNode child) {
    children.add(child);
  }

  bool get isLeaf => children.isEmpty;
}
