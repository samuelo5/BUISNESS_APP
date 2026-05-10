import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:business_assistant/providers/app_provider.dart';
import 'package:business_assistant/features/dashboard/screens/dashboard_screen.dart';
import 'package:business_assistant/features/content_generator/screens/content_generator_screen.dart';
import 'package:business_assistant/features/chat_assistant/screens/chat_assistant_screen.dart';
import 'package:business_assistant/features/invoice/screens/invoice_screen.dart';
import 'package:business_assistant/features/insights/screens/insights_screen.dart';
import 'package:business_assistant/core/theme/app_theme.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final List<Widget> _screens = [
    const DashboardScreen(),
    const ContentGeneratorScreen(),
    const ChatAssistantScreen(),
    const InvoiceScreen(),
    const InsightsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();


    return Scaffold(
      body: IndexedStack(
        index: provider.currentTabIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.darkBorder 
                  : AppColors.lightBorder, 
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: provider.currentTabIndex,
          onTap: (i) => provider.setTabIndex(i),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_rounded),
              label: 'Content',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded),
              label: 'Chat AI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded),
              label: 'Invoice',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_rounded),
              label: 'Insights',
            ),
          ],
        ),
      ),
    );
  }
}
