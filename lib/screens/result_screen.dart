import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/converter_provider.dart';
import '../widgets/image_gallery_view.dart';
import '../widgets/pdf_result_view.dart';
import '../widgets/docx_result_view.dart';
import '../widgets/text_result_view.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConverterProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // Header with back button
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: provider.reset,
                    tooltip: 'Back to home',
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTitle(provider.selectedConversionType),
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Conversion completed successfully',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Result content
            Expanded(
              child: _buildResultContent(provider),
            ),
          ],
        );
      },
    );
  }

  String _getTitle(ConversionType? type) {
    switch (type) {
      case ConversionType.images:
        return 'Converted Images';
      case ConversionType.pdf:
        return 'PDF Document';
      case ConversionType.docx:
        return 'DOCX Document';
      case ConversionType.text:
        return 'Extracted Text';
      default:
        return 'Result';
    }
  }

  Widget _buildResultContent(ConverterProvider provider) {
    // Show images in gallery view
    if (provider.imageResponse != null && provider.imageResponse!.success) {
      return ImageGalleryView(response: provider.imageResponse!);
    }

    // Show PDF result
    if (provider.pdfResponse != null && provider.pdfResponse!.success) {
      return PdfResultView(response: provider.pdfResponse!);
    }

    // Show DOCX result
    if (provider.docxResponse != null && provider.docxResponse!.success) {
      return DocxResultView(response: provider.docxResponse!);
    }

    // Show text result (images in column)
    if (provider.textResponse != null && provider.textResponse!.success) {
      return TextResultView(response: provider.textResponse!);
    }

    // Error state
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No result available',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
