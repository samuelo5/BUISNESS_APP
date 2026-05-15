import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaystackService {
  late final String _publicKey;
  late final String _secretKey;

  PaystackService() {
    _publicKey = dotenv.env['PAYSTACK_PUBLIC_KEY'] ?? '';
    _secretKey = dotenv.env['PAYSTACK_SECRET_KEY'] ?? '';

    if (_publicKey.isEmpty || _secretKey.isEmpty) {
      throw Exception('Paystack keys not found in environment variables');
    }
  }

  /// Initialize payment reference for subscription
  /// Returns the access code and authorization URL for payment
  Future<Map<String, dynamic>> initializePayment({
    required String email,
    required int amountInCents, // Amount in cents (e.g., 1000 for ₦10.00)
    required String plan, // 'Pro' or 'Premium'
    required String reference,
  }) async {
    final url = Uri.parse('https://api.paystack.co/transaction/initialize');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'amount': amountInCents,
          'reference': reference,
          'metadata': {
            'plan': plan,
            'subscription_type': 'business_assistant',
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          return {
            'success': true,
            'access_code': data['data']['access_code'],
            'authorization_url': data['data']['authorization_url'],
            'reference': data['data']['reference'],
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Failed to initialize payment',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error initializing payment: $e',
      };
    }
  }

  /// Verify payment transaction
  Future<Map<String, dynamic>> verifyPayment({
    required String reference,
  }) async {
    final url =
        Uri.parse('https://api.paystack.co/transaction/verify/$reference');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_secretKey',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          final transactionData = data['data'];
          return {
            'success': true,
            'status': transactionData['status'],
            'amount': transactionData['amount'],
            'reference': transactionData['reference'],
            'customer_email': transactionData['customer']['email'],
            'metadata': transactionData['metadata'],
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Verification failed',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error verifying payment: $e',
      };
    }
  }

  /// Get public key for client-side use
  String getPublicKey() => _publicKey;

  /// Calculate amount in cents based on plan
  static int getAmountForPlan(String plan) {
    switch (plan) {
      case 'Pro':
        return 1000 * 100; // ₦1000 (adjust based on your pricing)
      case 'Premium':
        return 3000 * 100; // ₦3000 (adjust based on your pricing)
      default:
        return 0;
    }
  }
}
