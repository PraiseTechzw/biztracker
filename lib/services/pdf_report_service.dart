import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/business_profile.dart';
import '../models/business_data.dart';

class PdfReportService {
  static Future<void> generateBusinessReport({
    required BusinessProfile businessProfile,
    required List<Sale> sales,
    required List<Expense> expenses,
    required List<Stock> stocks,
    required List<Capital> capitals,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final pdf = pw.Document();

    // Add logo if available
    pw.MemoryImage? logoImage;
    try {
      if (businessProfile.logoPath != null) {
        final logoFile = File(businessProfile.logoPath!);
        if (await logoFile.exists()) {
          final logoBytes = await logoFile.readAsBytes();
          logoImage = pw.MemoryImage(logoBytes);
        }
      }
    } catch (e) {
      // Logo not available, continue without it
    }

    // Calculate report data
    final reportData = _calculateReportData(
      sales: sales,
      expenses: expenses,
      stocks: stocks,
      capitals: capitals,
      startDate: startDate,
      endDate: endDate,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(context, businessProfile, logoImage),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildTitlePage(businessProfile, startDate, endDate, logoImage),
          _buildFinancialSummary(reportData),
          _buildSalesAnalysis(reportData),
          _buildExpenseBreakdown(reportData),
          _buildInventoryReport(reportData),
          _buildPerformanceMetrics(reportData),
          _buildCharts(reportData),
        ],
      ),
    );

    // Save and share the PDF
    await _saveAndSharePdf(pdf, businessProfile.businessName);
  }

  static pw.Widget _buildHeader(
    pw.Context context,
    BusinessProfile businessProfile,
    pw.MemoryImage? logoImage,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 20),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 1),
        ),
      ),
      child: pw.Row(
        children: [
          if (logoImage != null) ...[
            pw.Image(logoImage, width: 40, height: 40),
            pw.SizedBox(width: 16),
          ],
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  businessProfile.businessName,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                if (businessProfile.businessType.isNotEmpty)
                  pw.Text(
                    businessProfile.businessType.toUpperCase(),
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                    ),
                  ),
              ],
            ),
          ),
          pw.Text(
            'Generated: ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 20),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300, width: 1),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 20,
                height: 20,
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue800,
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(4),
                  ),
                ),
                child: pw.Center(
                  child: pw.Text(
                    'BT',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Text(
                'BizTracker Business Report',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
            ],
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTitlePage(
    BusinessProfile businessProfile,
    DateTime startDate,
    DateTime endDate,
    pw.MemoryImage? logoImage,
  ) {
    return pw.Container(
      height: 700,
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          begin: pw.Alignment.topLeft,
          end: pw.Alignment.bottomRight,
          colors: [PdfColors.blue50, PdfColors.white],
        ),
      ),
      child: pw.Column(
        children: [
          // Header with logo
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(40),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                if (logoImage != null)
                  pw.Image(logoImage, width: 80, height: 80)
                else
                  pw.Container(
                    width: 80,
                    height: 80,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue800,
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(12),
                      ),
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        'BT',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                    ),
                  ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Generated',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.Text(
                      DateFormat('MMM dd, yyyy').format(DateTime.now()),
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main content
          pw.Expanded(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                // Main title with modern styling
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue800,
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(16),
                    ),
                  ),
                  child: pw.Text(
                    'BUSINESS INTELLIGENCE REPORT',
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                pw.SizedBox(height: 40),

                // Business name with elegant styling
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 30,
                  ),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.blue800, width: 2),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(20),
                    ),
                  ),
                  child: pw.Text(
                    businessProfile.businessName,
                    style: pw.TextStyle(
                      fontSize: 32,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),

                pw.SizedBox(height: 50),

                // Report period with modern card design
                pw.Container(
                  width: 400,
                  padding: const pw.EdgeInsets.all(30),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(16),
                    ),
                    border: pw.Border.all(color: PdfColors.grey200, width: 1),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'REPORT PERIOD',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey600,
                          letterSpacing: 1.0,
                        ),
                      ),
                      pw.SizedBox(height: 15),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.blue50,
                          borderRadius: const pw.BorderRadius.all(
                            pw.Radius.circular(8),
                          ),
                        ),
                        child: pw.Text(
                          '${DateFormat('MMMM dd, yyyy').format(startDate)} - ${DateFormat('MMMM dd, yyyy').format(endDate)}',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue800,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 40),

                // Footer with branding
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Container(
                      width: 16,
                      height: 16,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.blue800,
                        borderRadius: const pw.BorderRadius.all(
                          pw.Radius.circular(3),
                        ),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'BT',
                          style: pw.TextStyle(
                            fontSize: 6,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Text(
                      'Powered by BizTracker',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFinancialSummary(Map<String, dynamic> reportData) {
    final summary = reportData['financialSummary'];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(
          level: 1,
          child: pw.Text(
            'Financial Summary',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildMetricCard(
                'Total Revenue',
                '\$${NumberFormat('#,##0.00').format(summary['totalRevenue'])}',
                PdfColors.green,
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: _buildMetricCard(
                'Total Expenses',
                '\$${NumberFormat('#,##0.00').format(summary['totalExpenses'])}',
                PdfColors.red,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildMetricCard(
                'Net Profit',
                '\$${NumberFormat('#,##0.00').format(summary['netProfit'])}',
                summary['netProfit'] >= 0 ? PdfColors.green : PdfColors.red,
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: _buildMetricCard(
                'Profit Margin',
                '${summary['profitMargin'].toStringAsFixed(1)}%',
                summary['profitMargin'] >= 0 ? PdfColors.green : PdfColors.red,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Container(
          padding: const pw.EdgeInsets.all(24),
          decoration: pw.BoxDecoration(
            gradient: pw.LinearGradient(
              begin: pw.Alignment.topLeft,
              end: pw.Alignment.bottomRight,
              colors: [PdfColors.blue50, PdfColors.grey50],
            ),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
            border: pw.Border.all(color: PdfColors.blue200, width: 1),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Container(
                    width: 24,
                    height: 24,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue800,
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(6),
                      ),
                    ),
                    child: pw.Center(
                      child: pw.Text('💡', style: pw.TextStyle(fontSize: 12)),
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Text(
                    'KEY BUSINESS INSIGHTS',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _buildInsightItem(
                      '📊',
                      'Sales Volume',
                      '${summary['salesCount']} transactions',
                      PdfColors.green,
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: _buildInsightItem(
                      '💰',
                      'Avg Sale Value',
                      '\$${NumberFormat('#,##0.00').format(summary['totalRevenue'] / (summary['salesCount'] > 0 ? summary['salesCount'] : 1))}',
                      PdfColors.blue,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _buildInsightItem(
                      '📈',
                      'Profit Margin',
                      '${summary['profitMargin'].toStringAsFixed(1)}%',
                      summary['profitMargin'] >= 0
                          ? PdfColors.green
                          : PdfColors.red,
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: _buildInsightItem(
                      '📋',
                      'Expenses',
                      '${summary['expensesCount']} items',
                      PdfColors.orange,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(8),
                  ),
                  border: pw.Border.all(color: PdfColors.grey200, width: 1),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '📋 Executive Summary',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey800,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      summary['netProfit'] >= 0
                          ? '✅ Your business is profitable with a strong ${summary['profitMargin'].toStringAsFixed(1)}% profit margin.'
                          : '⚠️ Your business is currently operating at a loss. Focus on increasing revenue or reducing expenses.',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      '📊 With ${summary['salesCount']} sales transactions, your average sale value is \$${NumberFormat('#,##0.00').format(summary['totalRevenue'] / (summary['salesCount'] > 0 ? summary['salesCount'] : 1))}.',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSalesAnalysis(Map<String, dynamic> reportData) {
    final analysis = reportData['salesAnalysis'];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(
          level: 1,
          child: pw.Text(
            'Sales Analysis',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildMetricCard(
                'Total Sales',
                '\$${NumberFormat('#,##0.00').format(analysis['totalSales'])}',
                PdfColors.green,
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: _buildMetricCard(
                'Sales Count',
                '${analysis['salesCount']}',
                PdfColors.blue,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          'Payment Status Breakdown',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey800,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Status',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Amount',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Count',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Paid'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    '\$${NumberFormat('#,##0.00').format(analysis['totalPaid'])}',
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('${analysis['paidCount']}'),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Credit'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    '\$${NumberFormat('#,##0.00').format(analysis['totalCredit'])}',
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('${analysis['creditCount']}'),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Partial'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    '\$${NumberFormat('#,##0.00').format(analysis['totalPartial'])}',
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('${analysis['partialCount']}'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildExpenseBreakdown(Map<String, dynamic> reportData) {
    final breakdown = reportData['expenseBreakdown'];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(
          level: 1,
          child: pw.Text(
            'Expense Breakdown',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildMetricCard(
                'Total Expenses',
                '\$${NumberFormat('#,##0.00').format(breakdown['totalExpenses'])}',
                PdfColors.red,
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: _buildMetricCard(
                'Expenses Count',
                '${breakdown['expensesCount']}',
                PdfColors.orange,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          'Expense Categories',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey800,
          ),
        ),
        pw.SizedBox(height: 12),
        ...breakdown['categoryBreakdown'].entries
            .map(
              (entry) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 8),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey50,
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(4),
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(entry.key, style: const pw.TextStyle(fontSize: 12)),
                    pw.Text(
                      '\$${NumberFormat('#,##0.00').format(entry.value)}',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.red,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  static pw.Widget _buildInventoryReport(Map<String, dynamic> reportData) {
    final inventory = reportData['inventoryReport'];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(
          level: 1,
          child: pw.Text(
            'Inventory Report',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildMetricCard(
                'Total Items',
                '${inventory['totalItems']}',
                PdfColors.blue,
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: _buildMetricCard(
                'Total Value',
                '\$${NumberFormat('#,##0.00').format(inventory['totalValue'])}',
                PdfColors.green,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildMetricCard(
                'Low Stock Items',
                '${inventory['lowStockItems']}',
                PdfColors.red,
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: _buildMetricCard(
                'Selling Value',
                '\$${NumberFormat('#,##0.00').format(inventory['totalSellingValue'])}',
                PdfColors.green,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          'Inventory Categories',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey800,
          ),
        ),
        pw.SizedBox(height: 12),
        ...inventory['categoryBreakdown'].entries
            .map(
              (entry) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 8),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey50,
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(4),
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(entry.key, style: const pw.TextStyle(fontSize: 12)),
                    pw.Text(
                      '${entry.value} items',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  static pw.Widget _buildPerformanceMetrics(Map<String, dynamic> reportData) {
    final summary = reportData['financialSummary'];
    final analysis = reportData['salesAnalysis'];
    final inventory = reportData['inventoryReport'];

    // Calculate metrics
    final avgSaleValue = analysis['salesCount'] > 0
        ? analysis['totalSales'] / analysis['salesCount']
        : 0.0;
    final collectionRate = analysis['totalSales'] > 0
        ? (analysis['totalPaid'] / analysis['totalSales']) * 100
        : 0.0;
    final inventoryTurnover = inventory['totalValue'] > 0
        ? summary['totalRevenue'] / inventory['totalValue']
        : 0.0;
    final roi = summary['totalCapital'] > 0
        ? (summary['netProfit'] / summary['totalCapital']) * 100
        : 0.0;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(
          level: 1,
          child: pw.Text(
            'Performance Metrics',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildMetricCard(
                'Avg Sale Value',
                '\$${NumberFormat('#,##0.00').format(avgSaleValue)}',
                PdfColors.blue,
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: _buildMetricCard(
                'Collection Rate',
                '${collectionRate.toStringAsFixed(1)}%',
                collectionRate >= 80 ? PdfColors.green : PdfColors.orange,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildMetricCard(
                'Inventory Turnover',
                '${inventoryTurnover.toStringAsFixed(2)}x',
                inventoryTurnover >= 1 ? PdfColors.green : PdfColors.red,
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: _buildMetricCard(
                'ROI',
                '${roi.toStringAsFixed(1)}%',
                roi >= 10 ? PdfColors.green : PdfColors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildCharts(Map<String, dynamic> reportData) {
    final summary = reportData['financialSummary'];
    final analysis = reportData['salesAnalysis'];
    final breakdown = reportData['expenseBreakdown'];
    final inventory = reportData['inventoryReport'];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(
          level: 1,
          child: pw.Text(
            '📊 VISUAL ANALYTICS & DATA INSIGHTS',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
        ),
        pw.SizedBox(height: 20),

        // Modern analytics overview
        pw.Container(
          padding: const pw.EdgeInsets.all(24),
          decoration: pw.BoxDecoration(
            gradient: pw.LinearGradient(
              begin: pw.Alignment.topLeft,
              end: pw.Alignment.bottomRight,
              colors: [PdfColors.grey50, PdfColors.white],
            ),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
            border: pw.Border.all(color: PdfColors.grey200, width: 1),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Container(
                    width: 32,
                    height: 32,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue800,
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(8),
                      ),
                    ),
                    child: pw.Center(
                      child: pw.Text('📈', style: pw.TextStyle(fontSize: 16)),
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Text(
                    'ANALYTICS OVERVIEW',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Chart categories grid
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _buildChartCategory(
                      '💰',
                      'Financial Metrics',
                      'Revenue vs Expenses',
                      PdfColors.green,
                      summary['totalRevenue'] > 0 ||
                          summary['totalExpenses'] > 0,
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    child: _buildChartCategory(
                      '💳',
                      'Payment Analysis',
                      'Methods & Status',
                      PdfColors.blue,
                      analysis['cashSales'] > 0 ||
                          analysis['cardSales'] > 0 ||
                          analysis['bankSales'] > 0,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _buildChartCategory(
                      '📋',
                      'Expense Breakdown',
                      'Category Analysis',
                      PdfColors.orange,
                      breakdown['categoryBreakdown'].isNotEmpty,
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    child: _buildChartCategory(
                      '📦',
                      'Inventory Insights',
                      'Stock Distribution',
                      PdfColors.purple,
                      inventory['categoryBreakdown'].isNotEmpty,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Data insights summary
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(8),
                  ),
                  border: pw.Border.all(color: PdfColors.blue200, width: 1),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '🔍 Key Data Insights',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue800,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      '• ${summary['salesCount']} sales transactions analyzed',
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      '• ${breakdown['expensesCount']} expense items categorized',
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      '• ${inventory['totalItems']} inventory items tracked',
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      '• ${breakdown['categoryBreakdown'].length} expense categories identified',
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      '• ${inventory['categoryBreakdown'].length} inventory categories managed',
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),

              // Chart recommendations
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(8),
                  ),
                  border: pw.Border.all(color: PdfColors.blue100, width: 1),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '💡 Chart Recommendations',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue800,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      '• Use bar charts for revenue vs expenses comparison',
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      '• Pie charts work best for payment method distribution',
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      '• Doughnut charts show payment status breakdown clearly',
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      '• Line charts track sales trends over time effectively',
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildChartCategory(
    String icon,
    String title,
    String subtitle,
    PdfColor color,
    bool hasData,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: hasData ? PdfColors.white : PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(
          color: hasData ? color : PdfColors.grey300,
          width: hasData ? 1 : 0.5,
        ),
      ),
      child: pw.Column(
        children: [
          pw.Text(icon, style: pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 6),
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: hasData ? PdfColors.grey800 : PdfColors.grey500,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            subtitle,
            style: pw.TextStyle(
              fontSize: 9,
              color: hasData ? PdfColors.grey600 : PdfColors.grey400,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 4),
          pw.Container(
            width: 20,
            height: 4,
            decoration: pw.BoxDecoration(
              color: hasData ? color : PdfColors.grey300,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInsightItem(
    String icon,
    String title,
    String value,
    PdfColor color,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: color),
      ),
      child: pw.Column(
        children: [
          pw.Text(icon, style: pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 4),
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildMetricCard(
    String title,
    String value,
    PdfColor color,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        border: pw.Border.all(color: color),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  static Map<String, dynamic> _calculateReportData({
    required List<Sale> sales,
    required List<Expense> expenses,
    required List<Stock> stocks,
    required List<Capital> capitals,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    // Filter data by date range
    final periodSales = sales
        .where(
          (sale) =>
              sale.saleDate.isAfter(
                startDate.subtract(const Duration(days: 1)),
              ) &&
              sale.saleDate.isBefore(endDate.add(const Duration(days: 1))),
        )
        .toList();

    final periodExpenses = expenses
        .where(
          (expense) =>
              expense.expenseDate.isAfter(
                startDate.subtract(const Duration(days: 1)),
              ) &&
              expense.expenseDate.isBefore(
                endDate.add(const Duration(days: 1)),
              ),
        )
        .toList();

    // Financial Summary
    final totalRevenue = periodSales.fold<double>(
      0.0,
      (sum, sale) => sum + sale.totalAmount,
    );
    final totalExpenses = periodExpenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
    final netProfit = totalRevenue - totalExpenses;
    final profitMargin = totalRevenue > 0
        ? (netProfit / totalRevenue) * 100.0
        : 0.0;
    final totalCapital = capitals.fold<double>(
      0.0,
      (sum, capital) => sum + capital.amount,
    );
    final totalStockValue = stocks.fold<double>(
      0.0,
      (sum, stock) => sum + stock.totalValue,
    );

    // Sales Analysis
    final paidSales = periodSales
        .where((sale) => sale.paymentStatus == 'paid')
        .toList();
    final creditSales = periodSales
        .where((sale) => sale.paymentStatus == 'credit')
        .toList();
    final partialSales = periodSales
        .where((sale) => sale.paymentStatus == 'partial')
        .toList();

    final totalPaid = paidSales.fold<double>(
      0.0,
      (sum, sale) => sum + sale.amountPaid,
    );
    final totalCredit = creditSales.fold<double>(
      0.0,
      (sum, sale) => sum + sale.totalAmount,
    );
    final totalPartial = partialSales.fold<double>(
      0.0,
      (sum, sale) => sum + sale.amountPaid,
    );

    final cashSales = periodSales
        .where((sale) => sale.paymentMethod == 'cash')
        .length;
    final cardSales = periodSales
        .where((sale) => sale.paymentMethod == 'card')
        .length;
    final bankSales = periodSales
        .where((sale) => sale.paymentMethod == 'bank_transfer')
        .length;

    // Expense Breakdown
    final categoryMap = <String, double>{};
    for (final expense in periodExpenses) {
      categoryMap[expense.category] =
          (categoryMap[expense.category] ?? 0.0) + expense.amount;
    }

    // Inventory Report
    final totalItems = stocks.length;
    final totalCost = stocks.fold<double>(
      0.0,
      (sum, stock) => sum + (stock.quantity * stock.unitCostPrice),
    );
    final totalSellingValue = stocks.fold<double>(
      0.0,
      (sum, stock) => sum + (stock.quantity * stock.unitSellingPrice),
    );
    final lowStockItems = stocks
        .where((stock) => stock.quantity <= stock.reorderLevel)
        .length;

    final inventoryCategoryMap = <String, int>{};
    for (final stock in stocks) {
      inventoryCategoryMap[stock.category] =
          (inventoryCategoryMap[stock.category] ?? 0) + 1;
    }

    return {
      'financialSummary': {
        'totalRevenue': totalRevenue,
        'totalExpenses': totalExpenses,
        'netProfit': netProfit,
        'profitMargin': profitMargin,
        'totalCapital': totalCapital,
        'totalStockValue': totalStockValue,
        'salesCount': periodSales.length,
        'expensesCount': periodExpenses.length,
      },
      'salesAnalysis': {
        'totalSales': totalRevenue,
        'totalPaid': totalPaid,
        'totalCredit': totalCredit,
        'totalPartial': totalPartial,
        'salesCount': periodSales.length,
        'paidCount': paidSales.length,
        'creditCount': creditSales.length,
        'partialCount': partialSales.length,
        'cashSales': cashSales,
        'cardSales': cardSales,
        'bankSales': bankSales,
      },
      'expenseBreakdown': {
        'totalExpenses': totalExpenses,
        'expensesCount': periodExpenses.length,
        'categoryBreakdown': categoryMap,
      },
      'inventoryReport': {
        'totalItems': totalItems,
        'totalValue': totalStockValue,
        'totalCost': totalCost,
        'totalSellingValue': totalSellingValue,
        'lowStockItems': lowStockItems,
        'categoryBreakdown': inventoryCategoryMap,
      },
    };
  }

  static Future<void> _saveAndSharePdf(
    pw.Document pdf,
    String businessName,
  ) async {
    try {
      final output = await getTemporaryDirectory();
      final file = File(
        '${output.path}/business_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Business Report for $businessName',
        subject: 'BizTracker Business Report',
      );
    } catch (e) {
      throw Exception('Failed to save and share PDF: $e');
    }
  }
}
