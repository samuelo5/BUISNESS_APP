import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:business_assistant/core/theme/app_theme.dart';

import 'package:business_assistant/providers/app_provider.dart';
import 'package:business_assistant/providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, provider),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlanBanner(context, provider),
                  const SizedBox(height: 28),
                  _buildStatsRow(context, provider),
                  const SizedBox(height: 28),
                  _buildSectionTitle(context, 'AI Tools'),
                  const SizedBox(height: 16),
                  _buildFeatureGrid(context),
                  const SizedBox(height: 28),
                  _buildSectionTitle(context, 'Today\'s Business Tip'),
                  const SizedBox(height: 16),
                  _buildTipCard(context, provider),

                  const SizedBox(height: 28),
                  _buildSectionTitle(context, 'Quick Actions'),
                  const SizedBox(height: 16),
                  _buildQuickActions(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppProvider provider) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';

    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: provider.isDarkMode ? AppColors.darkBg : AppColors.lightBg,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: provider.isDarkMode 
                  ? [AppColors.darkBg, AppColors.darkSurface]
                  : [AppColors.lightBg, AppColors.lightSurface],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
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
                                colors: [AppColors.primary, AppColors.accent],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.business_center_rounded,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BizAI Assistant',
                                style: TextStyle(
                                  color: (provider.isDarkMode ? Colors.white : AppColors.textDark).withValues(alpha: 0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                provider.businessName.isNotEmpty
                                    ? provider.businessName
                                    : 'My Business',
                                style: TextStyle(
                                  color: provider.isDarkMode ? Colors.white : AppColors.textDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              provider.isDarkMode
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode_rounded,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () => provider.toggleTheme(),
                          ),
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications_rounded,
                                    color: AppColors.textSecondary),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('🔔 No new notifications today!'),
                                      backgroundColor: provider.isDarkMode ? AppColors.darkCard : AppColors.lightCard,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  );
                                },

                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout_rounded,
                                color: AppColors.error),
                            onPressed: () => _showLogoutDialog(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '$greeting, ${provider.userName.isNotEmpty ? provider.userName.split(' ')[0] : 'Boss'}! 👋',
                    style: TextStyle(
                      color: provider.isDarkMode ? Colors.white : AppColors.textDark,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'What would you like to automate today?',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanBanner(BuildContext context, AppProvider provider) {
    if (provider.isPro) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              '${provider.subscriptionPlan} Plan Active — Unlimited Access',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/subscription'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upgrade to Pro',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Unlock unlimited AI features from \$10/mo',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white70, size: 14),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildStatsRow(BuildContext context, AppProvider provider) {
    return Row(
      children: [
        _statCard(context, 'Content\nGenerated',
            '${provider.contentGenerationsUsed}',
            Icons.auto_awesome_rounded,
            AppColors.primary),
        const SizedBox(width: 12),
        _statCard(context, 'Chats\nSent',
            '${provider.chatMessagesUsed}',
            Icons.chat_bubble_rounded,
            AppColors.accent),
        const SizedBox(width: 12),
        _statCard(context, 'Invoices\nCreated',
            '${provider.invoicesCreated}',
            Icons.receipt_long_rounded,
            AppColors.warning),
      ],
    );
  }

  Widget _statCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
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
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final features = [
      const _FeatureCard(
        icon: Icons.auto_awesome_rounded,
        title: 'Content\nGenerator',
        subtitle: 'Social posts & ads',
        gradient: AppColors.contentGradient,
        route: 1,
      ),
      const _FeatureCard(
        icon: Icons.chat_bubble_rounded,
        title: 'Chat\nAssistant',
        subtitle: 'Customer replies',
        gradient: AppColors.chatGradient,
        route: 2,
      ),
      const _FeatureCard(
        icon: Icons.receipt_long_rounded,
        title: 'Invoice\nGenerator',
        subtitle: 'Bills & receipts',
        gradient: AppColors.invoiceGradient,
        route: 3,
      ),
      const _FeatureCard(
        icon: Icons.insights_rounded,
        title: 'Smart\nInsights',
        subtitle: 'Growth tips',
        gradient: AppColors.insightsGradient,
        route: 4,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.1,
      ),
      itemCount: features.length,
      itemBuilder: (context, i) {
        return _buildFeatureTile(context, features[i], i);
      },
    );
  }

  Widget _buildFeatureTile(BuildContext context, _FeatureCard card, int index) {
    return GestureDetector(
        // Navigate by switching the global tab index
        onTap: () => context.read<AppProvider>().setTabIndex(card.route),

      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: card.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: card.gradient.first.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(card.icon, color: Colors.white, size: 26),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    card.subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
          .animate(delay: (index * 100).ms)
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.2),
    );
  }

  Widget _buildTipCard(BuildContext context, AppProvider provider) {
    if (provider.dailyTip.isEmpty) {
      provider.fetchDailyTip(); // Trigger background fetch
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark 
                ? AppColors.darkBorder 
                : AppColors.lightBorder
          ),
        ),
        child: const Row(
          children: [
            CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent),
            SizedBox(width: 16),
            Text(
              'Analyzing your business for tips...',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        ),

      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.darkBorder 
              : AppColors.lightBorder
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(Icons.lightbulb_rounded, color: AppColors.accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              provider.dailyTip,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }


  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        _quickBtn(
          context,
          Icons.add_rounded,
          'New Invoice',
          AppColors.warning,
          () => context.read<AppProvider>().setTabIndex(3),

        ),
        const SizedBox(width: 12),
        _quickBtn(
          context,
          Icons.settings_rounded,
          'Settings',
          AppColors.primary,
          () => Navigator.pushNamed(context, '/settings'),
        ),
        const SizedBox(width: 12),
        _quickBtn(
          context,
          Icons.star_rounded,
          'Go Pro',
          const Color(0xFFFFD700),
          () => Navigator.pushNamed(context, '/subscription'),
        ),
      ],
    );
  }

  Widget _quickBtn(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Sign Out', style: TextStyle(color: isDark ? Colors.white : AppColors.textDark)),
          content: const Text('Are you sure you want to sign out of BizAI?', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<AuthProvider>().signOut();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      );
      },
    );
  }
}

class _FeatureCard {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final int route;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.route,
  });
}
