class TreeNode {
  final int id;
  final String name;
  final String username;
  final String position;
  final int downlineCount;

  TreeNode({
    required this.id,
    required this.name,
    required this.username,
    required this.position,
    required this.downlineCount,
  });

  factory TreeNode.fromJson(Map<String, dynamic> json) {
    return TreeNode(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      position: json['position'] ?? '',
      downlineCount: json['downline_count'] ?? 0,
    );
  }

  String getInitials() {
    if (name.isEmpty) return 'U';
    List<String> names = name.trim().split(' ');
    if (names.length == 1) {
      return names[0].substring(0, 1).toUpperCase();
    } else {
      return '${names[0].substring(0, 1)}${names[1].substring(0, 1)}'.toUpperCase();
    }
  }
}

class TreeResponse {
  final bool success;
  final String message;
  final List<TreeNode> tree;

  TreeResponse({
    required this.success,
    required this.message,
    required this.tree,
  });

  factory TreeResponse.fromJson(Map<String, dynamic> json) {
    return TreeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      tree: (json['tree'] as List?)
          ?.map((item) => TreeNode.fromJson(item))
          .toList() ?? [],
    );
  }
}