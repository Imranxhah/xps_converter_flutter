import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/api_models.dart';
import '../providers/converter_provider.dart';

class ImageGalleryView extends StatelessWidget {
  final ImageResponse response;

  const ImageGalleryView({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConverterProvider>(
      builder: (context, provider, child) {
        final images = response.images ?? [];
        final hasSelection = provider.selectedImageIndices.isNotEmpty;

        return Column(
          children: [
            // Action bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.3),
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      hasSelection
                          ? '${provider.selectedImageIndices.length} of ${images.length} selected'
                          : '${images.length} images',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (hasSelection) ...[
                    TextButton.icon(
                      onPressed: provider.deselectAllImages,
                      icon: const Icon(Icons.clear, size: 18),
                      label: const Text('Clear'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _downloadSelected(context, provider),
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('Download'),
                    ),
                  ] else ...[
                    TextButton.icon(
                      onPressed: provider.selectAllImages,
                      icon: const Icon(Icons.select_all, size: 18),
                      label: const Text('Select All'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _downloadAll(context, provider),
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('Download All'),
                    ),
                  ],
                ],
              ),
            ),

            // Image list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final imageUrl = images[index];
                  final isSelected =
                      provider.selectedImageIndices.contains(index);

                  return _ImageCard(
                    imageUrl: imageUrl,
                    pageNumber: index + 1,
                    isSelected: isSelected,
                    onTap: () => provider.toggleImageSelection(index),
                    onDownload: () =>
                        _downloadSingle(context, provider, imageUrl, index),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _downloadAll(
      BuildContext context, ConverterProvider provider) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Downloading all images...')),
    );

    for (int i = 0; i < response.images!.length; i++) {
      final imageUrl = response.images![i];
      final fileName = 'page_${i + 1}.jpg';
      await provider.downloadFile(imageUrl, fileName);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All images downloaded successfully!')),
      );
    }
  }

  Future<void> _downloadSelected(
      BuildContext context, ConverterProvider provider) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Downloading ${provider.selectedImageIndices.length} images...')),
    );

    for (int index in provider.selectedImageIndices) {
      final imageUrl = response.images![index];
      final fileName = 'page_${index + 1}.jpg';
      await provider.downloadFile(imageUrl, fileName);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Selected images downloaded successfully!')),
      );
      provider.deselectAllImages();
    }
  }

  Future<void> _downloadSingle(
    BuildContext context,
    ConverterProvider provider,
    String imageUrl,
    int index,
  ) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Downloading...')),
    );

    final fileName = 'page_${index + 1}.jpg';
    final filePath = await provider.downloadFile(imageUrl, fileName);

    if (filePath != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Downloaded: $fileName'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () => provider.openFile(filePath),
          ),
        ),
      );
    }
  }
}

class _ImageCard extends StatelessWidget {
  final String imageUrl;
  final int pageNumber;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  const _ImageCard({
    super.key,
    required this.imageUrl,
    required this.pageNumber,
    required this.isSelected,
    required this.onTap,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: isSelected ? 8 : 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Stack(
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return AspectRatio(
                      aspectRatio: 1,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 64),
                      ),
                    );
                  },
                ),
                if (isSelected)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
              ],
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Page $pageNumber',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onDownload,
                    icon: const Icon(Icons.download_rounded),
                    tooltip: 'Download',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
