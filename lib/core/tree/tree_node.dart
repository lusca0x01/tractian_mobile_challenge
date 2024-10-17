import 'node_types.dart';

class TreeNode {
  TreeNode({
    required this.id,
    required this.type,
    required this.value,
    this.isCritical = false,
    this.isEnergy = false,
    this.visibleChildrenCount = 3,
  });

  final String id;
  final bool isCritical;
  final bool isEnergy;
  TreeNode? parent;
  final List<TreeNode> children = [];
  final NodeTypes type;
  final String value;
  int visibleChildrenCount;
  bool get isLeaf => children.isEmpty;

  void addChild(TreeNode child) {
    child.parent = this;
    children.add(child);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! TreeNode) return false;

    return (id == other.id &&
        isCritical == other.isCritical &&
        isEnergy == other.isEnergy &&
        parent == other.parent &&
        children == other.children &&
        type == other.type &&
        value == other.value &&
        isLeaf == other.isLeaf &&
        hashCode == other.hashCode);
  }

  @override
  int get hashCode => Object.hash(
        id,
        isCritical,
        isEnergy,
        parent,
        children,
        type,
        value,
      );
}
