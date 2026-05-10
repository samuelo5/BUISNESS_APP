import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class PdfService {
  static Future<void> generateAndPrintInvoice({
    required String businessName,
    required String businessType,
    required Map<String, dynamic> invoice,
  }) async {
    final pdf = pw.Document();

    // Note: I'll use default fonts for now to avoid asset issues, 
    // but the layout will be premium.


    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(businessName.toUpperCase(),
                            style: pw.TextStyle(
                                fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                        pw.Text(businessType,
                            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('INVOICE',
                            style: pw.TextStyle(
                                fontSize: 32, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900)),
                        pw.Text('ID: INV-${invoice['id']}',
                            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                        pw.Text('Date: ${invoice['date']}',
                            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                      ],
                    ),
                  ],
                ),

                pw.SizedBox(height: 48),

                // Client Details
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('BILL TO:',
                            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                        pw.SizedBox(height: 4),
                        pw.Text(invoice['clientName'],
                            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        if (invoice['clientEmail'] != null && invoice['clientEmail'].toString().isNotEmpty)
                          pw.Text(invoice['clientEmail']),
                        if (invoice['clientPhone'] != null && invoice['clientPhone'].toString().isNotEmpty)
                          pw.Text(invoice['clientPhone']),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('STATUS:',
                            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                        pw.SizedBox(height: 4),
                        pw.Text(invoice['status'].toString().toUpperCase(),
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                                color: invoice['status'] == 'Paid' ? PdfColors.green700 : PdfColors.orange700)),
                      ],
                    ),
                  ],
                ),

                pw.SizedBox(height: 40),

                // Items Table
                pw.TableHelper.fromTextArray(
                  border: null,
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
                  headerHeight: 30,
                  cellHeight: 25,
                  headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment.center,
                    2: pw.Alignment.centerRight,
                    3: pw.Alignment.centerRight,
                  },
                  headerCellDecoration: const pw.BoxDecoration(
                    color: PdfColors.blue900,
                  ),
                  headers: ['Description', 'Qty', 'Price', 'Total'],
                  data: List<List<dynamic>>.from(
                    (invoice['items'] as List).map((item) => [
                          item['description'],
                          item['qty'].toString(),
                          '${invoice['currency']} ${item['price'].toStringAsFixed(2)}',
                          '${invoice['currency']} ${(item['qty'] * item['price']).toStringAsFixed(2)}',
                        ]),
                  ),
                ),

                pw.Divider(color: PdfColors.grey400, thickness: 0.5),

                // Totals
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.SizedBox(height: 20),
                        pw.Row(
                          children: [
                            pw.Text('Grand Total: ',
                                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                            pw.Text('${invoice['currency']} ${(invoice['total'] as double).toStringAsFixed(2)}',
                                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                pw.Spacer(),

                // Footer
                pw.Divider(color: PdfColors.grey400, thickness: 0.5),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text('Thank you for your business!',
                          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      if (invoice['notes'] != null && invoice['notes'].toString().isNotEmpty)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 8),
                          child: pw.Text('Notes: ${invoice['notes']}',
                              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                        ),
                      pw.SizedBox(height: 10),
                      pw.Text('Generated by BizAI Assistant',
                          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Use Printing package to share/save
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Invoice_${invoice['id']}.pdf',
    );
  }
}
