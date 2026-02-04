import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// History Screen - Matches designs 14, 24-26.png
/// Shows scan history empty state with clock icon or list of scanned products
/// Includes swipe-to-delete with confirmation dialog
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Sample data - will be replaced with actual data from provider
  final List<HistoryItem> _historyItems = [
    HistoryItem(
      id: '1',
      productName: 'Treasure Chipotle A...',
      category: 'Sauce',
      score: 3,
      riskLevel: 'Bad',
      riskColor: const Color(0xFFEF4444),
      scannedAt: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
    HistoryItem(
      id: '2',
      productName: 'CHOCOLATE SYRUP',
      category: 'Dessert',
      score: 15,
      riskLevel: 'Bad',
      riskColor: const Color(0xFFEF4444),
      scannedAt: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    HistoryItem(
      id: '3',
      productName: 'PHILADELPHIA CRE...',
      category: 'Dairy',
      score: 95,
      riskLevel: 'Excellent',
      riskColor: const Color(0xFF22C55E),
      scannedAt: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    HistoryItem(
      id: '4',
      productName: 'Cremeux Légè Pean...',
      category: 'Spread',
      score: 60,
      riskLevel: 'Average',
      riskColor: const Color(0xFFF59E0B),
      scannedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    HistoryItem(
      id: '5',
      productName: 'Natrel Fine-filtered ...',
      category: 'Dairy',
      score: 65,
      riskLevel: 'Average',
      riskColor: const Color(0xFFF59E0B),
      scannedAt: DateTime.now().subtract(const Duration(minutes: 6)),
    ),
    HistoryItem(
      id: '6',
      productName: 'Great Value Corn Fl...',
      category: 'Cereal',
      score: 45,
      riskLevel: 'Medium',
      riskColor: const Color(0xFFF59E0B),
      scannedAt: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'History',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFF9CA3AF)),
            onPressed: _historyItems.isEmpty ? null : _showClearAllDialog,
          ),
        ],
      ),
      body: _historyItems.isEmpty
          ? _buildEmptyState()
          : _buildHistoryList(),
    );
  }

  /// Empty state - matches design 14.png exactly
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Clock icon in green circle
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_rounded,
              size: 48,
              color: Color(0xFF22C55E),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          const Text(
            'No Scan History Yet',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Start scanning products to see\nyour analysis history here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                color: Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// History list view - matches design 24-25.png
  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _historyItems.length,
      itemBuilder: (context, index) {
        final item = _historyItems[index];
        return Dismissible(
          key: Key(item.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            color: const Color(0xFFEF4444),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.delete, color: Colors.white),
                const SizedBox(width: 8),
                const Text(
                  'Delete',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          confirmDismiss: (direction) => _showDeleteConfirmDialog(item),
          onDismissed: (direction) => _deleteItem(item),
          child: _HistoryListItem(
            item: item,
            onTap: () => context.push('/analysis/${item.id}'),
          ),
        );
      },
    );
  }

  Future<bool?> _showDeleteConfirmDialog(HistoryItem item) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Item',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this item?',
          style: TextStyle(fontFamily: 'Outfit'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteItem(HistoryItem item) {
    setState(() {
      _historyItems.removeWhere((i) => i.id == item.id);
    });
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Clear All History',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete all scan history?',
          style: TextStyle(fontFamily: 'Outfit'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _historyItems.clear();
              });
            },
            child: const Text(
              'Delete All',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// History Item Data Model
class HistoryItem {
  final String id;
  final String productName;
  final String category;
  final int score;
  final String riskLevel;
  final Color riskColor;
  final DateTime scannedAt;
  final String? imageUrl;

  const HistoryItem({
    required this.id,
    required this.productName,
    required this.category,
    required this.score,
    required this.riskLevel,
    required this.riskColor,
    required this.scannedAt,
    this.imageUrl,
  });
}

/// History list item - matches design 24.png exactly
class _HistoryListItem extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback onTap;

  const _HistoryListItem({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF3F4F6)),
          ),
        ),
        child: Row(
          children: [
            // Product thumbnail
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 24,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(width: 12),

            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: item.riskColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.riskLevel,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          color: item.riskColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(item.scannedAt),
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),

            // Score circle
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: item.riskColor,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  '${item.score}',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: item.riskColor,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else {
      return '${diff.inDays} days ago';
    }
  }
}
