import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:business_assistant/core/theme/app_theme.dart';
import 'package:business_assistant/core/constants/app_constants.dart';
import 'package:business_assistant/providers/app_provider.dart';

class ContentGeneratorScreen extends StatefulWidget {
  const ContentGeneratorScreen({super.key});

  @override
  State<ContentGeneratorScreen> createState() => _ContentGeneratorScreenState();
}

class _ContentGeneratorScreenState extends State<ContentGeneratorScreen> {
  final _topicCtrl = TextEditingController();
  String _selectedPlatform = AppConstants.socialPlatforms[0];
  String _selectedTone = AppConstants.toneOptions[0];
  String _generatedContent = '';
  bool _isGenerating = false;
  final List<String> _savedPosts = [];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(provider),
                    const SizedBox(height: 24),
                    _buildInputSection(provider),
                    const SizedBox(height: 20),
                    _buildPlatformPicker(),
                    const SizedBox(height: 20),
                    _buildTonePicker(),
                    const SizedBox(height: 28),
                    _buildGenerateButton(provider),
                    const SizedBox(height: 24),
                    if (_generatedContent.isNotEmpty) _buildOutputSection(),
                    if (_savedPosts.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      _buildSavedPosts(),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.contentGradient,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  'Content Generator',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            _usageBadge(
              provider.contentGenerationsUsed,
              provider.isPro
                  ? 999
                  : AppConstants.freeContentGenerations,
              provider.isPro,
              AppColors.primary,
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Generate high-quality social media posts, captions and ads in seconds.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _usageBadge(int used, int total, bool isPro, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        isPro ? '∞ Pro' : '$used/$total',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildInputSection(AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What\'s your topic or product?',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _topicCtrl,
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark, 
              fontSize: 15),
          maxLines: 3,
          decoration: const InputDecoration(
            hintText:
                'e.g. "Launching a new collection of handmade jewellery for women..."',
            hintStyle: TextStyle(
                color: AppColors.textMuted, fontSize: 14, height: 1.5),
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 44),
              child: Icon(Icons.edit_rounded, color: AppColors.primary, size: 20),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildPlatformPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Platform',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: AppConstants.socialPlatforms.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final p = AppConstants.socialPlatforms[i];
              final isSelected = p == _selectedPlatform;
              return GestureDetector(
                onTap: () => setState(() => _selectedPlatform = p),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(colors: AppColors.contentGradient)
                        : null,
                    color: isSelected ? null : Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : (Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    p,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textMuted,
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 150.ms);
  }

  Widget _buildTonePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tone',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.toneOptions.map((tone) {
            final isSelected = tone == _selectedTone;
            return GestureDetector(
              onTap: () => setState(() => _selectedTone = tone),
              child: AnimatedContainer(
                duration: 200.ms,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                child: Text(
                  tone,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  Widget _buildGenerateButton(AppProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isGenerating ? null : () => _generate(provider),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: EdgeInsets.zero,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.contentGradient),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: _isGenerating
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'AI is writing...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome_rounded,
                          color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Generate Content',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 250.ms);
  }

  Widget _buildOutputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Generated Content',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                _iconBtn(context, Icons.copy_rounded, 'Copy', () {
                  Clipboard.setData(ClipboardData(text: _generatedContent));
                  _showSnack('Copied to clipboard!');
                }),
                const SizedBox(width: 8),
                _iconBtn(context, Icons.bookmark_add_rounded, 'Save', () {
                  setState(() => _savedPosts.insert(0, _generatedContent));
                  _showSnack('Post saved!');
                }),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Text(
            _generatedContent,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark,
              fontSize: 15,
              height: 1.7,
            ),
          ),
        ).animate().fadeIn(duration: 500.ms).scale(
              begin: const Offset(0.95, 0.95),
              curve: Curves.easeOut,
            ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _generate(context.read<AppProvider>()),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Regenerate'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? AppColors.darkBorder 
                        : AppColors.lightBorder
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSavedPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saved Posts',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(_savedPosts.length, (i) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? AppColors.darkBorder 
                    : AppColors.lightBorder
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _savedPosts[i],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _iconBtn(context, Icons.copy_rounded, '', () {
                      Clipboard.setData(ClipboardData(text: _savedPosts[i]));
                      _showSnack('Copied!');
                    }),
                    _iconBtn(context, Icons.delete_rounded, '', () {
                      setState(() => _savedPosts.removeAt(i));
                    }),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _iconBtn(BuildContext context, IconData icon, String tooltip, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      tooltip: tooltip,
      icon: Icon(icon, size: 18, color: AppColors.textSecondary),
      style: IconButton.styleFrom(
        backgroundColor: (Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder).withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _generate(AppProvider provider) async {
    if (_topicCtrl.text.trim().isEmpty) {
      _showSnack('Please enter a topic first');
      return;
    }
    if (!provider.canGenerateContent) {
      _showUpgradeDialog();
      return;
    }

    setState(() {
      _isGenerating = true;
      _generatedContent = '';
    });

    try {
      final content = await provider.generateContent(
        topic: _topicCtrl.text.trim(),
        platform: _selectedPlatform,
        tone: _selectedTone,
      );

      setState(() {
        _generatedContent = content;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() => _isGenerating = false);
      _showSnack('AI is having a moment. Please try again.');
    }
  }


  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : AppColors.lightCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('Limit Reached', style: TextStyle(color: isDark ? Colors.white : AppColors.textDark)),
          content: const Text(
            'You\'ve used all ${AppConstants.freeContentGenerations} free generations. Upgrade to Pro for unlimited access.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Later', style: TextStyle(color: AppColors.textMuted)),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/subscription');
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      );
      },
    );
  }
}
