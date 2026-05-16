import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:business_assistant/core/theme/app_theme.dart';
import 'package:business_assistant/providers/app_provider.dart';

class PaystackPaymentScreen extends StatefulWidget {
  final String plan;
  final double amount;
  final String userEmail;

  const PaystackPaymentScreen({
    super.key,
    required this.plan,
    required this.amount,
    required this.userEmail,
  });

  @override
  State<PaystackPaymentScreen> createState() => _PaystackPaymentScreenState();
}

class _PaystackPaymentScreenState extends State<PaystackPaymentScreen> {
  late WebViewController _webViewController;
  String? _authorizationUrl;
  String? _reference;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    final provider = context.read<AppProvider>();

    final result = await provider.initializePaystackPayment(
      email: widget.userEmail,
      plan: widget.plan,
    );

    if (result['success'] == true) {
      setState(() {
        _authorizationUrl = result['authorization_url'];
        _reference = result['reference'];
        _isLoading = false;
      });
      _initializeWebView();
    } else {
      setState(() {
        _errorMessage = result['message'] ?? 'Failed to initialize payment';
        _isLoading = false;
      });
    }
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('Page started: $url');
            _checkIfPaymentCompleted(url);
          },
          onPageFinished: (String url) {
            print('Page finished: $url');
            _checkIfPaymentCompleted(url);
          },
          onWebResourceError: (WebResourceError error) {
            print('Web resource error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(_authorizationUrl!));
  }

  void _checkIfPaymentCompleted(String url) {
    // Check if the URL contains the callback URL pattern
    if (url.contains('close=') || url.contains('callback')) {
      _verifyPayment();
    }
  }

  Future<void> _verifyPayment() async {
    final provider = context.read<AppProvider>();

    if (_reference == null) return;

    final isVerified = await provider.verifyPaystackPayment(
      reference: _reference!,
      plan: widget.plan,
    );

    if (mounted) {
      if (isVerified) {
        // Payment successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Payment successful! Welcome to ${widget.plan}!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment verification failed: ${provider.paymentError}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Complete Payment'),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Payment Error'),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 64),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: WebViewWidget(controller: _webViewController),
    );
  }
}
