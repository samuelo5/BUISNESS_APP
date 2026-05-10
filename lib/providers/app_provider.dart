import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:business_assistant/core/constants/app_constants.dart';
import 'package:business_assistant/core/services/ai_service.dart';


class AppProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  String _userName = '';
  String _businessName = '';
  String _businessType = '';
  String _subscriptionPlan = 'Free';
  int _contentGenerationsUsed = 0;
  int _chatMessagesUsed = 0;
  int _invoicesCreated = 0;
  int _currentTabIndex = 0; // Added for global navigation
  String _dailyTip = ''; // Dynamic AI tip
  final List<Map<String, dynamic>> _invoices = [];



  bool get isDarkMode => _isDarkMode;
  String get userName => _userName;
  String get businessName => _businessName;
  String get businessType => _businessType;
  String get subscriptionPlan => _subscriptionPlan;
  int get contentGenerationsUsed => _contentGenerationsUsed;
  int get chatMessagesUsed => _chatMessagesUsed;
  int get invoicesCreated => _invoicesCreated;
  int get currentTabIndex => _currentTabIndex; // Added
  String get dailyTip => _dailyTip; // AI Tip
  List<Map<String, dynamic>> get invoices => _invoices;



  bool get isPro => _subscriptionPlan == 'Pro' || _subscriptionPlan == 'Premium';
  bool get isPremium => _subscriptionPlan == 'Premium';

  bool get canGenerateContent =>
      isPro || _contentGenerationsUsed < AppConstants.freeContentGenerations;
  bool get canSendChat =>
      isPro || _chatMessagesUsed < AppConstants.freeChatMessages;
  bool get canCreateInvoice =>
      isPro || _invoicesCreated < AppConstants.freeInvoices;

  int get remainingContentGenerations =>
      isPro ? 999 : (AppConstants.freeContentGenerations - _contentGenerationsUsed);
  int get remainingChatMessages =>
      isPro ? 999 : (AppConstants.freeChatMessages - _chatMessagesUsed);
  int get remainingInvoices =>
      isPro ? 999 : (AppConstants.freeInvoices - _invoicesCreated);

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(AppConstants.keyThemeMode) ?? true;
    _userName = prefs.getString(AppConstants.keyUserName) ?? '';
    _businessName = prefs.getString(AppConstants.keyBusinessName) ?? 'My Business';
    _businessType = prefs.getString(AppConstants.keyBusinessType) ?? '';
    _subscriptionPlan = prefs.getString(AppConstants.keySubscriptionPlan) ?? 'Free';
    _contentGenerationsUsed = prefs.getInt('content_used') ?? 0;
    _chatMessagesUsed = prefs.getInt('chat_used') ?? 0;
    _invoicesCreated = prefs.getInt('invoices_created') ?? 0;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyThemeMode, _isDarkMode);
    notifyListeners();
  }

  Future<void> setUserProfile({
    required String name,
    required String businessName,
    required String businessType,
  }) async {
    _userName = name;
    _businessName = businessName;
    _businessType = businessType;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyUserName, name);
    await prefs.setString(AppConstants.keyBusinessName, businessName);
    await prefs.setString(AppConstants.keyBusinessType, businessType);
    notifyListeners();
  }

  Future<void> setSubscriptionPlan(String plan) async {
    _subscriptionPlan = plan;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keySubscriptionPlan, plan);
    notifyListeners();
  }

  Future<void> incrementContentGenerations() async {
    _contentGenerationsUsed++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('content_used', _contentGenerationsUsed);
    notifyListeners();
  }

  Future<void> incrementChatMessages() async {
    _chatMessagesUsed++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('chat_used', _chatMessagesUsed);
    notifyListeners();
  }

  Future<void> addInvoice(Map<String, dynamic> invoice) async {
    _invoices.insert(0, invoice);
    _invoicesCreated++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('invoices_created', _invoicesCreated);
    notifyListeners();
  }

  void deleteInvoice(int index) {
    _invoices.removeAt(index);
    notifyListeners();
  }

  void updateInvoiceStatus(String id, String newStatus) {
    try {
      final index = _invoices.indexWhere((inv) => inv['id'] == id);
      if (index != -1) {
        _invoices[index]['status'] = newStatus;
        notifyListeners();
      }
    } catch (e) {
      // Logic for status update
    }
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  // --- AI GENERATION METHODS ---


  Future<String> generateContent({
    required String topic,
    required String platform,
    required String tone,
  }) async {
    final result = await AiService().generateSocialContent(
      topic: topic,
      platform: platform,
      tone: tone,
    );
    await incrementContentGenerations();
    return result;
  }

  Future<String> generateReply({
    required String message,
    required String type,
  }) async {
    final result = await AiService().generateCustomerReply(
      customerMessage: message,
      type: type,
    );
    await incrementChatMessages();
    return result;
  }

  Future<void> fetchDailyTip() async {
    if (_dailyTip.isNotEmpty) return;
    
    _dailyTip = await AiService().generateDailyTip(
      businessName: _businessName,
      businessType: _businessType,
    );
    notifyListeners();
  }
}


