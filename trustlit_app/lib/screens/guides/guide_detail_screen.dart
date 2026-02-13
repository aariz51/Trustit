import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/guide_model.dart';

/// Guide Detail Screen - Displays full guide content with sections
/// Matches the client's reference design: back arrow + title at top,
/// guide image below, scrollable content, green "Back" button at bottom.
class GuideDetailScreen extends StatelessWidget {
  final String guideId;

  const GuideDetailScreen({super.key, required this.guideId});

  @override
  Widget build(BuildContext context) {
    final guide = allGuides.firstWhere(
      (g) => g.id == guideId,
      orElse: () => allGuides.first,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      // Simple top bar with back arrow and title
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A1A1A), size: 20),
          onPressed: () => context.go('/guides'),
        ),
        title: Text(
          guide.title,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Guide image at top (if available)
            if (guide.imagePath != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    guide.imagePath!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            guide.emoji,
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Subtitle / intro
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Text(
                guide.subtitle,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                  height: 1.3,
                ),
              ),
            ),

            // Sections
            ...guide.sections.map((section) => _SectionWidget(section: section)),

            // Green "Back" button at the end of content
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go('/guides'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionWidget extends StatelessWidget {
  final GuideSection section;

  const _SectionWidget({required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section heading (bold uppercase)
          if (section.heading.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              section.heading,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Section content
          _RichContentText(content: section.content),
        ],
      ),
    );
  }
}

/// Widget that parses simple markdown-like bold (**text**) and bullet points
class _RichContentText extends StatelessWidget {
  final String content;

  const _RichContentText({required this.content});

  @override
  Widget build(BuildContext context) {
    final lines = content.split('\n');
    final List<Widget> widgets = [];

    for (final line in lines) {
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      // Bullet point
      if (line.trim().startsWith('•')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 15, color: Color(0xFF1A1A1A))),
                Expanded(
                  child: Text(
                    line.trim().substring(1).trim(),
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 15,
                      color: Colors.grey.shade800,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        continue;
      }

      // Bold heading within section (**text**)
      if (line.trim().startsWith('**') && line.trim().endsWith('**')) {
        final boldText = line.trim().replaceAll('**', '');
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              boldText,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
                height: 1.4,
              ),
            ),
          ),
        );
        continue;
      }

      // Lines with inline bold (**text** — description)
      if (line.contains('**')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _buildInlineBold(line),
          ),
        );
        continue;
      }

      // Regular text
      widgets.add(
        Text(
          line,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 15,
            color: Colors.grey.shade800,
            height: 1.6,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildInlineBold(String text) {
    final List<TextSpan> spans = [];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: TextStyle(color: Colors.grey.shade800),
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A1A),
        ),
      ));
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: TextStyle(color: Colors.grey.shade800),
      ));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 15,
          height: 1.6,
        ),
        children: spans,
      ),
    );
  }
}
