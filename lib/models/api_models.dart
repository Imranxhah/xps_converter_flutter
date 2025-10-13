// Image Response Model
class ImageResponse {
  final bool success;
  final String message;
  final int? totalPages;
  final List<String>? images;
  final String? error;

  ImageResponse({
    required this.success,
    required this.message,
    this.totalPages,
    this.images,
    this.error,
  });

  factory ImageResponse.fromJson(Map<String, dynamic> json) {
    return ImageResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? json['error'] ?? '',
      totalPages: json['total_pages'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      error: json['error'],
    );
  }
}

// PDF Response Model
class PdfResponse {
  final bool success;
  final String message;
  final int? totalPages;
  final String? pdfUrl;
  final String? error;

  PdfResponse({
    required this.success,
    required this.message,
    this.totalPages,
    this.pdfUrl,
    this.error,
  });

  factory PdfResponse.fromJson(Map<String, dynamic> json) {
    return PdfResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? json['error'] ?? '',
      totalPages: json['total_pages'],
      pdfUrl: json['pdf_url'],
      error: json['error'],
    );
  }
}

// DOCX Response Model
class DocxResponse {
  final bool success;
  final String message;
  final int? totalPages;
  final String? docxUrl;
  final String? error;

  DocxResponse({
    required this.success,
    required this.message,
    this.totalPages,
    this.docxUrl,
    this.error,
  });

  factory DocxResponse.fromJson(Map<String, dynamic> json) {
    return DocxResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? json['error'] ?? '',
      totalPages: json['total_pages'],
      docxUrl: json['docx_url'],
      error: json['error'],
    );
  }
}

// Text Content Model
class TextContent {
  final int page;
  final String text;

  TextContent({
    required this.page,
    required this.text,
  });

  factory TextContent.fromJson(Map<String, dynamic> json) {
    return TextContent(
      page: json['page'],
      text: json['text'],
    );
  }
}

// Text Response Model
class TextResponse {
  final bool success;
  final String message;
  final int? totalPages;
  final List<TextContent>? textContent;
  final String? error;

  TextResponse({
    required this.success,
    required this.message,
    this.totalPages,
    this.textContent,
    this.error,
  });

  factory TextResponse.fromJson(Map<String, dynamic> json) {
    return TextResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? json['error'] ?? '',
      totalPages: json['total_pages'],
      textContent: json['text_content'] != null
          ? (json['text_content'] as List)
              .map((item) => TextContent.fromJson(item))
              .toList()
          : null,
      error: json['error'],
    );
  }
}
