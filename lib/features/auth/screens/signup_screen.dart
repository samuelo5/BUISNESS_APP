import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:business_assistant/core/theme/app_theme.dart';
import 'package:business_assistant/providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_passCtrl.text != _confirmPassCtrl.text) {
      _showError('Passwords do not match');
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.signUp(_emailCtrl.text.trim(), _passCtrl.text.trim());
    
    if (success && mounted) {
      // New users should go to setup
      Navigator.pushReplacementNamed(context, '/setup');
    } else if (mounted) {
      _showError(auth.error ?? 'Signup failed');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    _buildHeader(),
                    const SizedBox(height: 40),
                    
                    // Email Field
                    _buildTextField(
                      controller: _emailCtrl,
                      label: 'Email Address',
                      hint: 'name@business.com',
                      icon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v == null || v.isEmpty ? 'Email is required' : null,
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                    
                    const SizedBox(height: 20),
                    
                    // Password Field
                    _buildTextField(
                      controller: _passCtrl,
                      label: 'Password',
                      hint: '••••••••',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscurePass,
                      suffix: IconButton(
                        icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility, color: AppColors.textMuted),
                        onPressed: () => setState(() => _obscurePass = !_obscurePass),
                      ),
                      validator: (v) => v != null && v.length < 6 ? 'Password too short' : null,
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                    
                    const SizedBox(height: 20),

                    // Confirm Password Field
                    _buildTextField(
                      controller: _confirmPassCtrl,
                      label: 'Confirm Password',
                      hint: '••••••••',
                      icon: Icons.lock_clock_outlined,
                      obscureText: _obscureConfirmPass,
                      suffix: IconButton(
                        icon: Icon(_obscureConfirmPass ? Icons.visibility_off : Icons.visibility, color: AppColors.textMuted),
                        onPressed: () => setState(() => _obscureConfirmPass = !_obscureConfirmPass),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Please confirm password' : null,
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                    
                    const SizedBox(height: 32),
                    
                    // Signup Button
                    _buildSignupButton(auth),
                    
                    const SizedBox(height: 32),
                    _buildDivider(),
                    const SizedBox(height: 32),
                    
                    // Social Signups
                    _buildSocialButtons(auth),
                    
                    const SizedBox(height: 40),
                    _buildLoginLink(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.darkBg,
            AppColors.darkSurface,
            Color(0xFF161B2E),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.chatGradient),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 34),
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 24),
        const Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
        const SizedBox(height: 8),
        const Text(
          'Join the community of smart entrepreneurs',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.accent, size: 20),
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupButton(AuthProvider auth) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: auth.isLoading ? null : _handleSignup,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 8,
          shadowColor: AppColors.accent.withValues(alpha: 0.4),
        ),
        child: auth.isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Get Started Free', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
      ),
    ).animate().fadeIn(delay: 500.ms).scale();
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: AppColors.darkBorder)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('OR SIGN UP WITH', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w700)),
        ),
        Expanded(child: Divider(color: AppColors.darkBorder)),
      ],
    );
  }

  Widget _buildSocialButtons(AuthProvider auth) {
    return Row(
      children: [
        Expanded(child: _socialBtn(FontAwesomeIcons.google, 'Google', () => auth.signInWithGoogle())),
        const SizedBox(width: 16),
        Expanded(child: _socialBtn(FontAwesomeIcons.apple, 'Apple', () => auth.signInWithApple())),
      ],
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2);
  }

  Widget _socialBtn(IconData icon, String label, Future<bool> Function() action) {
    return InkWell(
      onTap: () async {
        final success = await action();
        if (success && mounted) Navigator.pushReplacementNamed(context, '/setup');
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.darkBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? ", style: TextStyle(color: AppColors.textSecondary)),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          child: const Text("Sign In", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
        ),
      ],
    ).animate().fadeIn(delay: 700.ms);
  }
}
