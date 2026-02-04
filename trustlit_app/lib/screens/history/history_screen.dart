import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/scan_history_provider.dart';
import '../../models/scan_history_model.dart';

/// History Screen - Based on 17.png, 18.png, 19.png, 24.png, 25.png, 26.png
/// Shows empty state or list of scanned products with swipe-to-delete
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'History',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        actions: [
          Consumer<ScanHistoryProvider>(
            builder: (context, provider, _) {
              if (provider.isEmpty) return const SizedBox();
              return IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: AppColors.textGray,
                ),
                onPressed: () => _showClearAllDialog(context),
              );
            },
          ),
        ],
      ),
      body: Consumer<ScanHistoryProvider>(
        builder: (context, provider, _) {
          if (provider.isEmpty) {
            return _buildEmptyState();
          }
          return _buildHistoryList(context, provider.history);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history,
              size: 48,
              color: AppColors.textLightGray,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Scan History Yet',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start scanning products to see\nyour history here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context, List<ScanHistoryModel> history) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return _buildHistoryItem(context, item);
      },
    );
  }

  Widget _buildHistoryItem(BuildContext context, ScanHistoryModel item) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.deleteRed,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete,
              color: AppColors.white,
            ),
            const SizedBox(width: 8),
            Text(
              'Delete',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) => _showDeleteConfirmDialog(context),
      onDismissed: (direction) {
        context.read<ScanHistoryProvider>().removeScan(item.id);
      },
      child: GestureDetector(
        onTap: () {
          context.push('/analysis', extra: {'analysisId': item.id});
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Product Thumbnail
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: item.thumbnailPath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          item.thumbnailPath!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.image,
                            color: AppColors.textLightGray,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.shopping_bag,
                        color: AppColors.textLightGray,
                      ),
              ),
              const SizedBox(width: 12),
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getRatingColor(item.overallScore)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.ratingLabel,
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _getRatingColor(item.overallScore),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: AppColors.textLightGray,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTimeAgo(item.scannedAt),
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 11,
                            color: AppColors.textLightGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Score Circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getRatingColor(item.overallScore),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    item.overallScore.toString(),
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getRatingColor(item.overallScore),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textLightGray,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRatingColor(int score) {
    return AppColors.getScoreColor(score);
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} minutes ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return '${(difference.inDays / 7).floor()} weeks ago';
  }

  Future<bool> _showDeleteConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Delete Item',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
            content: Text(
              'Are you sure you want to delete this item?',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                color: AppColors.textGray,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: AppColors.textGray,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: AppColors.deleteRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Clear All History',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        content: Text(
          'Are you sure you want to delete all scan history?',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            color: AppColors.textGray,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: AppColors.textGray,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<ScanHistoryProvider>().clearHistory();
              Navigator.pop(context);
            },
            child: Text(
              'Delete All',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: AppColors.deleteRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
