import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:resume_craft/controllers/resume_controller.dart';
import 'package:resume_craft/services/pdf_service.dart';
import 'package:resume_craft/services/file_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ExportScreen extends HookConsumerWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFileName = ref.read(resumeProvider).fileName;
    final nameController = useTextEditingController(text: currentFileName);

    Future<void> exportPdf() async {
      final data = ref.read(resumeProvider);
      final pdf = await PdfService.generateResume(data);
      final bytes = await pdf.save();

      final result = await FileService.saveFile(
        name: nameController.text.isNotEmpty
            ? nameController.text
            : 'my_resume',
        bytes: bytes,
        ext: 'pdf',
      );

      if (result != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Resume saved as PDF: $result')));
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(title: const Text('Export Resume')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.cloud_done_outlined,
              size: 80,
              color: Color(0xFF4F46E5),
            ),
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
              'Generate your professional resume as a high-quality PDF document.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'File Name',
                prefixIcon: Icon(Icons.drive_file_rename_outline),
                hintText: 'e.g., Jane_Doe_Resume_2024',
              ),
              onChanged: (val) =>
                  ref.read(resumeProvider.notifier).updateFileName(val),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: exportPdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Generate PDF Document'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: const Color(0xFF4F46E5),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You\'ll be prompted to choose where to save your file.',
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
