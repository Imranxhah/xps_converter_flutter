class ApiConstants {
  // Base URL - Change this to your local IP address
  // For Android Emulator: use 10.0.2.2
  // For iOS Simulator: use localhost or 127.0.0.1
  // For Physical Device: use your computer's IP address (e.g., 192.168.1.100)
  static const String baseUrl =
      'https://xpsreader.pythonanywhere.com'; // Change this to your IP

  // API Endpoints
  static const String convertToImages = '/api/convert/to-images/';
  static const String convertToPdf = '/api/convert/to-pdf/';
  static const String convertToDocx = '/api/convert/to-docx/';
  static const String extractText = '/api/convert/read-text/';

  // Settings
  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB
  static const int maxPages = 100;
  static const int timeoutSeconds = 60;

  // Get full URL
  static String getFullUrl(String endpoint) => baseUrl + endpoint;
}
