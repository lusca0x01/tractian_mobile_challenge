import 'node_types.dart';

// Equatable was not used here because it requires all variables to be final.
// However, fields like parent, children, and visibleChildrenCount are mutable.

/// The [TreeNode] class represents a node in the [Tree] class.
///
/// It includes attributes to store an [id], [type], [value], and references
/// to its [parent] and [children]. Additionally, flags like [isCritical] and
/// [isEnergy] help filtering special nodes.
///
/// The [visibleChildrenCount] is needed for the UI to optimize the expanded
/// Node state.
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

  /// Adds a single child node to the current node’s children list and sets the
  /// current node as the child’s parent.
  void addChild(TreeNode child) {
    child.parent = this;
    children.add(child);
  }

  /// Adds dds multiple children nodes to the current node’s children list and
  /// assigns the current node as their parent.
  void addChildren(List<TreeNode> newChildren) {
    for (var child in newChildren) {
      child.parent = this;
    }

    children.addAll(newChildren);
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
