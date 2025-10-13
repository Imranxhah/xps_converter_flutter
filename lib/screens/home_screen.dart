import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// --------------------------------------------------------------------------
// MOCK CLASSES/ENUMS (For demonstration, replace with your actual files)
// --------------------------------------------------------------------------

enum AppStep { selection, converting, result }

class ConverterProvider with ChangeNotifier {
  AppStep currentStep = AppStep.selection;
  String? successMessage;
  String? selectedFile = 'document.xps'; // Mock file
  String? convertedFile = 'document.pdf'; // Mock result

  void startConversion() {
    currentStep = AppStep.converting;
    notifyListeners();
    // Simulate conversion delay
    Future.delayed(const Duration(seconds: 3), () {
      successMessage = 'Conversion complete! Your file is ready for download.';
      currentStep = AppStep.result;
      notifyListeners();
    });
  }

  void clearSuccess() {
    successMessage = null;
    notifyListeners();
  }

  void reset() {
    selectedFile = null;
    convertedFile = null;
    successMessage = null;
    currentStep = AppStep.selection;
    notifyListeners();
  }

  String getFileName() => selectedFile ?? 'No file selected';
}

class ThemeProvider with ChangeNotifier {
  bool isDarkMode = true;
  ThemeData get themeData => isDarkMode ? ThemeData.dark() : ThemeData.light();
  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

class TypeSelectionScreen extends StatelessWidget {
  const TypeSelectionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ConverterProvider>(context, listen: false);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Select XPS File',
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: provider.startConversion,
            icon: const Icon(Icons.upload_file),
            label: const Text('Simulate File Upload & Convert'),
          ),
        ],
      ),
    );
  }
}

// ResultDisplay placeholder - This was missing in your original code
class ResultDisplay extends StatelessWidget {
  const ResultDisplay({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ConverterProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conversion Details',
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 24),
          _buildDetailRow(
              context, 'Original File:', provider.selectedFile ?? 'N/A'),
          _buildDetailRow(
              context, 'Converted File:', provider.convertedFile ?? 'N/A'),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // In a real app, this would trigger a file download
                provider.reset();
              },
              icon: const Icon(Icons.download),
              label: const Text('Download Converted File'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          Text(value, style: GoogleFonts.inter()),
        ],
      ),
    );
  }
}

// ResultScreen placeholder - Replaced by _buildResultContent in final version
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // This is now handled by _buildResultContent, but kept for import structure
    return const Center(child: Text('Result Content Placeholder'));
  }
}

// --------------------------------------------------------------------------
// CORRECTED HOMESCREEN CLASS
// --------------------------------------------------------------------------

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'XPS Converter',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                onPressed: themeProvider.toggleTheme,
                tooltip: themeProvider.isDarkMode
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
              );
            },
          ),
          // CORRECTED: The const SizedBox was already correctly spelled here.
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<ConverterProvider>(
        builder: (context, provider, child) {
          // Show loading during conversion
          if (provider.currentStep == AppStep.converting) {
            return _buildLoadingScreen(context, provider);
          }

          // Show result content (The malformed code was fixed and placed here)
          if (provider.currentStep == AppStep.result) {
            return _buildResultContent(context, provider);
          }

          // Show type selection (default)
          return const TypeSelectionScreen();
        },
      ),
    );
  }

  Widget _buildLoadingScreen(BuildContext context, ConverterProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Converting...',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Please wait while we process your file',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (provider.selectedFile != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                provider.getFileName(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  // NEW METHOD: Contains the corrected logic from the broken block at the end
  Widget _buildResultContent(BuildContext context, ConverterProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // CORRECTED: Success Message Card logic (used proper `if` statement and widget assignment)
          if (provider.successMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Card(
                color: Colors.green.shade50,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.green.shade200, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: Colors.green.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          provider.successMessage!,
                          style: GoogleFonts.inter(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: provider.clearSuccess,
                        color: Colors.green.shade700,
                        splashRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // CORRECTED: Result Display logic (used proper widget instantiation)
          const ResultDisplay(),
        ],
      ),
    );
  }
}
