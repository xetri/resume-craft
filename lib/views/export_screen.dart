import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/resume_controller.dart';
import '../services/pdf_service.dart';
import '../services/markdown_service.dart';
import '../services/file_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final currentName = ref.read(resumeProvider).fileName;
    _nameController = TextEditingController(text: currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _exportPdf() async {
    final data = ref.read(resumeProvider);
    final pdf = await PdfService.generateResume(data);
    final bytes = await pdf.save();

    final result = await FileService.saveFile(
      name: _nameController.text.isNotEmpty ? _nameController.text : 'my_resume',
      bytes: bytes,
      ext: 'pdf',
      mimeType: MimeType.pdf,
    );

    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resume saved as PDF: ${_nameController.text}.pdf')),
      );
    }
  }

  Future<void> _exportMarkdown() async {
    final data = ref.read(resumeProvider);
    final markdown = MarkdownService.generateMarkdown(data);
    final bytes = markdown.codeUnits;

    final result = await FileService.saveFile(
      name: _nameController.text.isNotEmpty ? _nameController.text : 'my_resume',
      bytes: bytes,
      ext: 'md',
      mimeType: MimeType.other,
    );

    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resume saved as Markdown: ${_nameController.text}.md')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(title: const Text('Export Resume')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.cloud_done_outlined, size: 80, color: Color(0xFF4F46E5)),
            const SizedBox(height: 32),
            Text(
              'Finalize & Export',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Choose your preferred format and save your professional resume.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'File Name',
                prefixIcon: Icon(Icons.drive_file_rename_outline),
                hintText: 'e.g., Jane_Doe_Resume_2024',
              ),
              onChanged: (val) => ref.read(resumeProvider.notifier).updateFileName(val),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: _exportPdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Generate PDF Document'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: const Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _exportMarkdown,
              icon: const Icon(Icons.code),
              label: const Text('Download Markdown (.md)'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                side: const BorderSide(color: Color(0xFF4F46E5)),
                foregroundColor: const Color(0xFF4F46E5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.1)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your file will be exported to your Documents or Downloads folder.',
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
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
