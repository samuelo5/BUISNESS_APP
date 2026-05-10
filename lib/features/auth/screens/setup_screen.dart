import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:business_assistant/core/theme/app_theme.dart';
import 'package:business_assistant/core/constants/app_constants.dart';
import 'package:business_assistant/providers/app_provider.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _bizNameCtrl = TextEditingController();
  String _selectedType = AppConstants.businessTypes[0];
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Header
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.business_center_rounded,
                      color: Colors.white, size: 34),
                ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
                const SizedBox(height: 24),
                const Text(
                  'Set Up Your\nBusiness Profile',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
                const SizedBox(height: 8),
                const Text(
                  'Help us personalize your AI experience',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                const SizedBox(height: 40),

                // Your Name
                _label('Your Name'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'e.g. John Doe',
                    prefixIcon: Icon(Icons.person_rounded, color: AppColors.primary),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Please enter your name' : null,
                ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
                const SizedBox(height: 20),

                // Business Name
                _label('Business Name'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bizNameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'e.g. Sunrise Boutique',
                    prefixIcon:
                        Icon(Icons.store_rounded, color: AppColors.accent),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty
                          ? 'Please enter your business name'
                          : null,
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                const SizedBox(height: 20),

                // Business Type
                _label('Business Type'),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedType,
                      isExpanded: true,
                      dropdownColor: AppColors.darkCard,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      borderRadius: BorderRadius.circular(16),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textMuted),
                      items: AppConstants.businessTypes
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedType = v!),
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 250.ms),

                const SizedBox(height: 48),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Launch My Dashboard',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/home'),
                    child: const Text(
                      'Skip for now',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await context.read<AppProvider>().setUserProfile(
          name: _nameCtrl.text.trim(),
          businessName: _bizNameCtrl.text.trim(),
          businessType: _selectedType,
        );
    await Future.delayed(800.ms);
    if (mounted) Navigator.pushReplacementNamed(context, '/home');
  }
}
