# Paystack Integration Setup Guide

## Overview
Paystack payment integration has been set up for the subscription feature in the Business Assistant app. The secret key and public key are stored as environment variables in the `.env` file.

## Files Created/Modified

### 1. **Core Service** - `lib/core/services/paystack_service.dart` (NEW)
   - `PaystackService` class handles all Paystack API interactions
   - Methods:
     - `initializePayment()` - Initiates a payment transaction
     - `verifyPayment()` - Verifies payment completion
     - `getPublicKey()` - Returns the public key for client-side use
     - `getAmountForPlan()` - Calculates amount based on subscription plan

### 2. **Payment Screen** - `lib/features/subscription/screens/paystack_payment_screen.dart` (NEW)
   - WebView-based payment interface
   - Handles payment gateway redirection
   - Verifies payment completion
   - Updates subscription on successful payment

### 3. **Updated Files**
   - `.env` - Added Paystack keys (placeholder values)
   - `lib/providers/app_provider.dart` - Added payment handling methods
   - `lib/features/subscription/screens/subscription_screen.dart` - Integrated Paystack payment flow
   - `pubspec.yaml` - Added dependencies (webview_flutter, http)

## Environment Variables

Add these to your `.env` file with your actual Paystack keys:

```env
# Paystack Payment Configuration
PAYSTACK_PUBLIC_KEY=YOUR_PAYSTACK_PUBLIC_KEY_HERE
PAYSTACK_SECRET_KEY=YOUR_PAYSTACK_SECRET_KEY_HERE
```

**Where to get your keys:**
1. Go to [Paystack Dashboard](https://dashboard.paystack.com)
2. Navigate to Settings > API Keys & Webhooks
3. Copy your **Public Key** and **Secret Key**
4. Replace the placeholder values in `.env`

## How It Works

### Payment Flow:
1. User selects a plan (Pro or Premium) on subscription screen
2. User enters their email in a dialog
3. App initializes Paystack payment with the plan details
4. User is redirected to Paystack payment gateway (via WebView)
5. After payment, app verifies the transaction
6. On success, subscription is updated and user is notified

### Key Methods in AppProvider:
- `initializePaystackPayment()` - Starts payment process
- `verifyPaystackPayment()` - Confirms payment completion
- `getPaystackPublicKey()` - Retrieves public key
- `clearPaymentError()` - Clears error messages

## Subscription Plans & Pricing

The pricing is calculated in cents:
- **Pro**: ₦1000 (₦1000 × 100 = 100,000 cents)
- **Premium**: ₦3000 (₦3000 × 100 = 300,000 cents)

**Note:** Adjust these amounts in `PaystackService.getAmountForPlan()` based on your actual pricing strategy.

## Testing

### Test Mode:
Use Paystack's test cards:
- **Card Number**: 4084084084084081
- **Expiry**: Any future date (e.g., 12/25)
- **CVV**: Any 3 digits (e.g., 123)
- **Amount**: Any amount

### Important Notes:
1. Test transactions will not charge real money
2. Use test keys for development (available in Paystack dashboard)
3. Switch to live keys for production

## Error Handling

The app handles various error scenarios:
- Missing/invalid API keys
- Network errors during payment
- Failed payment verification
- Payment cancellation

All errors are displayed to users with helpful messages.

## Future Enhancements

Potential improvements:
1. Add recurring/subscription billing support
2. Implement webhook handling for payment confirmations
3. Add payment history tracking
4. Support multiple payment methods
5. Add discount codes/coupons
6. Implement invoice generation for payments

## Dependencies Added

- `webview_flutter: ^4.6.0` - For Paystack payment gateway WebView
- `http: ^1.1.0` - For API calls to Paystack
- `flutter_dotenv: ^5.1.0` - Already present, for environment variables
- `uuid: ^4.4.2` - Already present, for generating unique payment references

## Troubleshooting

### "Paystack keys not found" error:
- Ensure `.env` file exists in project root
- Verify keys are correctly set in `.env`
- Restart the app after updating `.env`

### WebView not loading:
- Check internet connection
- Verify Paystack service status
- Ensure API keys are valid

### Payment verification fails:
- Check that payment was actually completed
- Verify reference is passed correctly
- Check Paystack API keys are correct
