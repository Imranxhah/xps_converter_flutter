import 'dart:io';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/file_service.dart';
import '../models/api_models.dart';

enum ConversionType { images, pdf, docx, text }

enum AppStep { selectType, pickFile, converting, result }

class ConverterProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FileService _fileService = FileService();

  File? _selectedFile;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  ConversionType? _selectedConversionType;
  AppStep _currentStep = AppStep.selectType;

  // Conversion results
  ImageResponse? _imageResponse;
  PdfResponse? _pdfResponse;
  DocxResponse? _docxResponse;
  TextResponse? _textResponse;

  // Image selection for batch download
  final Set<int> _selectedImageIndices = {};

  // Getters
  File? get selectedFile => _selectedFile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  ConversionType? get selectedConversionType => _selectedConversionType;
  AppStep get currentStep => _currentStep;
  ImageResponse? get imageResponse => _imageResponse;
  PdfResponse? get pdfResponse => _pdfResponse;
  DocxResponse? get docxResponse => _docxResponse;
  TextResponse? get textResponse => _textResponse;
  Set<int> get selectedImageIndices => _selectedImageIndices;

  // Select conversion type
  void selectConversionType(ConversionType type) {
    _selectedConversionType = type;
    _currentStep = AppStep.pickFile;
    _clearMessages();
    _clearResults();
    notifyListeners();
  }

  // Pick file and start conversion
  Future<void> pickFileAndConvert() async {
    try {
      _clearMessages();
      final file = await _fileService.pickXpsFile();
      if (file != null) {
        _selectedFile = file;
        _currentStep = AppStep.converting;
        notifyListeners();

        // Start conversion based on selected type
        await _performConversion();
      } else {
        // User cancelled file selection
        _currentStep = AppStep.selectType;
        _selectedConversionType = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _currentStep = AppStep.selectType;
      _selectedConversionType = null;
      notifyListeners();
    }
  }

  // Perform conversion based on type
  Future<void> _performConversion() async {
    if (_selectedFile == null || _selectedConversionType == null) return;

    _setLoading(true);
    _clearMessages();

    try {
      switch (_selectedConversionType!) {
        case ConversionType.images:
          await _convertToImages();
          break;
        case ConversionType.pdf:
          await _convertToPdf();
          break;
        case ConversionType.docx:
          await _convertToDocx();
          break;
        case ConversionType.text:
          await _extractText();
          break;
      }

      if (_errorMessage == null) {
        _currentStep = AppStep.result;
      } else {
        _currentStep = AppStep.selectType;
        _selectedConversionType = null;
        _selectedFile = null;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      _currentStep = AppStep.selectType;
      _selectedConversionType = null;
      _selectedFile = null;
    } finally {
      _setLoading(false);
    }
  }

  // Convert to images
  Future<void> _convertToImages() async {
    try {
      _imageResponse = await _apiService.convertToImages(_selectedFile!);

      if (_imageResponse!.success) {
        _successMessage = _imageResponse!.message;
      } else {
        _errorMessage = _imageResponse!.error ?? 'Conversion failed';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    }
  }

  // Convert to PDF
  Future<void> _convertToPdf() async {
    try {
      _pdfResponse = await _apiService.convertToPdf(_selectedFile!);

      if (_pdfResponse!.success) {
        _successMessage = _pdfResponse!.message;
      } else {
        _errorMessage = _pdfResponse!.error ?? 'Conversion failed';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    }
  }

  // Convert to DOCX
  Future<void> _convertToDocx() async {
    try {
      _docxResponse = await _apiService.convertToDocx(_selectedFile!);

      if (_docxResponse!.success) {
        _successMessage = _docxResponse!.message;
      } else {
        _errorMessage = _docxResponse!.error ?? 'Conversion failed';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    }
  }

  // Extract text
  Future<void> _extractText() async {
    try {
      _textResponse = await _apiService.extractText(_selectedFile!);

      if (_textResponse!.success) {
        _successMessage = _textResponse!.message;
      } else {
        _errorMessage = _textResponse!.error ?? 'Text extraction failed';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    }
  }

  // Toggle image selection
  void toggleImageSelection(int index) {
    if (_selectedImageIndices.contains(index)) {
      _selectedImageIndices.remove(index);
    } else {
      _selectedImageIndices.add(index);
    }
    notifyListeners();
  }

  // Select all images
  void selectAllImages() {
    if (_imageResponse?.images != null) {
      _selectedImageIndices.clear();
      _selectedImageIndices
          .addAll(List.generate(_imageResponse!.images!.length, (i) => i));
      notifyListeners();
    }
  }

  // Deselect all images
  void deselectAllImages() {
    _selectedImageIndices.clear();
    notifyListeners();
  }

  // Download file
  Future<String?> downloadFile(String url, String fileName) async {
    try {
      final savePath = await _fileService.saveToDownloads(url, fileName);
      if (savePath != null) {
        final downloadedPath = await _apiService.downloadFile(url, savePath);
        return downloadedPath;
      }
      return null;
    } catch (e) {
      _errorMessage = 'Download failed: $e';
      notifyListeners();
      return null;
    }
  }

  // Open file
  Future<void> openFile(String filePath) async {
    try {
      await _fileService.openFile(filePath);
    } catch (e) {
      _errorMessage = 'Failed to open file: $e';
      notifyListeners();
    }
  }

  // Get file info
  String getFileName() {
    if (_selectedFile == null) return '';
    return _fileService.getFileName(_selectedFile!.path);
  }

  Future<String> getFileSize() async {
    if (_selectedFile == null) return '';
    final size = await _selectedFile!.length();
    return _fileService.getFileSize(size);
  }

  // Reset to beginning
  void reset() {
    _selectedFile = null;
    _selectedConversionType = null;
    _currentStep = AppStep.selectType;
    _selectedImageIndices.clear();
    _clearResults();
    _clearMessages();
    notifyListeners();
  }

  // Go back one step
  void goBack() {
    switch (_currentStep) {
      case AppStep.pickFile:
        _currentStep = AppStep.selectType;
        _selectedConversionType = null;
        break;
      case AppStep.result:
        _currentStep = AppStep.selectType;
        _selectedFile = null;
        _selectedConversionType = null;
        _clearResults();
        break;
      default:
        break;
    }
    _clearMessages();
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  void _clearResults() {
    _imageResponse = null;
    _pdfResponse = null;
    _docxResponse = null;
    _textResponse = null;
    _selectedImageIndices.clear();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }
}
