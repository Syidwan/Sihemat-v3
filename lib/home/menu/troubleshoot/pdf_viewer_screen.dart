import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class PDFViewerScreen extends StatefulWidget {
  final String title;
  final String? pdfUrl;
  final String? pdfAsset;

  const PDFViewerScreen({
    Key? key,
    required this.title,
    this.pdfUrl,
    this.pdfAsset,
  }) : super(key: key);

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? localPath;
  bool isLoading = true;
  String? errorMessage;
  int currentPage = 0;
  int totalPages = 0;

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    try {
      if (widget.pdfAsset != null) {
        // Load dari asset
        await _loadFromAsset();
      } else if (widget.pdfUrl != null) {
        // Download dari URL
        await _downloadPDF();
      } else {
        setState(() {
          errorMessage = 'No PDF source provided';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading PDF: $e';
        isLoading = false;
      });
    }
  }

Future<void> _loadFromAsset() async {
  try {
    print('🔍 Trying to load: ${widget.pdfAsset}');

    // Load bytes dari assets
    final byteData = await rootBundle.load(widget.pdfAsset!);
    print('✅ Asset loaded! Size: ${byteData.lengthInBytes} bytes');

    // Ambil nama file dari path
    final filename = widget.pdfAsset!.split('/').last;

    // Buat file sementara
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');

    await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
    print('✅ File written to: ${file.path}');

    if (!mounted) return;

    setState(() {
      localPath = file.path;
      isLoading = false;
    });

    print('✅ PDF ready to display!');
  } catch (e) {
    print('❌ Error loading asset: $e');
    setState(() {
      errorMessage = 'Error loading asset: $e';
      isLoading = false;
    });
  }
}

  Future<void> _downloadPDF() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl!));
      
      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/downloaded.pdf');
        await file.writeAsBytes(response.bodyBytes);
        
        setState(() {
          localPath = file.path;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to download PDF: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error downloading PDF: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE53935),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (totalPages > 0)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${currentPage + 1} / $totalPages',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFE53935),
            ),
            SizedBox(height: 16),
            Text(
              'Loading PDF...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });
                _loadPDF();
              },
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE53935),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    if (localPath == null) {
      return Center(
        child: Text(
          'No PDF to display',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    return PDFView(
      filePath: localPath,
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
          totalPages = pages ?? 0;
        });
      },
      onError: (error) {
        setState(() {
          errorMessage = error.toString();
        });
      },
      onPageError: (page, error) {
        setState(() {
          errorMessage = 'Error on page $page: $error';
        });
      },
      onViewCreated: (PDFViewController controller) {
        // PDF controller ready
      },
      onPageChanged: (int? page, int? total) {
        setState(() {
          currentPage = page ?? 0;
        });
      },
    );
  }
}