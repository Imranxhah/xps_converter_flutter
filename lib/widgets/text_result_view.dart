import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/api_models.dart';
import '../providers/converter_provider.dart';

class TextResultView extends StatefulWidget {
  final TextResponse response;

  const TextResultView({Key? key, required this.response}) : super(key: key);

  @override
  State<TextResultView> createState() => _TextResultViewState();
}

class _TextResultViewState extends State<TextResultView> {
  bool _isConverting = false;
  List<String>? _pageImages;

  @override
  void initState() {
    super.initState();
    _convertToImages();
  }

  Future<void> _convertToImages() async {
    setState(() => _isConverting = true);

    try {
      final provider = context.read<ConverterProvider>();

      // Convert to images to display pages
      if (provider.selectedFile != null) {
        final imageResponse =
            await provider.downloadFile('', ''); // Trigger conversion

        // In real implementation, you would call the images API here
        // For now, we'll show text content
      }
    } catch (e) {
      debugPrint('Error converting to images: $e');
    } finally {
      setState(() => _isConverting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isConverting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.response.textContent?.length ?? 0,
      itemBuilder: (context, index) {
        final content = widget.response.textContent![index];
        return _PageTextCard(
          content: content,
          pageNumber: content.page,
        );
      },
    );
  }
}

class _PageTextCard extends StatelessWidget {
  final TextContent content;
  final int pageNumber;

  const _PageTextCard({
    Key? key,
    required this.content,
    required this.pageNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$pageNumber',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Page $pageNumber',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${content.text.length} characters',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Text content
          Padding(
            padding: const EdgeInsets.all(20),
            child: SelectableText(
              content.text.isEmpty
                  ? 'No text found on this page'
                  : content.text,
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
