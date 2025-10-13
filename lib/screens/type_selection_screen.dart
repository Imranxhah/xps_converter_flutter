import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/converter_provider.dart';

class TypeSelectionScreen extends StatelessWidget {
  const TypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // Header
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.file_present_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Convert Your XPS File',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Choose a conversion option to get started',
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
              ],
            ),
          ),

          const SizedBox(height: 48),

          // Conversion Options
          _ConversionOptionCard(
            icon: Icons.image_outlined,
            title: 'Convert to Images',
            description: 'Get JPG images for each page of your XPS file',
            gradient: const LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            onTap: () {
              final provider = context.read<ConverterProvider>();
              provider.selectConversionType(ConversionType.images);
              provider.pickFileAndConvert();
            },
          ),

          const SizedBox(height: 16),

          _ConversionOptionCard(
            icon: Icons.picture_as_pdf_outlined,
            title: 'Convert to PDF',
            description: 'Create a single PDF document from your XPS file',
            gradient: const LinearGradient(
              colors: [Color(0xFFf093fb), Color(0xFFF5576c)],
            ),
            onTap: () {
              final provider = context.read<ConverterProvider>();
              provider.selectConversionType(ConversionType.pdf);
              provider.pickFileAndConvert();
            },
          ),

          const SizedBox(height: 16),

          _ConversionOptionCard(
            icon: Icons.description_outlined,
            title: 'Convert to DOCX',
            description: 'Generate a Word document with images from your XPS',
            gradient: const LinearGradient(
              colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
            ),
            onTap: () {
              final provider = context.read<ConverterProvider>();
              provider.selectConversionType(ConversionType.docx);
              provider.pickFileAndConvert();
            },
          ),

          const SizedBox(height: 16),

          _ConversionOptionCard(
            icon: Icons.text_fields_outlined,
            title: 'Read File (Extract Text)',
            description: 'View and extract text content from all pages',
            gradient: const LinearGradient(
              colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
            ),
            onTap: () {
              final provider = context.read<ConverterProvider>();
              provider.selectConversionType(ConversionType.text);
              provider.pickFileAndConvert();
            },
          ),

          const SizedBox(height: 40),

          // Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'File Requirements',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                      icon: Icons.check_circle_outline,
                      text: 'Maximum file size: 10 MB'),
                  const SizedBox(height: 8),
                  _InfoRow(
                      icon: Icons.check_circle_outline,
                      text: 'Maximum pages: 100'),
                  const SizedBox(height: 8),
                  _InfoRow(
                      icon: Icons.check_circle_outline,
                      text: 'Only .xps files supported'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversionOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ConversionOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                gradient.colors[0].withOpacity(0.1),
                gradient.colors[1].withOpacity(0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
