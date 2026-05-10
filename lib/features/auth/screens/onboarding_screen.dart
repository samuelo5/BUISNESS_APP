import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:business_assistant/core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardPage> _pages = [
    const _OnboardPage(
      icon: Icons.auto_awesome_rounded,
      color: AppColors.primary,
      secondaryColor: AppColors.primaryLight,
      title: 'Welcome to BizAI',
      subtitle: 'Your all-in-one AI-powered\nbusiness assistant',
      description:
          'Automate your daily business tasks with the power of artificial intelligence. Save time, increase productivity, and grow your business.',
    ),
    const _OnboardPage(
      icon: Icons.edit_note_rounded,
      color: AppColors.accent,
      secondaryColor: AppColors.accentLight,
      title: 'Generate Content Instantly',
      subtitle: 'AI-powered social media\nposts and captions',
      description:
          'Create high-quality marketing content for Instagram, Facebook, LinkedIn and more — all in seconds.',
    ),
    const _OnboardPage(
      icon: Icons.chat_bubble_rounded,
      color: Color(0xFFFF6B9D),
      secondaryColor: Color(0xFFFFB3CC),
      title: 'Smart Chat Replies',
      subtitle: 'Never leave a customer\nmessage unanswered',
      description:
          'Generate professional, context-aware replies to customer messages instantly. Boost satisfaction and close more sales.',
    ),
    const _OnboardPage(
      icon: Icons.receipt_long_rounded,
      color: AppColors.warning,
      secondaryColor: Color(0xFFFFD699),
      title: 'Create Invoices Fast',
      subtitle: 'Professional invoices\nin under a minute',
      description:
          'Generate, customize, and share professional invoices and receipts with your clients effortlessly.',
    ),
    const _OnboardPage(
      icon: Icons.insights_rounded,
      color: Color(0xFF5DADE2),
      secondaryColor: Color(0xFFADD8F2),
      title: 'Smart Business Insights',
      subtitle: 'AI-powered tips to\ngrow your revenue',
      description:
          'Get personalized business growth strategies, marketing tips, and actionable insights based on your activity.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkBg,
                  AppColors.darkSurface,
                  AppColors.darkCard.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          // Stars/particles background
          ..._buildStars(),
          // Content
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _pages.length,
                  itemBuilder: (_, i) => _buildPage(_pages[i], i),
                ),
              ),
              _buildBottom(),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStars() {
    final positions = [
      [0.1, 0.05], [0.85, 0.1], [0.3, 0.15], [0.7, 0.08], [0.5, 0.03],
      [0.15, 0.25], [0.9, 0.3], [0.05, 0.4], [0.95, 0.5], [0.2, 0.6],
    ];
    return positions.map((p) {
      return Positioned(
        left: MediaQuery.of(context).size.width * p[0],
        top: MediaQuery.of(context).size.height * p[1],
        child: Container(
          width: 3,
          height: 3,
          decoration: const BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
        ),
      );
    }).toList();
  }

  Widget _buildPage(_OnboardPage page, int index) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            // Icon container
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [page.color, page.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: page.color.withValues(alpha: 0.4),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(page.icon, size: 70, color: Colors.white),
            )
                .animate(key: ValueKey('icon_$index'))
                .scale(
                  begin: const Offset(0.5, 0.5),
                  duration: 500.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 48),
            Text(
              page.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            )
                .animate(key: ValueKey('title_$index'))
                .slideY(begin: 0.3, duration: 400.ms, curve: Curves.easeOut)
                .fadeIn(duration: 400.ms, delay: 100.ms),
            const SizedBox(height: 12),
            Text(
              page.subtitle,
              style: TextStyle(
                color: page.color,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            )
                .animate(key: ValueKey('sub_$index'))
                .slideY(begin: 0.3, duration: 400.ms, curve: Curves.easeOut)
                .fadeIn(duration: 400.ms, delay: 150.ms),
            const SizedBox(height: 20),
            Text(
              page.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            )
                .animate(key: ValueKey('desc_$index'))
                .slideY(begin: 0.3, duration: 400.ms, curve: Curves.easeOut)
                .fadeIn(duration: 400.ms, delay: 200.ms),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
      child: Column(
        children: [
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (i) {
              final isActive = i == _currentPage;
              return AnimatedContainer(
                duration: 300.ms,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.textMuted,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 32),
          // Action button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < _pages.length - 1) {
                  _controller.nextPage(
                    duration: 400.ms,
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pushReplacementNamed(context, '/signup');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: AppColors.primaryLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _OnboardPage {
  final IconData icon;
  final Color color;
  final Color secondaryColor;
  final String title;
  final String subtitle;
  final String description;

  const _OnboardPage({
    required this.icon,
    required this.color,
    required this.secondaryColor,
    required this.title,
    required this.subtitle,
    required this.description,
  });
}
