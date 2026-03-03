import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/resume_data.dart';

class PdfService {
  static Future<pw.Document> generateResume(ResumeData data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(data.personalInfo),
          pw.SizedBox(height: 20),
          _buildSummary(data.personalInfo.summary),
          pw.SizedBox(height: 20),
          _buildExperience(data.experience),
          pw.SizedBox(height: 20),
          _buildEducation(data.education),
          pw.SizedBox(height: 20),
          _buildSkills(data.skills),
        ],
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader(PersonalInfo info) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(info.name.toUpperCase(), style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
        pw.SizedBox(height: 4),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(info.email, style: const pw.TextStyle(fontSize: 10)),
            pw.Text(info.phoneNumber, style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
        pw.Text(info.address, style: const pw.TextStyle(fontSize: 10)),
        pw.Divider(thickness: 1, color: PdfColors.grey300),
      ],
    );
  }

  static pw.Widget _buildSummary(String summary) {
    if (summary.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('PROFESSIONAL SUMMARY', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Text(summary, style: const pw.TextStyle(fontSize: 11)),
      ],
    );
  }

  static pw.Widget _buildExperience(List<Experience> experiences) {
    if (experiences.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('EXPERIENCE', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.Divider(thickness: 0.5),
        ...experiences.map((exp) => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(exp.role, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                  pw.Text('${exp.startDate} - ${exp.endDate}', style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
              pw.Text(exp.company, style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 11)),
              pw.SizedBox(height: 4),
              pw.Text(exp.description, style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
        )),
      ],
    );
  }

  static pw.Widget _buildEducation(List<Education> education) {
    if (education.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('EDUCATION', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.Divider(thickness: 0.5),
        ...education.map((edu) => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(edu.degree, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                  pw.Text('${edu.startDate} - ${edu.endDate}', style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
              pw.Text(edu.institution, style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 11)),
            ],
          ),
        )),
      ],
    );
  }

  static pw.Widget _buildSkills(List<String> skills) {
    if (skills.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('SKILLS', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.Divider(thickness: 0.5),
        pw.Wrap(
          spacing: 10,
          runSpacing: 5,
          children: skills.map((s) => pw.Bullet(text: s, style: const pw.TextStyle(fontSize: 11))).toList(),
        ),
      ],
    );
  }
}
