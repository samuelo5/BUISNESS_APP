import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:business_assistant/core/theme/app_theme.dart';
import 'package:business_assistant/providers/app_provider.dart';
import 'package:business_assistant/core/services/pdf_service.dart';


class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(provider),
            TabBar(
              controller: _tabCtrl,
              tabs: const [
                Tab(text: 'Create Invoice'),
                Tab(text: 'My Invoices'),
              ],
              indicatorColor: AppColors.warning,
              labelColor: AppColors.warning,
              unselectedLabelColor: AppColors.textMuted,
              dividerColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  _InvoiceFormTab(
                    onCreated: (invoice) {
                      provider.addInvoice(invoice);
                      _tabCtrl.animateTo(1);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('✅ Invoice created successfully!'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    canCreate: provider.canCreateInvoice,
                    onUpgrade: () =>
                        Navigator.pushNamed(context, '/subscription'),
                  ),
                  _InvoiceListTab(
                    invoices: provider.invoices,
                    onDelete: (i) => provider.deleteInvoice(i),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: AppColors.invoiceGradient),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.receipt_long_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invoice Generator',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'Create professional invoices fast',
                    style:
                        TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.darkCard.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
            ),
            child: Text(
              provider.isPro
                  ? '∞ Pro'
                  : '${provider.invoicesCreated}/3',
              style: const TextStyle(
                color: AppColors.warning,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

// ─── Invoice Form Tab ─────────────────────────────────────────────────────────────
class _InvoiceFormTab extends StatefulWidget {
  final Function(Map<String, dynamic>) onCreated;
  final bool canCreate;
  final VoidCallback onUpgrade;

  const _InvoiceFormTab({
    required this.onCreated,
    required this.canCreate,
    required this.onUpgrade,
  });

  @override
  State<_InvoiceFormTab> createState() => _InvoiceFormTabState();
}

class _InvoiceFormTabState extends State<_InvoiceFormTab> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameCtrl = TextEditingController();
  final _clientEmailCtrl = TextEditingController();
  final _clientPhoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final List<_LineItem> _items = [_LineItem()];
  String _currency = 'USD';

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'KES', 'NGN', 'ZAR', 'AED'];

  double get _total => _items.fold(0, (sum, item) {
        final qty = double.tryParse(item.qtyCtrl.text) ?? 0;
        final price = double.tryParse(item.priceCtrl.text) ?? 0;
        return sum + qty * price;
      });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Client Details', Icons.person_rounded),
            const SizedBox(height: 12),
            _field(_clientNameCtrl, 'Client Name', Icons.business_rounded,
                required: true),
            const SizedBox(height: 12),
            _field(_clientEmailCtrl, 'Email Address', Icons.email_rounded,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            _field(_clientPhoneCtrl, 'Phone Number', Icons.phone_rounded,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 24),

            // Currency
            _sectionHeader('Currency', Icons.attach_money_rounded),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _currency,
                  isExpanded: true,
                  dropdownColor: Theme.of(context).cardTheme.color,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  borderRadius: BorderRadius.circular(16),
                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark, fontSize: 15),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textMuted),
                  items: _currencies
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _currency = v!),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Line Items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionHeader('Items', Icons.list_rounded),
                TextButton.icon(
                  onPressed: () =>
                      setState(() => _items.add(_LineItem())),
                  icon: const Icon(Icons.add_rounded,
                      size: 18, color: AppColors.warning),
                  label: const Text('Add Row',
                      style: TextStyle(color: AppColors.warning)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(_items.length, (i) => _buildLineItem(i)),
            const SizedBox(height: 16),

            // Total
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.invoiceGradient,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '$_currency ${_total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Notes
            _sectionHeader('Notes (Optional)', Icons.note_rounded),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 3,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText:
                    'e.g. Payment due within 14 days. Thank you for your business!',
              ),
            ),
            const SizedBox(height: 28),

            // Create Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: AppColors.invoiceGradient),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.warning.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_rounded,
                            color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Create Invoice',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.warning, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.warning, size: 20),
      ),
      validator: required
          ? (v) =>
              v == null || v.trim().isEmpty ? 'Required field' : null
          : null,
    );
  }

  Widget _buildLineItem(int index) {
    final item = _items[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: item.descCtrl,
            style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Item description',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const Divider(color: AppColors.darkBorder, height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: item.qtyCtrl,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Qty',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: item.priceCtrl,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Unit Price',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                (double.tryParse(item.qtyCtrl.text) ?? 0) * (double.tryParse(item.priceCtrl.text) ?? 0) == 0 ? "—" : ((double.tryParse(item.qtyCtrl.text) ?? 0) * (double.tryParse(item.priceCtrl.text) ?? 0)).toStringAsFixed(2),
                style: const TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              if (_items.length > 1)
                IconButton(
                  onPressed: () => setState(() => _items.removeAt(index)),
                  icon: const Icon(Icons.remove_circle_rounded,
                      color: AppColors.error, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (!widget.canCreate) {
      widget.onUpgrade();
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final invoice = {
      'id': const Uuid().v4().substring(0, 8).toUpperCase(),
      'clientName': _clientNameCtrl.text.trim(),
      'clientEmail': _clientEmailCtrl.text.trim(),
      'clientPhone': _clientPhoneCtrl.text.trim(),
      'currency': _currency,
      'items': _items
          .map((i) => {
                'description': i.descCtrl.text,
                'qty': double.tryParse(i.qtyCtrl.text) ?? 0,
                'price': double.tryParse(i.priceCtrl.text) ?? 0,
              })
          .toList(),
      'total': _total,
      'notes': _notesCtrl.text.trim(),
      'date': DateFormat('MMM dd, yyyy').format(DateTime.now()),
      'status': 'Pending',
    };

    widget.onCreated(invoice);

    // Reset form
    _clientNameCtrl.clear();
    _clientEmailCtrl.clear();
    _clientPhoneCtrl.clear();
    _notesCtrl.clear();
    setState(() => _items
      ..clear()
      ..add(_LineItem()));
  }
}

// ─── Invoice List Tab ─────────────────────────────────────────────────────────────
class _InvoiceListTab extends StatelessWidget {
  final List<Map<String, dynamic>> invoices;
  final Function(int) onDelete;

  const _InvoiceListTab({required this.invoices, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    if (invoices.isEmpty) {

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: AppColors.invoiceGradient),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(Icons.receipt_long_rounded,
                  color: Colors.white, size: 44),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 20),
            const Text(
              'No invoices yet',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const Text(
              'Create your first invoice to get started',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: invoices.length,
      itemBuilder: (context, i) {
        final inv = invoices[i];
        final statusColor = inv['status'] == 'Paid'
            ? AppColors.success
            : inv['status'] == 'Overdue'
                ? AppColors.error
                : AppColors.warning;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: AppColors.invoiceGradient),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.receipt_rounded,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inv['clientName'],
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'INV-${inv['id']} • ${inv['date']}',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${inv['currency']} ${(inv['total'] as double).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            inv['status'],
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.darkBorder),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    _bottomBtn(Icons.visibility_rounded, 'View', () =>
                        _showDetail(context, inv)),
                    _bottomBtn(Icons.mark_email_read_rounded, 'Mark Paid', () {
                      provider.updateInvoiceStatus(inv['id'], 'Paid');
                    }),

                    _bottomBtn(Icons.picture_as_pdf_rounded, 'Export PDF', () {
                      PdfService.generateAndPrintInvoice(
                        businessName: provider.businessName,
                        businessType: provider.businessType,
                        invoice: inv,
                      );
                    }, color: AppColors.accent),
                    _bottomBtn(
                        Icons.delete_outline_rounded, 'Delete', () => onDelete(i),
                        color: AppColors.error),

                  ],
                ),
              ),
            ],
          ),
        )
            .animate(delay: (i * 80).ms)
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1);
      },
    );
  }

  Widget _bottomBtn(IconData icon, String label, VoidCallback onTap,
      {Color color = AppColors.textMuted}) {
    return Expanded(
      child: TextButton(
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, Map<String, dynamic> inv) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, ctrl) => _InvoiceDetailSheet(invoice: inv, controller: ctrl),
      ),
    );
  }
}

class _InvoiceDetailSheet extends StatelessWidget {
  final Map<String, dynamic> invoice;
  final ScrollController controller;

  const _InvoiceDetailSheet({required this.invoice, required this.controller});

  @override
  Widget build(BuildContext context) {
    final items = invoice['items'] as List<dynamic>;
    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.darkBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Invoice Details',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text('INV-${invoice['id']}',
                  style: const TextStyle(
                      color: AppColors.warning, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _row('Client', invoice['clientName']),
        if ((invoice['clientEmail'] as String).isNotEmpty)
          _row('Email', invoice['clientEmail']),
        if ((invoice['clientPhone'] as String).isNotEmpty)
          _row('Phone', invoice['clientPhone']),
        _row('Date', invoice['date']),
        _row('Status', invoice['status']),
        const Divider(color: AppColors.darkBorder, height: 32),
        const Text('Items',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(item['description'],
                        style: const TextStyle(color: AppColors.textSecondary)),
                  ),
                  Text(
                    '${item['qty']} × ${invoice['currency']} ${(item['price'] as double).toStringAsFixed(2)}',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
            )),
        const Divider(color: AppColors.darkBorder, height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18)),
            Text(
              '${invoice['currency']} ${(invoice['total'] as double).toStringAsFixed(2)}',
              style: const TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
            ),
          ],
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: () {
              final provider = Provider.of<AppProvider>(context, listen: false);
              PdfService.generateAndPrintInvoice(
                businessName: provider.businessName,
                businessType: provider.businessType,
                invoice: invoice,
              );
            },
            icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
            label: const Text('Export to PDF',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
        const SizedBox(height: 20),


        if ((invoice['notes'] as String).isNotEmpty) ...[
          const Divider(color: AppColors.darkBorder, height: 24),
          const Text('Notes',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(invoice['notes'],
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 14, height: 1.5)),
        ],
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _LineItem {
  final descCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
}
