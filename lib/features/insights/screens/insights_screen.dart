import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:business_assistant/core/theme/app_theme.dart';
import 'package:business_assistant/core/constants/app_constants.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  Widget build(BuildContext context) {
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
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildScoreCard(),
                    const SizedBox(height: 28),
                    _buildSectionTitle('Weekly Activity'),
                    const SizedBox(height: 16),
                    _buildChart(),
                    const SizedBox(height: 28),
                    _buildSectionTitle('AI Business Tips'),
                    const SizedBox(height: 16),
                    _buildTipCards(),
                    const SizedBox(height: 28),
                    _buildSectionTitle('Growth Checklist'),
                    const SizedBox(height: 16),
                    _buildChecklist(),
                    const SizedBox(height: 28),
                    _buildSectionTitle('Key Metrics'),
                    const SizedBox(height: 16),
                    _buildMetrics(),
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

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.insightsGradient),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.auto_awesome_rounded,
              color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Smart Insights',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800)),
            Text('AI-powered growth strategies for you',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildScoreCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E2440), Color(0xFF252D50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.darkBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Business Score',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('74',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 52,
                            fontWeight: FontWeight.w900,
                            height: 1)),
                    const Text('/100',
                        style: TextStyle(
                            color: AppColors.textMuted, fontSize: 18)),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.trending_up_rounded,
                              color: AppColors.success, size: 14),
                          SizedBox(width: 4),
                          Text('+12%',
                              style: TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 0.74,
                    backgroundColor: AppColors.darkBorder,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Good progress! Keep building your presence.',
                  style:
                      TextStyle(color: AppColors.textMuted, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Column(
            children: [
              _miniStat('Engagement', '68%', AppColors.accent),
              const SizedBox(height: 16),
              _miniStat('Visibility', '45%', AppColors.primary),
              const SizedBox(height: 16),
              _miniStat('Revenue', '82%', AppColors.success),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }

  Widget _miniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w800, fontSize: 16)),
        Text(label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700));
  }

  Widget _buildChart() {
    final weeklySales = [12.0, 18.0, 15.0, 25.0, 22.0, 30.0, 27.0];
    return Container(
      height: 180,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 35,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  return Text(
                    days[value.toInt()],
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12),
                  );
                },
              ),
            ),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: weeklySales[i],
                  gradient: const LinearGradient(
                    colors: AppColors.insightsGradient,
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 22,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms);
  }

  Widget _buildTipCards() {
    const tips = AppConstants.businessTips;
    return SizedBox(
      height: 160,
      child: PageView.builder(
        itemCount: tips.length,
        itemBuilder: (_, i) {
          final colors = [
            [AppColors.primary, AppColors.primaryLight],
            [AppColors.accent, AppColors.accentLight],
            [const Color(0xFFFF6B9D), const Color(0xFFFFB3CC)],
            [AppColors.warning, const Color(0xFFFFD699)],
            [const Color(0xFF5DADE2), const Color(0xFFADD8F2)],
          ];
          final c = colors[i % colors.length];
          return Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [c[0].withValues(alpha: 0.25), c[1].withValues(alpha: 0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c[0].withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: c[0].withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.lightbulb_rounded,
                          color: c[0], size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text('Tip ${i + 1} of ${tips.length}',
                        style: TextStyle(
                            color: c[0],
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: Text(
                    tips[i],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChecklist() {
    final items = [
      _CheckItem('Set up your business profile', true),
      _CheckItem('Generate your first social post', true),
      _CheckItem('Reply to at least 5 customer messages', false),
      _CheckItem('Create your first invoice', false),
      _CheckItem('Review your weekly insights', false),
      _CheckItem('Upgrade to Pro for unlimited access', false),
    ];

    return Column(
      children: items.asMap().entries.map((entry) {
        final item = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: item.done
                  ? AppColors.success.withValues(alpha: 0.3)
                  : AppColors.darkBorder,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: item.done
                      ? AppColors.success.withValues(alpha: 0.15)
                      : AppColors.darkBorder.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: item.done ? AppColors.success : AppColors.darkBorder,
                    width: 2,
                  ),
                ),
                child: item.done
                    ? const Icon(Icons.check_rounded,
                        color: AppColors.success, size: 14)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: item.done ? AppColors.success : Colors.white,
                    fontSize: 14,
                    fontWeight:
                        item.done ? FontWeight.w500 : FontWeight.w600,
                    decoration: item.done
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: AppColors.success,
                  ),
                ),
              ),
              if (!item.done)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('To-do',
                      style: TextStyle(
                          color: AppColors.primary, fontSize: 11)),
                ),
            ],
          ),
        )
            .animate(delay: (entry.key * 80).ms)
            .fadeIn(duration: 400.ms)
            .slideX(begin: -0.1);
      }).toList(),
    );
  }

  Widget _buildMetrics() {
    final metrics = [
      _Metric('Avg Response\nTime', '< 2 min', Icons.timer_rounded, AppColors.accent),
      _Metric('Customer\nSatisfaction', '4.8 ★', Icons.star_rounded, const Color(0xFFFFD700)),
      _Metric('Content\nReach', '2.4K', Icons.visibility_rounded, AppColors.primary),
      _Metric('Invoice\nConversion', '87%', Icons.check_circle_rounded, AppColors.success),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: metrics.asMap().entries.map((entry) {
        final m = entry.value;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(m.icon, color: m.color, size: 22),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.value,
                      style: TextStyle(
                          color: m.color,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  Text(m.label,
                      style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          height: 1.3)),
                ],
              ),
            ],
          ),
        )
            .animate(delay: (entry.key * 80).ms)
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1);
      }).toList(),
    );
  }
}

class _CheckItem {
  final String label;
  final bool done;
  _CheckItem(this.label, this.done);
}

class _Metric {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  _Metric(this.label, this.value, this.icon, this.color);
}
