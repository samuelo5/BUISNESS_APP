import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:business_assistant/core/theme/app_theme.dart';
import 'package:business_assistant/providers/app_provider.dart';
import 'package:business_assistant/features/subscription/screens/paystack_payment_screen.dart';

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
                    _buildAllPlansComparison(context),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              'Pricing Plans',
              style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textDark,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the perfect plan for your business',
          style: TextStyle(
            color: isDark ? AppColors.textSecondary : AppColors.textDark,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanTabs(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
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
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        plan.name,
                        style: TextStyle(
                          color: selected 
                              ? Colors.white
                              : (Theme.of(context).brightness == Brightness.dark ? AppColors.textMuted : AppColors.textDark),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        plan.price == 0
                            ? 'Free'
                            : '\$${plan.price}/mo',
                        style: TextStyle(
                          color: selected
                              ? Colors.white.withValues(alpha: 0.85)
                              : (Theme.of(context).brightness == Brightness.dark ? AppColors.textMuted : AppColors.textDark),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
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
    );
  }

  _Plan _currentPlan(BuildContext context) =>
      _getPlans(context).firstWhere((p) => p.name == _selectedPlan);

  Widget _buildSelectedPlanCard(BuildContext context) {
    final plan = _currentPlan(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: plan.name == 'Free' 
            ? (isDark ? AppColors.darkBorder : AppColors.lightBorder)
            : AppColors.primary, 
          width: plan.name == 'Free' ? 1 : 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (plan.badge != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                plan.badge!,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              if (plan.price > 0)
                const Padding(
                  padding: EdgeInsets.only(bottom: 4, left: 6),
                  child: Text('/month',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 14)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            plan.name == 'Free'
                ? 'Get started with essential tools'
                : plan.name == 'Pro'
                    ? 'For growing businesses'
                    : 'For scaling enterprises',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
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
          Text('Not included',
              style: TextStyle(
                  color: isDark ? AppColors.textMuted : AppColors.textDark,
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
                   : (isDark ? AppColors.textMuted : AppColors.textDark.withValues(alpha: 0.6)),
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
                // Show payment method dialog or proceed with Paystack
                _showPaymentDialog(context, plan.name, plan.price);
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: plan.name == 'Free' ? AppColors.textMuted.withValues(alpha: 0.3) : AppColors.primary,
          foregroundColor: Colors.white,
          disabledForegroundColor: AppColors.textMuted,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Center(
          child: Text(
            plan.name == 'Free'
                ? 'Current Plan'
                : 'Subscribe to ${plan.name}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, String planName, double price) {
    final emailController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Subscribe to $planName',
          style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${price.toStringAsFixed(2)}/month',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: isDark ? Colors.white : AppColors.textDark),
              decoration: InputDecoration(
                hintText: 'Enter your email',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : AppColors.lightBg,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter your email')),
                );
                return;
              }

              Navigator.pop(dialogContext);
              
              // Navigate to Paystack payment screen
              if (context.mounted) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaystackPaymentScreen(
                      plan: planName,
                      amount: price,
                      userEmail: emailController.text,
                    ),
                  ),
                );

                if (result == true && context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '🎉 Welcome to $planName! Enjoy unlimited access.',
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              }
            },
            child: const Text('Proceed to Payment'),
          ),
        ],
      ),
    );
  }

  Widget _buildAllPlansComparison(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Text(
          '✓ Cancel anytime  •  ✓ 7-day free trial  •  ✓ Secure payment',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? AppColors.textMuted : AppColors.textDark.withValues(alpha: 0.7),
            fontSize: 12,
            height: 1.8,
          ),
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
