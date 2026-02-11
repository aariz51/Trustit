import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/guide_model.dart';

/// Guide Detail Screen - Displays full guide content with sections
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar with gradient header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF22C55E),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => context.go('/guides'),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF22C55E),
                      Color(0xFF16A34A),
                      Color(0xFF15803D),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Emoji icon
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            guide.emoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Title
                        Text(
                          guide.title,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.25,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Subtitle
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                guide.subtitle,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ),
          ),

          // Divider
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(height: 24),
            ),
          ),

          // Content Sections
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final section = guide.sections[index];
                return _SectionWidget(section: section);
              },
              childCount: guide.sections.length,
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section heading
          if (section.heading.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                section.heading,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF15803D),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Section content - parse bold markers
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
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Icon(Icons.circle, size: 6, color: Color(0xFF22C55E)),
                ),
                const SizedBox(width: 10),
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
                fontSize: 16,
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
