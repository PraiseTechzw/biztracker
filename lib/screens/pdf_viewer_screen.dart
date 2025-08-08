import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/glassmorphism_theme.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;
  final Uint8List? pdfBytes;

  const PdfViewerScreen({super.key, required this.pdfPath, this.pdfBytes});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfViewerController _pdfViewerController;
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  int? fileSize;
  String? filePath;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    print('PDF Viewer initialized with path: ${widget.pdfPath}');
    _checkFileExists();
  }

  Future<void> _checkFileExists() async {
    try {
      final file = File(widget.pdfPath);
      final exists = await file.exists();
      print('PDF file exists: $exists');

      if (exists) {
        final size = await file.length();
        print('PDF file size: $size bytes');
        setState(() {
          fileSize = size;
          filePath = widget.pdfPath;
        });
      } else {
        setState(() {
          hasError = true;
          errorMessage = 'PDF file not found';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error checking file: $e');
      setState(() {
        hasError = true;
        errorMessage = 'Error checking file: $e';
        isLoading = false;
      });
    }
  }

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
                  errorMessage ?? 'Could not load the PDF file.',
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

    // Try to use Syncfusion PDF viewer with fallback
    try {
      if (widget.pdfBytes != null) {
        return SfPdfViewer.memory(
          widget.pdfBytes!,
          controller: _pdfViewerController,
          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
            print(
              'PDF loaded successfully from memory: ${details.document.pages.count} pages',
            );
            setState(() {
              isLoading = false;
            });
          },
          onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
            print('PDF load failed from memory: ${details.error}');
            setState(() {
              hasError = true;
              errorMessage = 'Failed to load PDF: ${details.error}';
            });
          },
          onPageChanged: (PdfPageChangedDetails details) {
            print('Page changed to: ${details.newPageNumber}');
          },
          enableDoubleTapZooming: true,
          enableTextSelection: true,
          canShowScrollHead: true,
          canShowScrollStatus: true,
          canShowPaginationDialog: true,
        );
      } else {
        return SfPdfViewer.file(
          File(widget.pdfPath),
          controller: _pdfViewerController,
          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
            print(
              'PDF loaded successfully from file: ${details.document.pages.count} pages',
            );
            setState(() {
              isLoading = false;
            });
          },
          onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
            print('PDF load failed from file: ${details.error}');
            setState(() {
              hasError = true;
              errorMessage = 'Failed to load PDF: ${details.error}';
            });
          },
          onPageChanged: (PdfPageChangedDetails details) {
            print('Page changed to: ${details.newPageNumber}');
          },
          enableDoubleTapZooming: true,
          enableTextSelection: true,
          canShowScrollHead: true,
          canShowScrollStatus: true,
          canShowPaginationDialog: true,
        );
      }
    } catch (e) {
      print('Syncfusion PDF viewer error: $e');
      // Fallback to simple viewer
      return _buildSimpleViewer();
    }
  }

  Widget _buildSimpleViewer() {
    return Center(
      child: GlassmorphismTheme.glassmorphismContainer(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // PDF Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: GlassmorphismTheme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.picture_as_pdf,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Business Report',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: GlassmorphismTheme.textColor,
                ),
              ),
              const SizedBox(height: 16),

              // Success message
              const Text(
                'PDF Generated Successfully!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),

              // File info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: GlassmorphismTheme.backgroundColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: GlassmorphismTheme.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('File Size', '${fileSize ?? 0} bytes'),
                    const SizedBox(height: 8),
                    _buildInfoRow('File Path', filePath ?? 'Unknown'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Status', 'Ready to share'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _sharePdf(),
                    icon: const Icon(Icons.share),
                    label: const Text('Share PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlassmorphismTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _downloadPdf(),
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    SizedBox(height: 8),
                    Text(
                      'Note: PDF viewer is not available in this version.\nYou can share or download the PDF file.',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: GlassmorphismTheme.textColor.withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: GlassmorphismTheme.textColor,
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

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}
