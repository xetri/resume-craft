import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:resume_craft/models/resume_data.dart';

class PdfService {
  static Future<pw.Document> generateResume(ResumeData data) async {
    // Load fonts to match app (Outfit for headings, Inter for body)
    final outfitBold = await PdfGoogleFonts.outfitBold();
    final interRegular = await PdfGoogleFonts.interRegular();
    final interMedium = await PdfGoogleFonts.interMedium();
    final interItalic = await PdfGoogleFonts.interItalic();

    final theme = pw.ThemeData.withFont(
      base: interRegular,
      bold: outfitBold,
      italic: interItalic,
    );

    final pdf = pw.Document(theme: theme);

    // Colors
    final primaryColor = PdfColor.fromHex('#4F46E5');
    final headerColor = PdfColor.fromHex('#1E1B4B');
    final sectionTitleColor = PdfColor.fromHex('#6366F1');
    final dividerColor = PdfColor.fromHex('#F3F4F6');
    final bodyTextColor = PdfColor.fromHex('#374151');
    final lightTextColor = PdfColor.fromHex('#6B7280');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          _buildHeader(
            data.personalInfo,
            outfitBold,
            interRegular,
            headerColor,
            primaryColor,
          ),
          pw.SizedBox(height: 24),
          _buildSummary(
            data.personalInfo.summary,
            outfitBold,
            interRegular,
            sectionTitleColor,
            dividerColor,
            bodyTextColor,
          ),
          pw.SizedBox(height: 24),
          _buildExperience(
            data.experience,
            outfitBold,
            interRegular,
            interMedium,
            sectionTitleColor,
            dividerColor,
            primaryColor,
            bodyTextColor,
            lightTextColor,
          ),
          pw.SizedBox(height: 24),
          _buildEducation(
            data.education,
            outfitBold,
            interMedium,
            sectionTitleColor,
            dividerColor,
            primaryColor,
            bodyTextColor,
          ),
          pw.SizedBox(height: 24),
          _buildSkills(
            data.skills,
            outfitBold,
            interMedium,
            sectionTitleColor,
            dividerColor,
            bodyTextColor,
          ),
        ],
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader(
    PersonalInfo info,
    pw.Font boldFont,
    pw.Font regularFont,
    PdfColor headerColor,
    PdfColor primaryColor,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          info.name.toUpperCase(),
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 28,
            color: headerColor,
            letterSpacing: 1.5,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            if (info.email.isNotEmpty)
              _iconText(info.email, regularFont, PdfColors.grey700),
            if (info.phoneNumber.isNotEmpty)
              _iconText(info.phoneNumber, regularFont, PdfColors.grey700),
            if (info.address.isNotEmpty)
              _iconText(info.address, regularFont, PdfColors.grey700),
          ],
        ),
      ],
    );
  }

  static pw.Widget _iconText(String text, pw.Font font, PdfColor color) {
    return pw.Text(
      text,
      style: pw.TextStyle(font: font, fontSize: 11, color: color),
    );
  }

  static pw.Widget _sectionHeader(
    String title,
    pw.Font font,
    PdfColor color,
    PdfColor dividerColor,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            font: font,
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: color,
            letterSpacing: 1.5,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Divider(thickness: 1, color: dividerColor),
        pw.SizedBox(height: 12),
      ],
    );
  }

  static pw.Widget _buildSummary(
    String summary,
    pw.Font boldFont,
    pw.Font regularFont,
    PdfColor sectionColor,
    PdfColor dividerColor,
    PdfColor textColor,
  ) {
    if (summary.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'PROFESSIONAL SUMMARY',
          boldFont,
          sectionColor,
          dividerColor,
        ),
        pw.Text(
          summary,
          style: pw.TextStyle(
            font: regularFont,
            fontSize: 12,
            color: textColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildExperience(
    List<Experience> experiences,
    pw.Font boldFont,
    pw.Font regularFont,
    pw.Font mediumFont,
    PdfColor sectionColor,
    PdfColor dividerColor,
    PdfColor primaryColor,
    PdfColor textColor,
    PdfColor lightTextColor,
  ) {
    final validExps = experiences
        .where((e) => e.company.isNotEmpty || e.role.isNotEmpty)
        .toList();
    if (validExps.isEmpty) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionHeader('EXPERIENCE', boldFont, sectionColor, dividerColor),
        ...validExps.map(
          (exp) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            exp.role,
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 15,
                              color: PdfColors.grey900,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            '${exp.company} • ${exp.employmentType}',
                            style: pw.TextStyle(
                              font: mediumFont,
                              fontSize: 12,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Text(
                      '${exp.startDate} – ${exp.endDate}',
                      style: pw.TextStyle(
                        font: mediumFont,
                        fontSize: 10,
                        color: lightTextColor,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  exp.description,
                  style: pw.TextStyle(
                    font: regularFont,
                    fontSize: 11,
                    color: textColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildEducation(
    List<Education> education,
    pw.Font boldFont,
    pw.Font mediumFont,
    PdfColor sectionColor,
    PdfColor dividerColor,
    PdfColor primaryColor,
    PdfColor textColor,
  ) {
    final validEdus = education.where((e) => e.institution.isNotEmpty).toList();
    if (validEdus.isEmpty) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionHeader('EDUCATION', boldFont, sectionColor, dividerColor),
        ...validEdus.map(
          (edu) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 12),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      '${edu.degreeLevel} in ${edu.degree}',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 14,
                        color: PdfColors.grey900,
                      ),
                    ),
                    pw.Text(
                      '${edu.startDate} – ${edu.endDate}',
                      style: pw.TextStyle(
                        font: mediumFont,
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  edu.institution,
                  style: pw.TextStyle(
                    font: mediumFont,
                    fontSize: 12,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSkills(
    List<String> skills,
    pw.Font boldFont,
    pw.Font mediumFont,
    PdfColor sectionColor,
    PdfColor dividerColor,
    PdfColor textColor,
  ) {
    if (skills.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionHeader('SKILLS', boldFont, sectionColor, dividerColor),
        pw.Wrap(
          spacing: 10,
          runSpacing: 8,
          children: skills
              .map(
                (s) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#F3F4F6'),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(6),
                    ),
                  ),
                  child: pw.Text(
                    s,
                    style: pw.TextStyle(
                      font: mediumFont,
                      fontSize: 10,
                      color: textColor,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
