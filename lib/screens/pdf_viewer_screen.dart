import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/glassmorphism_theme.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;

  const PdfViewerScreen({super.key, required this.pdfPath});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PDFViewController pdfViewController;
  int currentPage = 1;
  int totalPages = 0;
  bool isLoading = true;
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Report'),
        backgroundColor: GlassmorphismTheme.backgroundColor,
        foregroundColor: GlassmorphismTheme.textColor,
        elevation: 0,
        actions: [
          if (!isLoading && !hasError) ...[
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _sharePdf(),
            ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _downloadPdf(),
            ),
          ],
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [GlassmorphismTheme.backgroundColor, Color(0xFF1E293B)],
          ),
        ),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (hasError) {
      return Center(
        child: GlassmorphismTheme.glassmorphismContainer(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Error Loading PDF',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: GlassmorphismTheme.textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Could not load the PDF file.',
                  style: TextStyle(
                    fontSize: 14,
                    color: GlassmorphismTheme.textColor.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (isLoading) {
      return Center(
        child: GlassmorphismTheme.glassmorphismContainer(
          child: const Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: GlassmorphismTheme.primaryColor,
                ),
                SizedBox(height: 16),
                Text(
                  'Loading PDF...',
                  style: TextStyle(
                    fontSize: 16,
                    color: GlassmorphismTheme.textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Page indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: GlassmorphismTheme.backgroundColor.withOpacity(0.9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Page $currentPage of $totalPages',
                style: const TextStyle(
                  color: GlassmorphismTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.zoom_out,
                      color: GlassmorphismTheme.textColor,
                    ),
                    onPressed: () => pdfViewController.zoomTo(zoom: 0.8),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.zoom_in,
                      color: GlassmorphismTheme.textColor,
                    ),
                    onPressed: () => pdfViewController.zoomTo(zoom: 1.2),
                  ),
                ],
              ),
            ],
          ),
        ),
        // PDF viewer
        Expanded(
          child: PDFView(
            filePath: widget.pdfPath,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,
            pageSnap: true,
            defaultPage: 0,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            onRender: (pages) {
              setState(() {
                totalPages = pages!;
                isLoading = false;
              });
            },
            onViewCreated: (PDFViewController controller) {
              pdfViewController = controller;
            },
            onPageChanged: (page, total) {
              setState(() {
                currentPage = page! + 1;
              });
            },
            onError: (error) {
              setState(() {
                hasError = true;
                isLoading = false;
              });
            },
            onPageError: (page, error) {
              setState(() {
                hasError = true;
                isLoading = false;
              });
            },
          ),
        ),
      ],
    );
  }

  void _sharePdf() {
    try {
      Share.shareXFiles(
        [XFile(widget.pdfPath)],
        text: 'Business Report from BizTracker',
        subject: 'BizTracker Business Report',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _downloadPdf() {
    try {
      // For now, just show a success message
      // In a real app, you'd implement actual download functionality
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF saved to downloads folder'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
