# Payment System Setup Guide for BizTracker

This guide explains how to set up real premium payments with in-app purchases and local payment methods for Zimbabwe, without using Stripe.

## Overview

The payment system supports two main payment methods:
1. **In-App Purchases** - Through Google Play Store
2. **Direct Payments** - Local payment methods popular in Zimbabwe

## 1. In-App Purchase Setup

### Google Play Console Configuration

1. **Create Products**
   - Go to [Google Play Console](https://play.google.com/console)
   - Navigate to "Monetization setup" > "Products" > "In-app products"
   - Create the following products:
     - `biztracker_monthly_premium` - Monthly subscription
     - `biztracker_annual_premium` - Annual subscription  
     - `biztracker_lifetime_premium` - One-time purchase

2. **Product Details**
   - Set appropriate prices in USD
   - Monthly: $4.99
   - Annual: $39.99
   - Lifetime: $99.99

3. **Testing**
   - Add test accounts in "Setup" > "License testing"
   - Use test accounts to verify purchases

### App Configuration

1. **Update Product IDs**
   - Edit `lib/config/payment_config.dart`
   - Ensure product IDs match Google Play Console

2. **Test Purchases**
   - Use test accounts during development
   - Verify purchase flow works correctly

## 2. Local Payment Methods Setup

### Supported Payment Methods

The app supports these Zimbabwe-specific payment methods:

- **EcoCash** - Mobile money via Econet
- **OneMoney** - Mobile money via NetOne
- **Bank Transfer** - Direct bank transfers
- **Cash Deposit** - Cash deposits at bank branches

### Payment Gateway Setup

You have several options for processing local payments:

#### Option 1: Paynow Integration
[Paynow](https://paynow.co.zw/) is popular in Zimbabwe and supports:
- EcoCash
- OneMoney
- Bank transfers
- International cards

1. **Sign up for Paynow Business Account**
2. **Get API credentials**
3. **Update configuration**:
   ```dart
   // In lib/config/payment_config.dart
   static const String paymentGatewayUrl = 'https://paynow.co.zw/api/v1/transactions';
   static const String merchantId = 'your_paynow_merchant_id';
   static const String apiKey = 'your_paynow_api_key';
   ```

#### Option 2: Custom Backend
Create your own payment processing backend:

1. **Set up server** (Node.js, Python, etc.)
2. **Implement payment endpoints**:
   ```javascript
   POST /api/payment
   {
     "merchant_id": "your_id",
     "amount": 4.99,
     "currency": "USD",
     "plan_type": "monthly",
     "payment_method": "ecocash",
     "customer_details": {...},
     "payment_data": {...}
   }
   ```

3. **Update configuration**:
   ```dart
   static const String paymentGatewayUrl = 'https://your-server.com/api/payment';
   ```

#### Option 3: Manual Payment Processing
For simple setups, process payments manually:

1. **Display payment instructions** to users
2. **Users send payment** via chosen method
3. **Manually verify payments** and activate premium
4. **Update user status** in your database

### Payment Instructions Setup

Update payment instructions in `lib/config/payment_config.dart`:

```dart
static const List<Map<String, dynamic>> supportedPaymentMethods = [
  {
    'id': 'ecocash',
    'name': 'EcoCash',
    'description': 'Mobile money payment via EcoCash',
    'icon': '📱',
    'instructions': 'Send payment to +263 77 123 4567',
    'processingTime': 'Instant',
  },
  // Add other methods...
];
```

## 3. Configuration Files

### Payment Configuration (`lib/config/payment_config.dart`)

Update these values with your actual details:

```dart
class PaymentConfig {
  // Replace with your actual payment gateway
  static const String paymentGatewayUrl = 'https://your-gateway.com/api/payment';
  static const String merchantId = 'your_merchant_id';
  static const String apiKey = 'your_api_key';
  
  // Update contact information
  static const String supportEmail = 'support@yourcompany.com';
  static const String supportPhone = '+263 77 123 4567';
  
  // Update bank details
  static const String bankAccount = '1234567890';
  static const String bankName = 'Your Bank Name';
}
```

### Product IDs

Ensure these match your Google Play Console products:

```dart
static const Map<String, String> productIds = {
  'monthly': 'biztracker_monthly_premium',
  'annual': 'biztracker_annual_premium',
  'lifetime': 'biztracker_lifetime_premium',
};
```

## 4. Testing the Payment System

### In-App Purchase Testing

1. **Use test accounts** from Google Play Console
2. **Test purchase flow**:
   - Select premium plan
   - Choose "In-App Purchase"
   - Complete test purchase
   - Verify premium activation

### Local Payment Testing

1. **Test payment method selection**:
   - Choose local payment method
   - Fill payment details form
   - Submit payment request

2. **Test with real payments** (small amounts):
   - Send actual payment via chosen method
   - Verify payment confirmation
   - Activate premium manually if needed

## 5. Production Deployment

### Before Going Live

1. **Verify all configurations** are correct
2. **Test with real payment methods**
3. **Set up monitoring** for payment failures
4. **Prepare support documentation**

### Security Considerations

1. **API keys** should be secure and not exposed in client code
2. **Payment verification** should happen on your backend
3. **Receipt validation** for in-app purchases
4. **Fraud detection** for local payments

## 6. Support and Maintenance

### User Support

1. **Clear payment instructions** in the app
2. **Support contact information** readily available
3. **FAQ section** for common payment issues
4. **WhatsApp/Phone support** for immediate help

### Monitoring

1. **Payment success rates** by method
2. **User payment issues** and resolutions
3. **Payment gateway performance**
4. **Revenue tracking** and analytics

## 7. Troubleshooting

### Common Issues

1. **In-App Purchase Fails**
   - Check product IDs match Google Play Console
   - Verify app is signed with correct key
   - Check Google Play Console status

2. **Local Payment Issues**
   - Verify payment gateway configuration
   - Check API credentials
   - Test payment endpoint manually

3. **Premium Not Activated**
   - Check payment confirmation
   - Verify backend processing
   - Check user status updates

### Debug Information

Enable debug logging in the payment service:

```dart
// In lib/services/payment_service.dart
debugPrint('PaymentService: Debug info - $debugData');
```

## 8. Revenue Optimization

### Pricing Strategy

1. **Local currency pricing** for Zimbabwe users
2. **Holiday and weekend promotions**
3. **Annual plan discounts**
4. **Lifetime plan value proposition**

### Payment Method Optimization

1. **Monitor success rates** by payment method
2. **Optimize instructions** for each method
3. **Add popular local methods** as needed
4. **Reduce friction** in payment process

## 9. Legal and Compliance

### Zimbabwe Regulations

1. **Mobile money regulations** compliance
2. **Banking regulations** for business accounts
3. **Tax compliance** for digital services
4. **Consumer protection** requirements

### Terms and Conditions

1. **Payment terms** clearly stated
2. **Refund policy** for each plan
3. **Subscription cancellation** process
4. **Data protection** compliance

## 10. Future Enhancements

### Planned Features

1. **Multiple currency support**
2. **Payment plan options**
3. **Automatic renewals**
4. **Payment analytics dashboard**

### Integration Opportunities

1. **More payment gateways**
2. **Banking APIs** for direct integration
3. **Mobile money APIs** for real-time verification
4. **International payment methods**

---

## Quick Start Checklist

- [ ] Set up Google Play Console products
- [ ] Choose and configure payment gateway
- [ ] Update configuration files
- [ ] Test in-app purchases
- [ ] Test local payment methods
- [ ] Set up payment monitoring
- [ ] Prepare support documentation
- [ ] Deploy to production
- [ ] Monitor and optimize

## Support

For technical support with the payment system:
- Email: support@yourcompany.com
- WhatsApp: +263 77 123 4567
- Phone: +263 77 123 4567

---

*This guide covers the essential setup for real premium payments in BizTracker. Customize the configuration based on your specific payment gateway and business requirements.* 