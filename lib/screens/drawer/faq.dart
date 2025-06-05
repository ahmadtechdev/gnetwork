import 'package:flutter/material.dart';
import 'package:gcoin/utils/app_colors.dart';
import 'package:get/get.dart';

// Assuming you have your MyColor class imported
// import 'package:gcoin/theme_controller.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  List<FAQItem> _allFAQs = [];
  List<FAQItem> _filteredFAQs = [];
  Set<int> _expandedItems = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _initializeFAQs();
    _filteredFAQs = _allFAQs;
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _initializeFAQs() {
    _allFAQs = [
      FAQItem(
        category: "Getting Started",
        question: "What is G Coin and how does it work?",
        answer: "G Coin is a revolutionary cryptocurrency platform that provides secure, fast, and low-cost digital transactions. Built on advanced blockchain technology, G Coin offers instant peer-to-peer transfers, smart contract capabilities, and a user-friendly mobile wallet experience.",
      ),
      FAQItem(
        category: "Getting Started",
        question: "How do I create a G Coin wallet?",
        answer: "Creating a G Coin wallet is simple! Download our mobile app, tap 'Create New Wallet', securely store your recovery phrase, set up biometric authentication, and verify your email. Your wallet will be ready to use immediately with industry-leading security features.",
      ),
      FAQItem(
        category: "Security",
        question: "How secure is my G Coin wallet?",
        answer: "Your G Coin wallet uses military-grade encryption, multi-signature authentication, and biometric security. We employ cold storage for the majority of funds, regular security audits, and advanced fraud detection systems to keep your assets safe.",
      ),
      FAQItem(
        category: "Security",
        question: "What should I do if I lose my recovery phrase?",
        answer: "Your recovery phrase is the only way to restore your wallet. If lost, we cannot recover your funds as we don't store your private keys. Always write down your recovery phrase, store it in multiple secure locations, and never share it with anyone.",
      ),
      FAQItem(
        category: "Transactions",
        question: "How long do G Coin transactions take?",
        answer: "G Coin transactions are lightning fast! Most transfers complete within 3-5 seconds on our network. Cross-chain transactions may take 1-2 minutes depending on network congestion and the destination blockchain.",
      ),
      FAQItem(
        category: "Transactions",
        question: "What are the transaction fees?",
        answer: "G Coin offers some of the lowest fees in the crypto space. Standard transactions cost less than \$0.01, while complex smart contract interactions typically cost under \$0.10. We believe in accessible crypto for everyone.",
      ),
      FAQItem(
        category: "Trading",
        question: "Can I trade G Coin on exchanges?",
        answer: "Yes! G Coin is listed on major cryptocurrency exchanges including Binance, Coinbase, Kraken, and KuCoin. You can also trade directly within our app using our built-in DEX aggregator for the best rates.",
      ),
      FAQItem(
        category: "Trading",
        question: "How do I buy G Coin with fiat currency?",
        answer: "You can purchase G Coin directly in our app using credit/debit cards, bank transfers, or popular payment methods like PayPal and Apple Pay. We support over 50 fiat currencies with competitive rates and instant processing.",
      ),
      FAQItem(
        category: "Support",
        question: "How can I contact customer support?",
        answer: "Our support team is available 24/7 through multiple channels: in-app chat support, email at support@gcoin.app, or phone at +1-800-GCOIN-24. We typically respond to inquiries within 30 minutes during business hours.",
      ),
      FAQItem(
        category: "Advanced",
        question: "Does G Coin support DeFi protocols?",
        answer: "Absolutely! G Coin is fully compatible with major DeFi protocols. You can stake, provide liquidity, participate in yield farming, and access lending platforms directly through our integrated DeFi hub with optimized gas fees.",
      ),
    ];
  }

  void _filterFAQs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFAQs = _allFAQs;
      } else {
        _filteredFAQs = _allFAQs.where((faq) =>
          faq.question.toLowerCase().contains(query.toLowerCase()) ||
          faq.answer.toLowerCase().contains(query.toLowerCase()) ||
          faq.category.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  void _toggleExpansion(int index) {
    setState(() {
      if (_expandedItems.contains(index)) {
        _expandedItems.remove(index);
      } else {
        _expandedItems.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(),
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildSearchSection(),
            _buildCategoriesFilter(),
            Expanded(child: _buildFAQList()),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: MyColor.getAppbarBgColor(),
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: MyColor.getAppbarTitleColor(),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'FAQ',
        style: TextStyle(
          color: MyColor.getAppbarTitleColor(),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: MyColor.getGCoinPrimaryGradient(),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How can we help you?',
            style: TextStyle(
              color: MyColor.getHeadingTextColor(),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search for answers or browse categories below',
            style: TextStyle(
              color: MyColor.getSecondaryTextColor(),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: MyColor.getGCoinCardColor(),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: MyColor.getGCoinDividerColor(),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: MyColor.getGCoinShadowColor(),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _filterFAQs,
              style: TextStyle(color: MyColor.getTextColor()),
              decoration: InputDecoration(
                hintText: 'Search FAQ...',
                hintStyle: TextStyle(color: MyColor.getTextFieldHintColor()),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: MyColor.getGCoinPrimaryColor(),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: MyColor.getTextFieldHintColor(),
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _filterFAQs('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesFilter() {
    final categories = _allFAQs.map((faq) => faq.category).toSet().toList();
    
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCategoryChip('All', true);
          }
          return _buildCategoryChip(categories[index - 1], false);
        },
      ),
    );
  }

  Widget _buildCategoryChip(String category, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: FilterChip(
        label: Text(
          category,
          style: TextStyle(
            color: isSelected 
                ? MyColor.colorWhite 
                : MyColor.getTextColor(),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          // Handle category filtering
        },
        backgroundColor: MyColor.getGCoinCardColor(),
        selectedColor: MyColor.getGCoinPrimaryColor(),
        checkmarkColor: MyColor.colorWhite,
        side: BorderSide(
          color: isSelected 
              ? MyColor.getGCoinPrimaryColor() 
              : MyColor.getGCoinDividerColor(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildFAQList() {
    if (_filteredFAQs.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filteredFAQs.length,
      itemBuilder: (context, index) {
        return _buildFAQItem(_filteredFAQs[index], index);
      },
    );
  }

  Widget _buildFAQItem(FAQItem faq, int index) {
    final isExpanded = _expandedItems.contains(index);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: MyColor.getGCoinCardColor(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded 
              ? MyColor.getGCoinPrimaryColor() 
              : MyColor.getGCoinDividerColor(),
          width: isExpanded ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColor.getGCoinShadowColor(),
            blurRadius: isExpanded ? 15 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleExpansion(index),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: MyColor.getGCoinPrimaryColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      faq.category,
                      style: TextStyle(
                        color: MyColor.getGCoinPrimaryColor(),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      faq.question,
                      style: TextStyle(
                        color: MyColor.getHeadingTextColor(),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: MyColor.getGCoinPrimaryColor(),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: MyColor.getGCoinDividerColor(),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          faq.answer,
                          style: TextStyle(
                            color: MyColor.getSecondaryTextColor(),
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              'Was this helpful?',
                              style: TextStyle(
                                color: MyColor.getTextFieldHintColor(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildHelpfulButton(Icons.thumb_up_rounded, true),
                            const SizedBox(width: 8),
                            _buildHelpfulButton(Icons.thumb_down_rounded, false),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpfulButton(IconData icon, bool isPositive) {
    return InkWell(
      onTap: () {
        // Handle feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isPositive ? 'Thank you for your feedback!' : 'We\'ll improve this answer',
            ),
            backgroundColor: MyColor.getGCoinPrimaryColor(),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: MyColor.getGCoinPrimaryColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          size: 16,
          color: MyColor.getGCoinPrimaryColor(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: MyColor.getGCoinPrimaryColor().withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: MyColor.getGCoinPrimaryColor(),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No results found',
            style: TextStyle(
              color: MyColor.getHeadingTextColor(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms',
            style: TextStyle(
              color: MyColor.getSecondaryTextColor(),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              _filterFAQs('');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColor.getGCoinPrimaryColor(),
              foregroundColor: MyColor.colorWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text(
              'Clear Search',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String category;
  final String question;
  final String answer;

  FAQItem({
    required this.category,
    required this.question,
    required this.answer,
  });
}

