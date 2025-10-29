class PDFConfig {
  // Base URL untuk PDF online
  static const String BASE_URL = 'https://example.com/pdf';
  
  // PDF URLs
  static const Map<String, String> PDF_URLS = {
    'motor_listrik': '$BASE_URL/troubleshoot-motor-listrik.pdf',
    'motor_bensin': '$BASE_URL/troubleshoot-motor-bensin.pdf',
    'mobil_listrik': '$BASE_URL/troubleshoot-mobil-listrik.pdf',
    'mobil_bensin': 'https://microsite.mitsubishi-motors.co.id/owner-manual/media/file/originals/post/2023/01/16/owners-manual-xpander-23-model-year-rev-1310221.pdf',
    'mobil_hybrid': '$BASE_URL/troubleshoot-mobil-hybrid.pdf',
  };
  
  // Asset paths (jika menggunakan lokal)
  static const Map<String, String> PDF_ASSETS = {
    'motor_listrik': 'assets/pdf/troubleshoot-motor-listrik.pdf',
    'motor_bensin': 'assets/pdf/troubleshoot-motor-bensin.pdf',
    'mobil_listrik': 'assets/pdf/troubleshoot-mobil-listrik.pdf',
    'mobil_bensin': 'assets/pdf/troubleshoot-mobil-bensin.pdf',
    'mobil_hybrid': 'assets/pdf/troubleshoot-mobil-hybrid.pdf',
  };
  
  // Get URL by ID
  static String? getPDFUrl(String id) {
    return PDF_URLS[id];
  }
  
  // Get asset path by ID
  static String? getPDFAsset(String id) {
    return PDF_ASSETS[id];
  }
}