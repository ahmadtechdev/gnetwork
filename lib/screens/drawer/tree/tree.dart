import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import 'tree_controller.dart';
import 'tree_model.dart';

class NetworkTreeScreen extends StatelessWidget {
  final TreeController controller = Get.put(TreeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(),
      appBar: _buildAppBar(),
      body: Obx(() => _buildBody()),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: MyColor.getAppbarBgColor(),
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: MyColor.getAppbarTitleColor(),
        ),
        onPressed: () => Get.back(),
      ),
      title: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Network Tree',
            style: TextStyle(
              color: MyColor.getAppbarTitleColor(),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (controller.getCurrentNodeUsername().isNotEmpty)
            Text(
              '@${controller.getCurrentNodeUsername()}',
              style: TextStyle(
                color: MyColor.getAppbarTitleColor().withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      )),
      actions: [
        Obx(() => controller.canNavigateBack()
            ? IconButton(
          icon: Icon(
            Icons.refresh,
            color: MyColor.getAppbarTitleColor(),
          ),
          onPressed: controller.resetToRoot,
        )
            : SizedBox()),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return _buildLoadingState();
    }

    return Column(
      children: [
        _buildNavigationBar(),
        Expanded(
          child: AnimatedBuilder(
            animation: controller.fadeAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: controller.fadeAnimation,
                child: SlideTransition(
                  position: controller.slideAnimation,
                  child: _buildTreeStructure(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(MyColor.getPrimaryColor()),
          ),
          SizedBox(height: 16),
          Text(
            'Loading network tree...',
            style: TextStyle(
              color: MyColor.getTextColor(),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: MyColor.getCardBg(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: MyColor.getGCoinDividerColor(),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColor.getGCoinShadowColor(),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Obx(() => controller.canNavigateBack()
              ? GestureDetector(
            onTap: controller.navigateBack,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: MyColor.getPrimaryColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_back,
                color: MyColor.getPrimaryColor(),
                size: 20,
              ),
            ),
          )
              : SizedBox()),
          SizedBox(width: controller.canNavigateBack() ? 12 : 0),
          Expanded(
            child: Obx(() => Text(
              controller.getCurrentNodeTitle(),
              style: TextStyle(
                color: MyColor.getTextColor(),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            )),
          ),
          Obx(() => controller.navigationHistory.isNotEmpty
              ? Text(
            'Level ${controller.navigationHistory.length + 1}',
            style: TextStyle(
              color: MyColor.getPrimaryColor(),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          )
              : SizedBox()),
        ],
      ),
    );
  }

  Widget _buildTreeStructure() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Current Node (Root)
          _buildCurrentNode(),
          SizedBox(height: 40),
          // Tree Connections
          _buildTreeConnections(),
          SizedBox(height: 20),
          // Child Nodes
          _buildChildNodes(),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCurrentNode() {
    return Obx(() {
      final current = controller.currentNode.value;
      if (current == null) return SizedBox();

      return Container(
        width: double.infinity,
        child: Column(
          children: [
            _buildNodeCard(
              node: current,
              isCurrentNode: true,
              onTap: null,
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: MyColor.getPrimaryColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: MyColor.getPrimaryColor().withOpacity(0.3),
                ),
              ),
              child: Text(
                'Current Node',
                style: TextStyle(
                  color: MyColor.getPrimaryColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTreeConnections() {
    return Obx(() {
      if (controller.treeNodes.isEmpty) {
        return _buildEmptyState();
      }

      return Container(
        height: 60,
        child: CustomPaint(
          painter: TreeConnectionPainter(
            nodeCount: controller.treeNodes.length,
            color: MyColor.getPrimaryColor(),
          ),
          size: Size(double.infinity, 60),
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.account_tree_outlined,
            size: 64,
            color: MyColor.getTextColor().withOpacity(0.3),
          ),
          SizedBox(height: 16),
          Text(
            'No downline members',
            style: TextStyle(
              color: MyColor.getTextColor().withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This member hasn\'t referred anyone yet',
            style: TextStyle(
              color: MyColor.getTextColor().withOpacity(0.4),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChildNodes() {
    return Obx(() {
      if (controller.treeNodes.isEmpty) return SizedBox();

      // Sort nodes by position
      final sortedNodes = List<TreeNode>.from(controller.treeNodes);
      sortedNodes.sort((a, b) {
        const positionOrder = {'left': 0, 'middle': 1, 'right': 2};
        return (positionOrder[a.position] ?? 3)
            .compareTo(positionOrder[b.position] ?? 3);
      });

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < 3; i++) ...[
            Expanded(
              child: i < sortedNodes.length
                  ? _buildNodeCard(
                node: sortedNodes[i],
                isCurrentNode: false,
                onTap: () => controller.navigateToNode(sortedNodes[i]),
              )
                  : _buildPlaceholderNode(),
            ),
            if (i < 2) SizedBox(width: 16),
          ],
        ],
      );
    });
  }

  Widget _buildNodeCard({
    required TreeNode node,
    required bool isCurrentNode,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isCurrentNode
              ? MyColor.getGCoinPrimaryGradient()
              : LinearGradient(
            colors: [
              MyColor.getCardBg(),
              MyColor.getGCoinCardColor(),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrentNode
                ? MyColor.getPrimaryColor()
                : MyColor.getGCoinDividerColor(),
            width: isCurrentNode ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColor.getGCoinShadowColor(),
              blurRadius: isCurrentNode ? 12 : 8,
              offset: Offset(0, isCurrentNode ? 4 : 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar
            Container(
              width: isCurrentNode ? 80 : 60,
              height: isCurrentNode ? 80 : 60,
              decoration: BoxDecoration(
                color: isCurrentNode
                    ? Colors.white.withOpacity(0.2)
                    : MyColor.getPrimaryColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(isCurrentNode ? 40 : 30),
                border: Border.all(
                  color: isCurrentNode
                      ? Colors.white.withOpacity(0.3)
                      : MyColor.getPrimaryColor().withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  node.getInitials(),
                  style: TextStyle(
                    color: isCurrentNode ? Colors.white : MyColor.getPrimaryColor(),
                    fontSize: isCurrentNode ? 24 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            // Name
            Text(
              node.name,
              style: TextStyle(
                color: isCurrentNode ? Colors.white : MyColor.getTextColor(),
                fontSize: isCurrentNode ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            // Username
            Text(
              '@${node.username}',
              style: TextStyle(
                color: isCurrentNode
                    ? Colors.white.withOpacity(0.8)
                    : MyColor.getTextColor().withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            // Position Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isCurrentNode
                    ? Colors.white.withOpacity(0.2)
                    : MyColor.getPrimaryColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                node.position.toUpperCase(),
                style: TextStyle(
                  color: isCurrentNode
                      ? Colors.white
                      : MyColor.getPrimaryColor(),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 8),
            // Downline Count
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 16,
                  color: isCurrentNode
                      ? Colors.white.withOpacity(0.8)
                      : MyColor.getTextColor().withOpacity(0.6),
                ),
                SizedBox(width: 4),
                Text(
                  '${node.downlineCount}',
                  style: TextStyle(
                    color: isCurrentNode
                        ? Colors.white.withOpacity(0.8)
                        : MyColor.getTextColor().withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (onTap != null && node.downlineCount > 0) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: MyColor.getPrimaryColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Tap to explore',
                  style: TextStyle(
                    color: MyColor.getPrimaryColor(),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderNode() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColor.getCardBg().withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MyColor.getGCoinDividerColor().withOpacity(0.3),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: MyColor.getTextColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: MyColor.getTextColor().withOpacity(0.2),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Icon(
              Icons.person_add_outlined,
              color: MyColor.getTextColor().withOpacity(0.3),
              size: 24,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Available Slot',
            style: TextStyle(
              color: MyColor.getTextColor().withOpacity(0.4),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TreeConnectionPainter extends CustomPainter {
  final int nodeCount;
  final Color color;

  TreeConnectionPainter({
    required this.nodeCount,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final topY = 0.0;
    final bottomY = size.height;
    final middleY = size.height / 2;

    // Draw vertical line from center top to middle
    canvas.drawLine(
      Offset(centerX, topY),
      Offset(centerX, middleY),
      paint,
    );

    if (nodeCount > 0) {
      // Draw horizontal line
      final leftX = size.width * 0.17;
      final rightX = size.width * 0.83;

      canvas.drawLine(
        Offset(leftX, middleY),
        Offset(rightX, middleY),
        paint,
      );

      // Draw vertical lines to child nodes
      final childPositions = [
        size.width * 0.17, // Left
        centerX,            // Middle
        size.width * 0.83,  // Right
      ];

      for (int i = 0; i < nodeCount && i < 3; i++) {
        canvas.drawLine(
          Offset(childPositions[i], middleY),
          Offset(childPositions[i], bottomY),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}