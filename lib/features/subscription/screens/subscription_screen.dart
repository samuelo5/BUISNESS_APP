import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:business_assistant/core/theme/app_theme.dart';
import 'package:business_assistant/providers/app_provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _selectedPlan = 'Pro';

  List<_Plan> _getPlans(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      _Plan(
        name: 'Free',
        price: 0,
        color: AppColors.textMuted,
        gradient: isDark
            ? [AppColors.darkCard, AppColors.darkSurface]
            : [AppColors.lightCard, AppColors.lightBg],
        features: const [
          '5 Content Generations',
          '20 Chat Replies',
          '3 Invoices',
          'Basic Insights',
          'Community Support',
        ],
        locked: const [
          'Unlimited AI Features',
          'Advanced Analytics',
          'Priority Support',
          'PDF Export',
          'Custom Branding',
        ],
      ),
      const _Plan(
        name: 'Pro',
        price: 10,
        color: AppColors.primary,
        gradient: AppColors.contentGradient,
        badge: 'Most Popular',
        features: [
          'Unlimited Content Generation',
          'Unlimited Chat Replies',
          'Unlimited Invoices',
          'Full Business Insights',
          'PDF Invoice Export',
          'Priority Email Support',
          'All Social Platforms',
        ],
        locked: [
          'Custom AI Branding',
          'Team Access (5 users)',
          'White-label Reports',
        ],
      ),
      const _Plan(
        name: 'Premium',
        price: 30,
        color: Color(0xFFFFD700),
        gradient: [Color(0xFFFFD700), Color(0xFFFF9500)],
        badge: 'Best Value',
        features: [
          'Everything in Pro',
          'Custom AI Branding',
          'Team Access (5 users)',
          'White-label Reports',
          'Dedicated Account Manager',
          'API Access',
          'Advanced Analytics Dashboard',
        ],
        locked: [],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 28),
                    _buildPlanTabs(context),
                    const SizedBox(height: 24),
                    _buildSelectedPlanCard(context),
                    const SizedBox(height: 24),
                    _buildFeatureList(context),
                    const SizedBox(height: 32),
                    _buildCTAButton(context),
                    const SizedBox(height: 16),
                    _buildAllPlansComparison(),
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

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_rounded,
                  color: Theme.of(context).iconTheme.color, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            Text(
              'Choose Your Plan',
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark,
                  fontSize: 26,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Unlock the full power of AI for your business',
          style:
              TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.5),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildPlanTabs(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.darkBorder 
              : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: _getPlans(context).map((plan) {
          final selected = plan.name == _selectedPlan;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPlan = plan.name),
              child: AnimatedContainer(
                duration: 200.ms,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: selected
                      ? LinearGradient(colors: plan.gradient)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        plan.name,
                        style: TextStyle(
                          color: selected 
                              ? (plan.name == 'Free' && Theme.of(context).brightness != Brightness.dark ? AppColors.textDark : Colors.white)
                              : AppColors.textMuted,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        plan.price == 0
                            ? 'Free'
                            : '\$${plan.price}/mo',
                        style: TextStyle(
                          color: selected
                              ? (plan.name == 'Free' && Theme.of(context).brightness != Brightness.dark ? AppColors.textDark.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.8))
                              : AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  _Plan _currentPlan(BuildContext context) =>
      _getPlans(context).firstWhere((p) => p.name == _selectedPlan);

  Widget _buildSelectedPlanCard(BuildContext context) {
    final plan = _currentPlan(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: plan.name == 'Free' ? Theme.of(context).cardTheme.color : null,
        gradient: plan.name == 'Free' ? null : LinearGradient(
          colors: plan.gradient.map((c) => c.withValues(alpha: 0.15)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: plan.name == 'Free' 
            ? (isDark ? AppColors.darkBorder : AppColors.lightBorder)
            : plan.color.withValues(alpha: 0.4), 
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (plan.badge != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: plan.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: plan.color.withValues(alpha: 0.5)),
              ),
              child: Text(
                plan.badge!,
                style: TextStyle(
                  color: plan.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                plan.price == 0 ? 'Free' : '\$${plan.price}',
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textDark,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              if (plan.price > 0)
                const Padding(
                  padding: EdgeInsets.only(bottom: 6, left: 4),
                  child: Text('/month',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 16)),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            plan.name == 'Free'
                ? 'Get started with essential tools'
                : plan.name == 'Pro'
                    ? 'Full AI power for growing businesses'
                    : 'Enterprise-grade tools for serious businesses',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    ).animate(key: ValueKey(_selectedPlan)).fadeIn(duration: 300.ms);
  }

  Widget _buildFeatureList(BuildContext context) {
    final plan = _currentPlan(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What\'s included',
            style: TextStyle(
                color: isDark ? Colors.white : AppColors.textDark,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        ...plan.features.map((f) => _featureRow(context, f, true, plan.color)),
        if (plan.locked.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('Not included',
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ...plan.locked.map((f) => _featureRow(context, f, false, AppColors.textMuted)),
        ],
      ],
    );
  }

  Widget _featureRow(BuildContext context, String text, bool included, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: included
                  ? color.withValues(alpha: 0.15)
                  : (isDark ? AppColors.darkCard : AppColors.lightBorder),
              shape: BoxShape.circle,
            ),
            child: Icon(
              included ? Icons.check_rounded : Icons.close_rounded,
              color: included ? color : AppColors.textMuted,
              size: 13,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: included 
                   ? (isDark ? Colors.white : AppColors.textDark)
                   : AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTAButton(BuildContext context) {
    final plan = _currentPlan(context);
    final provider = context.read<AppProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: plan.name == 'Free'
            ? null
            : () async {
                await provider.setSubscriptionPlan(plan.name);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '🎉 Welcome to ${plan.name}! Enjoy unlimited access.'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: plan.gradient),
            borderRadius: BorderRadius.circular(18),
            boxShadow: plan.name != 'Free'
                ? [
                    BoxShadow(
                      color: plan.color.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              plan.name == 'Free'
                  ? 'Current Plan'
                  : 'Subscribe to ${plan.name} — \$${plan.price}/mo',
              style: TextStyle(
                color: plan.name == 'Free' 
                    ? (isDark ? Colors.white : AppColors.textDark)
                    : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  Widget _buildAllPlansComparison() {
    return const Column(
      children: [
        Text(
          '✓ Cancel anytime  •  ✓ 7-day free trial  •  ✓ Secure payment',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted, fontSize: 12, height: 1.8),
        ),
      ],
    );
  }
}

class _Plan {
  final String name;
  final double price;
  final Color color;
  final List<Color> gradient;
  final String? badge;
  final List<String> features;
  final List<String> locked;

  const _Plan({
    required this.name,
    required this.price,
    required this.color,
    required this.gradient,
    this.badge,
    required this.features,
    required this.locked,
  });
}
