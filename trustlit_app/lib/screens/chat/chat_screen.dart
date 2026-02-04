import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

/// Chat Screen - Based on 20.png, 29.png
/// AI Expert chat interface
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(ChatMessage(
      text:
          'Hello! I\'m your AI Health Expert. Ask me anything about ingredients, products, or health-related questions.',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 20,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'AI Expert',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _clearChat,
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[_messages.length - 1 - index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),

          // Input Field
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 40,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'AI Expert Ready',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ask me anything about\ningredients and health',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              color: AppColors.textGray,
            ),
          ),
          const SizedBox(height: 24),
          // Suggestion Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildSuggestionChip('What is BHT?'),
              _buildSuggestionChip('Is sugar bad?'),
              _buildSuggestionChip('Safe preservatives'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () => _sendMessage(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 13,
            color: AppColors.textDarkGray,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 16,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppColors.primaryGreen
                    : AppColors.lightGray,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft:
                      message.isUser ? const Radius.circular(16) : Radius.zero,
                  bottomRight:
                      message.isUser ? Radius.zero : const Radius.circular(16),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  color: message.isUser ? AppColors.white : AppColors.textBlack,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.lightGray,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 16,
                color: AppColors.textGray,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Ask about ingredients...',
                  hintStyle: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    color: AppColors.textLightGray,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _sendMessage(value);
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              if (_messageController.text.isNotEmpty) {
                _sendMessage(_messageController.text);
              }
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: AppColors.white,
                      size: 22,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
      _isLoading = true;
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: _getAIResponse(text),
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
        });
      }
    });
  }

  String _getAIResponse(String question) {
    // Mock AI responses - will be replaced with actual API call
    final lowerQuestion = question.toLowerCase();

    if (lowerQuestion.contains('bht')) {
      return 'BHT (Butylated Hydroxytoluene) is a synthetic antioxidant used as a preservative in foods and cosmetics. While it prevents oxidation and extends shelf life, some studies suggest potential health concerns at high doses. It\'s classified as "generally recognized as safe" by the FDA, but many health-conscious consumers prefer products without it.';
    }
    if (lowerQuestion.contains('sugar')) {
      return 'Excessive sugar consumption can lead to various health issues including weight gain, increased risk of type 2 diabetes, heart disease, and tooth decay. The World Health Organization recommends limiting added sugars to less than 10% of daily energy intake. When checking products, look for hidden sugars under names like glucose, fructose, and corn syrup.';
    }
    if (lowerQuestion.contains('preservative')) {
      return 'Some safer preservative alternatives include: Vitamin E (tocopherols), Rosemary extract, Citric acid, and Sodium benzoate (in low concentrations). These natural or food-grade preservatives are generally considered safer than synthetic options like BHA and BHT.';
    }

    return 'That\'s a great question! Based on scientific research, I recommend checking the ingredient list carefully and looking for products with simpler, more natural formulations. Would you like me to analyze a specific ingredient or product for you?';
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Clear Chat',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Are you sure you want to clear all messages?',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            color: AppColors.textGray,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: AppColors.textGray,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(ChatMessage(
                  text:
                      'Hello! I\'m your AI Health Expert. Ask me anything about ingredients, products, or health-related questions.',
                  isUser: false,
                  timestamp: DateTime.now(),
                ));
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
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

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
