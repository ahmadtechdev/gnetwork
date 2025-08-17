import 'package:flutter/material.dart';
import 'package:gcoin/screens/homescreen/homescreen.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import 'tree_controller.dart';
import 'tree_model.dart';

class NetworkTreeScreen extends StatelessWidget {
  final TreeController controller = Get.put(TreeController());

  NetworkTreeScreen({super.key});
  // final ScrollController scrollController = ScrollController();


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
        icon: Icon(Icons.arrow_back_ios, color: MyColor.getAppbarTitleColor()),
        onPressed: () => Get.off(PiNetworkHomeScreen()),
      ),
      title: Obx(
        () => Column(
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
        ),
      ),
      actions: [
        Obx(
          () =>
              controller.canNavigateBack()
                  ? IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: MyColor.getAppbarTitleColor(),
                    ),
                    onPressed: controller.resetToRoot,
                  )
                  : SizedBox(),
        ),
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
        // _buildNavigationBar(),
        _buildSearchBar(),
        SizedBox(height: 8,),
        Expanded(
          child: AnimatedBuilder(
            animation: controller.fadeAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: controller.fadeAnimation,
                child: SlideTransition(
                  position: controller.slideAnimation,
                  child: SingleChildScrollView(
                    // controller: scrollController, // Add this
                    child: Column(
                      children: [
                        _buildSearchResults(),
                        SizedBox(height: 12),
                        _buildTreeStructure(),

                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    final searchController = TextEditingController();
    final hasText = RxBool(false);
    final FocusNode searchFocusNode = FocusNode(); // Add focus node

    searchController.addListener(() {
      hasText.value = searchController.text.isNotEmpty;
    });

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16),
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
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              focusNode: searchFocusNode, // Assign focus node
              decoration: InputDecoration(
                hintText: 'Search by username...',
                hintStyle: TextStyle(
                  color: MyColor.getTextColor().withOpacity(0.5),
                ),
                border: InputBorder.none,
                icon: Icon(Icons.search,
                    color: MyColor.getPrimaryColor()),
              ),
              style: TextStyle(color: MyColor.getTextColor()),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  controller.searchUser(value);
                  // Dismiss keyboard
                  searchFocusNode.unfocus();
                  // Trigger scroll after search
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  //   scrollController.animateTo(
                  //     scrollController.position.maxScrollExtent,
                  //     duration: Duration(milliseconds: 500),
                  //     curve: Curves.easeOut,
                  //   );
                  // });
                }
              },
            ),
          ),
          Obx(() {
            if (controller.isSearching.value) {
              return Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        MyColor.getPrimaryColor()),
                  ),
                ),
              );
            } else {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => hasText.value
                      ? IconButton(
                    icon: Icon(Icons.done_outline,
                        color: MyColor.getPrimaryColor()),
                    onPressed: () {
                      // Dismiss keyboard first
                      searchFocusNode.unfocus();
                      // Then perform search
                      controller.searchUser(searchController.text);
                      // Trigger scroll after search
                      // WidgetsBinding.instance.addPostFrameCallback((_) {
                      //   scrollController.animateTo(
                      //     scrollController.position.maxScrollExtent,
                      //     duration: Duration(milliseconds: 500),
                      //     curve: Curves.easeOut,
                      //   );
                      // });
                    },
                  )
                      : SizedBox.shrink()),
                  IconButton(
                    icon: Icon(Icons.close,
                        color: MyColor.getTextColor().withOpacity(0.5)),
                    onPressed: () {
                      // Dismiss keyboard when clearing
                      searchFocusNode.unfocus();
                      searchController.clear();
                      controller.clearSearch();
                    },
                  ),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Obx(() {
      if (controller.searchResult.value != null) {
        final user = controller.searchResult.value!['user'];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: MyColor.getCardBg(),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: MyColor.getPrimaryColor().withOpacity(0.3),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search Result',
                style: TextStyle(
                  color: MyColor.getPrimaryColor(),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: MyColor.getPrimaryColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: MyColor.getPrimaryColor().withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        user['name']
                            .toString()
                            .split(' ')
                            .map((n) => n[0])
                            .take(2)
                            .join(),
                        style: TextStyle(
                          color: MyColor.getPrimaryColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'],
                          style: TextStyle(
                            color: MyColor.getTextColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@${user['username']}',
                          style: TextStyle(
                            color: MyColor.getTextColor().withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSearchResultItem(
                    'Location',
                    controller.searchResult.value!['location'],
                  ),
                  _buildSearchResultItem('Position', user['position']),
                  _buildSearchResultItem(
                    'Downline',
                    user['downline_count'].toString(),
                  ),
                ],
              ),

            ],
          ),
        );
      } else if (controller.searchError.isNotEmpty) {
        // Determine color based on error type
        final isWarning = controller.searchError.value.contains('not in your tree');
        final errorColor = isWarning ? Colors.orange : Colors.red;

        return Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: errorColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isWarning ? Icons.warning_amber : Icons.error_outline,
                color: errorColor,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.searchError.value,
                  style: TextStyle(
                    color: errorColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return SizedBox();
    });
  }

  Widget _buildSearchResultItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: MyColor.getTextColor().withOpacity(0.6),
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: MyColor.getTextColor(),
            fontWeight: FontWeight.bold,
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
            valueColor: AlwaysStoppedAnimation<Color>(
              MyColor.getPrimaryColor(),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Loading network tree...',
            style: TextStyle(color: MyColor.getTextColor(), fontSize: 16),
          ),
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
          SizedBox(height: 10),
          // Tree Connections
          _buildTreeConnections(),
          SizedBox(height: 20),
          // Child Nodes
          _buildChildNodes(),
          SizedBox(height: 20),
          Obx(() {
            if (controller.treeResponse.value?.downline == true) {
              return _buildBusinessMatrix();
            }
            return SizedBox();
          }),
          SizedBox(height: 8),
        ],
      ),
    );
  }
  Widget _buildCurrentNode() {
    return Obx(() {
      final current = controller.currentNode.value;
      if (current == null) return SizedBox();

      return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            _buildNodeCard(node: current, isCurrentNode: true, onTap: null),
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

      return SizedBox(
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
      if (controller.treeNodes.isEmpty) return _buildEmptyState();

      // Create a map of nodes by their positions
      final nodesByPosition = {
        'left': controller.treeNodes.firstWhereOrNull((node) => node.position == 'left'),
        'middle': controller.treeNodes.firstWhereOrNull((node) => node.position == 'middle'),
        'right': controller.treeNodes.firstWhereOrNull((node) => node.position == 'right'),
      };

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left position
          Expanded(
            child: nodesByPosition['left'] != null
                ? _buildNodeCard(
              node: nodesByPosition['left']!,
              isCurrentNode: false,
              onTap: () => controller.navigateToNode(nodesByPosition['left']!),
            )
                : _buildPlaceholderNode(),
          ),
          SizedBox(width: 16),
          // Middle position
          Expanded(
            child: nodesByPosition['middle'] != null
                ? _buildNodeCard(
              node: nodesByPosition['middle']!,
              isCurrentNode: false,
              onTap: () => controller.navigateToNode(nodesByPosition['middle']!),
            )
                : _buildPlaceholderNode(),
          ),
          SizedBox(width: 16),
          // Right position
          Expanded(
            child: nodesByPosition['right'] != null
                ? _buildNodeCard(
              node: nodesByPosition['right']!,
              isCurrentNode: false,
              onTap: () => controller.navigateToNode(nodesByPosition['right']!),
            )
                : _buildPlaceholderNode(),
          ),
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
      // onTap: onTap,
      onTap: () {},
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient:
              isCurrentNode
                  ? MyColor.getGCoinPrimaryGradient()
                  : LinearGradient(
                    colors: [MyColor.getCardBg(), MyColor.getGCoinCardColor()],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isCurrentNode
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
                color:
                    isCurrentNode
                        ? Colors.white.withOpacity(0.2)
                        : MyColor.getPrimaryColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(isCurrentNode ? 40 : 30),
                border: Border.all(
                  color:
                      isCurrentNode
                          ? Colors.white.withOpacity(0.3)
                          : MyColor.getPrimaryColor().withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.person,

                    color:
                        isCurrentNode
                            ? Colors.white
                            : MyColor.getPrimaryColor(),
                    size: isCurrentNode ? 24 : 20,


                ),
              ),
            ),
            SizedBox(height: 12),
          if (isCurrentNode) ...[
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

          ],
            Text(
              '@${node.username}',
              style: TextStyle(
                color:
                isCurrentNode
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
                color:
                    isCurrentNode
                        ? Colors.white.withOpacity(0.2)
                        : MyColor.getPrimaryColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                node.position.toUpperCase(),
                style: TextStyle(
                  color:
                      isCurrentNode ? Colors.white : MyColor.getPrimaryColor(),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 8),
            // Downline Count
    if (isCurrentNode) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                  Icon(
                    Icons.people_outline,
                    size: 16,
                    color:
                        isCurrentNode
                            ? Colors.white.withOpacity(0.8)
                            : MyColor.getTextColor().withOpacity(0.6),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${node.downlineCount}',
                    style: TextStyle(
                      color:
                          isCurrentNode
                              ? Colors.white.withOpacity(0.8)
                              : MyColor.getTextColor().withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

              ],
            ),]
            // if (onTap != null && node.downlineCount > 0) ...[
            //   SizedBox(height: 8),
            //   Container(
            //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            //     decoration: BoxDecoration(
            //       color: MyColor.getPrimaryColor().withOpacity(0.2),
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: Text(
            //       'Tap to explore',
            //       style: TextStyle(
            //         color: MyColor.getPrimaryColor(),
            //         fontSize: 10,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ),
            // ],
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
  Widget _buildBusinessMatrix() {
    return Obx(() {
      if (controller.treeNodes.isEmpty) return SizedBox();

      return Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MyColor.getCardBg(),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: MyColor.getPrimaryColor().withOpacity(0.2),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Business Matrix',
                  style: TextStyle(
                    color: MyColor.getPrimaryColor(),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Column(
                  children: [
                    _buildMatrixRow('Left', controller.treeResponse.value?.left ?? 0),
                    SizedBox(height: 12),
                    _buildMatrixRow('Middle', controller.treeResponse.value?.middle ?? 0),
                    SizedBox(height: 12),
                    _buildMatrixRow('Right', controller.treeResponse.value?.right ?? 0),
                    // _buildMatrixRow('Left', controller.treeNodes.firstWhereOrNull((node) => node.position == 'left')?.downlineCount ?? 0),
                    // SizedBox(height: 12),
                    // _buildMatrixRow('Middle', controller.treeNodes.firstWhereOrNull((node) => node.position == 'middle')?.downlineCount ?? 0),
                    // SizedBox(height: 12),
                    // _buildMatrixRow('Right', controller.treeNodes.firstWhereOrNull((node) => node.position == 'right')?.downlineCount ?? 0),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // // Add your image below the matrix card
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 16),
          //   child: Image.asset(
          //     'assets/images/img.PNG', // Replace with your actual asset path
          //     fit: BoxFit.cover,
          //   ),
          // ),
        ],
      );
    });
  }
  Widget _buildMatrixRow(String position, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Position ',
                style: TextStyle(
                  color: MyColor.getTextColor().withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              TextSpan(
                text: '($position)',
                style: TextStyle(
                  color: MyColor.getPrimaryColor(),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          decoration: BoxDecoration(
            color: MyColor.getPrimaryColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: MyColor.getPrimaryColor().withOpacity(0.3),
            ),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: MyColor.getPrimaryColor(),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class TreeConnectionPainter extends CustomPainter {
  final int nodeCount;
  final Color color;

  TreeConnectionPainter({required this.nodeCount, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withOpacity(0.3)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final topY = 0.0;
    final bottomY = size.height;
    final middleY = size.height / 2;

    // Draw vertical line from center top to middle
    canvas.drawLine(Offset(centerX, topY), Offset(centerX, middleY), paint);

    if (nodeCount > 0) {
      // Draw horizontal line
      final leftX = size.width * 0.17;
      final rightX = size.width * 0.83;

      canvas.drawLine(Offset(leftX, middleY), Offset(rightX, middleY), paint);

      // Draw vertical lines to child nodes
      final childPositions = [
        size.width * 0.17, // Left
        centerX, // Middle
        size.width * 0.83, // Right
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
