class AppConstants {
  static const String appName = 'BizAI Assistant';
  static const String appTagline = 'Your Smart Business Partner';
  static const String appVersion = '1.0.0';

  // Subscription Plans
  static const double starterPrice = 0.0;
  static const double proPrice = 10.0;
  static const double premiumPrice = 30.0;

  // Free tier limits
  static const int freeContentGenerations = 5;
  static const int freeChatMessages = 20;
  static const int freeInvoices = 3;

  // Shared Prefs Keys
  static const String keyIsOnboarded = 'is_onboarded';
  static const String keyUserName = 'user_name';
  static const String keyBusinessName = 'business_name';
  static const String keyBusinessType = 'business_type';
  static const String keySubscriptionPlan = 'subscription_plan';
  static const String keyThemeMode = 'theme_mode';

  // Business types
  static const List<String> businessTypes = [
    'Retail Store',
    'Online Shop / E-commerce',
    'Restaurant / Food Business',
    'Freelancer / Consultant',
    'Beauty & Wellness',
    'Tech Startup',
    'Real Estate',
    'Education & Coaching',
    'Health & Fitness',
    'Other',
  ];

  // Social platforms
  static const List<String> socialPlatforms = [
    'Instagram',
    'Facebook',
    'Twitter / X',
    'LinkedIn',
    'TikTok',
    'WhatsApp Status',
    'General',
  ];

  // Tone options
  static const List<String> toneOptions = [
    'Professional',
    'Casual & Friendly',
    'Exciting & Energetic',
    'Informative',
    'Funny & Witty',
    'Luxury & Exclusive',
  ];

  // Customer message types
  static const List<String> messageTypes = [
    'Product Inquiry',
    'Complaint',
    'Order Status',
    'Refund Request',
    'General Question',
    'Compliment / Feedback',
    'Appointment Booking',
  ];

  // Sample AI-generated content (mock for demo)
  static const List<String> samplePosts = [
    "✨ Big news! Our latest collection just dropped and it's everything you've been waiting for. Shop now and experience the difference quality makes! 🛍️ #NewCollection #ShopNow",
    "🚀 Level up your business game with our premium services. We don't just deliver results — we deliver excellence. Ready to grow? Let's talk! 💼 #BusinessGrowth",
    "💡 Did you know? 80% of success is showing up consistently. That's why we're here every day, delivering top-notch service to our valued customers. Thank you for trusting us! ❤️",
    "🌟 Flash Sale Alert! Get 30% OFF all products today only. Don't miss out — limited stock available! Swipe up to grab yours before it's gone! ⏰ #FlashSale #LimitedOffer",
    "👋 Meet the team behind your favourite brand! We're passionate, dedicated, and committed to making your experience unforgettable. Say hi in the comments! 😊 #BehindTheScenes",
  ];

  static const List<String> sampleReplies = [
    "Thank you for reaching out! We truly appreciate your message and will do our best to assist you. Our team will get back to you within 24 hours. 😊",
    "We're so sorry to hear about your experience. This is not the standard we hold ourselves to, and we want to make it right. Please share your order details and we'll resolve this immediately.",
    "Great news! Your order is currently being processed and will be shipped within 2-3 business days. You'll receive a tracking number via email once it's on its way! 📦",
    "Thank you for your inquiry! We'd love to help. The product you're asking about is available in multiple sizes and colors. Would you like us to send you the full catalogue?",
    "We truly appreciate your kind words! It means the world to us knowing our customers are happy. We'll make sure to share your feedback with our team! ⭐",
  ];

  static const List<String> businessTips = [
    "📱 Post consistently on social media — aim for at least 4-5 times per week to stay top-of-mind with your audience.",
    "💬 Respond to customer messages within 1 hour. Fast response times increase conversion rates by up to 400%.",
    "📊 Track your top 3 metrics: Revenue, Customer Acquisition Cost, and Customer Lifetime Value.",
    "🎯 Run targeted promotions during weekends — that's when 60% of impulse purchases happen.",
    "🤝 Ask your happy customers for referrals. Word-of-mouth marketing is still the most powerful growth tool.",
    "💡 Bundle your products or services to increase average order value without acquiring new customers.",
    "📧 Build an email list — it's an asset you own. Even 500 engaged subscribers can generate significant revenue.",
    "⭐ Display testimonials prominently. Social proof builds trust and reduces buying hesitation by 67%.",
    "🔄 Follow up with past customers — re-engaging existing clients is 5x cheaper than acquiring new ones.",
    "📈 Invest in your online presence. 97% of consumers search online before making a purchase decision.",
  ];
}
