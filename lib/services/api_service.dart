import 'dart:io';
import 'package:dio/dio.dart';
import '../config/api_constants.dart';
import '../models/api_models.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(seconds: ApiConstants.timeoutSeconds),
      receiveTimeout: Duration(seconds: ApiConstants.timeoutSeconds),
    ));
  }

  // Convert XPS to Images
  Future<ImageResponse> convertToImages(File xpsFile) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          xpsFile.path,
          filename: xpsFile.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        ApiConstants.convertToImages,
        data: formData,
      );

      return ImageResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e, 'Image');
    }
  }

  // Convert XPS to PDF
  Future<PdfResponse> convertToPdf(File xpsFile) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          xpsFile.path,
          filename: xpsFile.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        ApiConstants.convertToPdf,
        data: formData,
      );

      return PdfResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handlePdfError(e);
    }
  }

  // Convert XPS to DOCX
  Future<DocxResponse> convertToDocx(File xpsFile) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          xpsFile.path,
          filename: xpsFile.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        ApiConstants.convertToDocx,
        data: formData,
      );

      return DocxResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleDocxError(e);
    }
  }

  // Extract Text from XPS
  Future<TextResponse> extractText(File xpsFile) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          xpsFile.path,
          filename: xpsFile.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        ApiConstants.extractText,
        data: formData,
      );

      return TextResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleTextError(e);
    }
  }

  // Download file from URL
  Future<String?> downloadFile(String url, String savePath) async {
    try {
      await _dio.download(url, savePath);
      return savePath;
    } catch (e) {
      print('Download error: $e');
      return null;
    }
  }

  // Error handlers
  ImageResponse _handleError(DioException e, String type) {
    String errorMessage = 'Failed to convert to $type';

    if (e.response != null) {
      errorMessage = e.response?.data['error'] ??
          e.response?.data['message'] ??
          errorMessage;
    } else if (e.type == DioExceptionType.connectionTimeout) {
      errorMessage = 'Connection timeout. Please check your connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      errorMessage =
          'Cannot connect to server. Please check if the server is running.';
    }

    return ImageResponse(
      success: false,
      message: errorMessage,
      error: errorMessage,
    );
  }

  PdfResponse _handlePdfError(DioException e) {
    String errorMessage = 'Failed to convert to PDF';

    if (e.response != null) {
      errorMessage = e.response?.data['error'] ??
          e.response?.data['message'] ??
          errorMessage;
    } else if (e.type == DioExceptionType.connectionTimeout) {
      errorMessage = 'Connection timeout. Please check your connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      errorMessage =
          'Cannot connect to server. Please check if the server is running.';
    }

    return PdfResponse(
      success: false,
      message: errorMessage,
      error: errorMessage,
    );
  }

  DocxResponse _handleDocxError(DioException e) {
    String errorMessage = 'Failed to convert to DOCX';

    if (e.response != null) {
      errorMessage = e.response?.data['error'] ??
          e.response?.data['message'] ??
          errorMessage;
    } else if (e.type == DioExceptionType.connectionTimeout) {
      errorMessage = 'Connection timeout. Please check your connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      errorMessage =
          'Cannot connect to server. Please check if the server is running.';
    }

    return DocxResponse(
      success: false,
      message: errorMessage,
      error: errorMessage,
    );
  }

  TextResponse _handleTextError(DioException e) {
    String errorMessage = 'Failed to extract text';

    if (e.response != null) {
      errorMessage = e.response?.data['error'] ??
          e.response?.data['message'] ??
          errorMessage;
    } else if (e.type == DioExceptionType.connectionTimeout) {
      errorMessage = 'Connection timeout. Please check your connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      errorMessage =
          'Cannot connect to server. Please check if the server is running.';
    }

    return TextResponse(
      success: false,
      message: errorMessage,
      error: errorMessage,
    );
  }
}
