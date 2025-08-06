import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../utils/glassmorphism_theme.dart';
import '../utils/toast_utils.dart';

class BarcodeScannerScreen extends StatefulWidget {
  final String title;
  final String? initialValue;

  const BarcodeScannerScreen({
    super.key,
    required this.title,
    this.initialValue,
  });

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanning = true;
  String? scannedCode;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      scannedCode = widget.initialValue;
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null && isScanning) {
        setState(() {
          scannedCode = barcode.rawValue;
          isScanning = false;
        });

        // Vibrate or show feedback
        ToastUtils.showSuccessToast('Barcode detected: ${barcode.rawValue}');

        // Stop scanning after successful detection
        cameraController.stop();

        // Return the scanned value
        Navigator.pop(context, barcode.rawValue);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isScanning ? Icons.stop : Icons.play_arrow,
              color: GlassmorphismTheme.textColor,
            ),
            onPressed: () {
              setState(() {
                if (isScanning) {
                  cameraController.stop();
                  isScanning = false;
                } else {
                  cameraController.start();
                  isScanning = true;
                }
              });
            },
          ),
          IconButton(
            icon: Icon(
              cameraController.torchEnabled ? Icons.flash_on : Icons.flash_off,
              color: GlassmorphismTheme.textColor,
            ),
            onPressed: () {
              cameraController.toggleTorch();
            },
          ),
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
        child: Column(
          children: [
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              child: GlassmorphismTheme.glassmorphismContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      color: GlassmorphismTheme.primaryColor,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Position the barcode within the frame',
                      style: TextStyle(
                        color: GlassmorphismTheme.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'The scanner will automatically detect barcodes and QR codes',
                      style: TextStyle(
                        color: GlassmorphismTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Scanner
            Expanded(
              child: Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    onDetect: _onDetect,
                  ),

                  // Scanning overlay
                  if (isScanning)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: GlassmorphismTheme.primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.all(40),
                      child: Stack(
                        children: [
                          // Corner indicators
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: GlassmorphismTheme.primaryColor,
                                    width: 3,
                                  ),
                                  left: BorderSide(
                                    color: GlassmorphismTheme.primaryColor,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: GlassmorphismTheme.primaryColor,
                                    width: 3,
                                  ),
                                  right: BorderSide(
                                    color: GlassmorphismTheme.primaryColor,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: GlassmorphismTheme.primaryColor,
                                    width: 3,
                                  ),
                                  left: BorderSide(
                                    color: GlassmorphismTheme.primaryColor,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: GlassmorphismTheme.primaryColor,
                                    width: 3,
                                  ),
                                  right: BorderSide(
                                    color: GlassmorphismTheme.primaryColor,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Manual entry option
            Container(
              padding: const EdgeInsets.all(16),
              child: GlassmorphismTheme.glassmorphismContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Or enter manually',
                      style: TextStyle(
                        color: GlassmorphismTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter barcode manually',
                              hintStyle: TextStyle(
                                color: GlassmorphismTheme.textSecondaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: GlassmorphismTheme.surfaceColor
                                  .withOpacity(0.3),
                            ),
                            style: TextStyle(
                              color: GlassmorphismTheme.textColor,
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                Navigator.pop(context, value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            final textField =
                                context.findRenderObject() as RenderBox?;
                            if (textField != null) {
                              final text = (textField as dynamic).text;
                              if (text != null && text.isNotEmpty) {
                                Navigator.pop(context, text);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GlassmorphismTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Use'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
