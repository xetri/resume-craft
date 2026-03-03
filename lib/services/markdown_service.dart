import '../models/resume_data.dart';

class MarkdownService {
  static String generateMarkdown(ResumeData data) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('# ${data.personalInfo.name}');
    buffer.writeln('\n${data.personalInfo.email} | ${data.personalInfo.phoneNumber}');
    buffer.writeln('\n${data.personalInfo.address}');
    buffer.writeln('\n---');

    // Summary
    if (data.personalInfo.summary.isNotEmpty) {
      buffer.writeln('\n## Professional Summary');
      buffer.writeln(data.personalInfo.summary);
    }

    // Experience
    if (data.experience.isNotEmpty) {
      buffer.writeln('\n## Experience');
      for (var exp in data.experience) {
        buffer.writeln('\n### ${exp.role} at ${exp.company}');
        buffer.writeln('*${exp.startDate} - ${exp.endDate}*');
        buffer.writeln('\n${exp.description}');
      }
    }

    // Education
    if (data.education.isNotEmpty) {
      buffer.writeln('\n## Education');
      for (var edu in data.education) {
        buffer.writeln('\n### ${edu.degree}');
        buffer.writeln('${edu.institution}');
        buffer.writeln('*${edu.startDate} - ${edu.endDate}*');
      }
    }

    // Skills
    if (data.skills.isNotEmpty) {
      buffer.writeln('\n## Skills');
      buffer.writeln(data.skills.map((s) => '* $s').join('\n'));
    }

    return buffer.toString();
  }
}
