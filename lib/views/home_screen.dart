import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/resume_controller.dart';
import '../models/resume_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'export_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentStep = 0;
  bool _showPreview = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text(
          _showPreview ? 'Live Preview' : 'Create Resume',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        actions: [
          Switch(
            value: _showPreview,
            onChanged: (val) => setState(() => _showPreview = val),
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.remove_red_eye, size: 20),
          ),
        ],
      ),
      body: _showPreview ? const ResumePreview() : _buildStepper(),
      floatingActionButton: _showPreview
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ExportScreen()),
              ),
              label: const Text('Export Now'),
              icon: const Icon(Icons.download),
              backgroundColor: const Color(0xFF4F46E5),
            )
          : FloatingActionButton(
              onPressed: () => setState(() => _showPreview = !_showPreview),
              tooltip: 'Toggle Preview',
              backgroundColor: const Color(0xFF4F46E5),
              child: const Icon(Icons.remove_red_eye),
            ),
    );
  }

  Widget _buildStepper() {
    return Stepper(
      type: StepperType.horizontal,
      currentStep: _currentStep,
      onStepTapped: (step) => setState(() => _currentStep = step),
      onStepContinue: () {
        if (_currentStep < 3) {
          setState(() => _currentStep++);
        } else {
          setState(() => _showPreview = true);
        }
      },
      onStepCancel: () {
        if (_currentStep > 0) {
          setState(() => _currentStep--);
        }
      },
      elevation: 0,
      steps: [
        Step(
          title: const Text('Basic'),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          content: const PersonalInfoForm(),
        ),
        Step(
          title: const Text('Work'),
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          content: const SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: ExperienceForm(),
          ),
        ),
        Step(
          title: const Text('Study'),
          isActive: _currentStep >= 2,
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          content: const SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: EducationForm(),
          ),
        ),
        Step(
          title: const Text('Skills'),
          isActive: _currentStep >= 3,
          state: _currentStep == 3 ? StepState.editing : StepState.indexed,
          content: const SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SkillsForm(),
          ),
        ),
      ],
    );
  }
}

class ResumePreview extends ConsumerWidget {
  const ResumePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(resumeProvider);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                data.personalInfo.name.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(data.personalInfo.email, style: const TextStyle(color: Colors.black54)),
                  Text(data.personalInfo.phoneNumber, style: const TextStyle(color: Colors.black54)),
                ],
              ),
              Text(data.personalInfo.address, style: const TextStyle(color: Colors.black54)),
              const Divider(height: 32, thickness: 1),

              // Summary
              if (data.personalInfo.summary.isNotEmpty) ...[
                _sectionHeader('PROFESSIONAL SUMMARY'),
                Text(data.personalInfo.summary, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 24),
              ],

              // Experience
              if (data.experience.isNotEmpty) ...[
                _sectionHeader('EXPERIENCE'),
                ...data.experience.map((exp) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(exp.role, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('${exp.startDate} - ${exp.endDate}', style: const TextStyle(color: Colors.black54, fontSize: 13)),
                            ],
                          ),
                          Text(exp.company, style: TextStyle(fontStyle: FontStyle.italic, color: theme.colorScheme.secondary)),
                          const SizedBox(height: 4),
                          Text(exp.description, style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    )),
                const SizedBox(height: 8),
              ],

              // Education
              if (data.education.isNotEmpty) ...[
                _sectionHeader('EDUCATION'),
                ...data.education.map((edu) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(edu.degree, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text('${edu.startDate} - ${edu.endDate}', style: const TextStyle(color: Colors.black54, fontSize: 13)),
                            ],
                          ),
                          Text(edu.institution, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    )),
                const SizedBox(height: 8),
              ],

              // Skills
              if (data.skills.isNotEmpty) ...[
                _sectionHeader('SKILLS'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: data.skills
                      .map((s) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(s, style: TextStyle(color: theme.colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.blueGrey)),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}

class PersonalInfoForm extends ConsumerWidget {
  const PersonalInfoForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalInfo = ref.watch(resumeProvider).personalInfo;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          _buildTextField(
            label: 'Full Name',
            icon: Icons.person_outline,
            initialValue: personalInfo.name,
            onChanged: (val) => ref.read(resumeProvider.notifier).updatePersonalInfo(personalInfo.copyWith(name: val)),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Email',
            icon: Icons.alternate_email,
            keyboardType: TextInputType.emailAddress,
            initialValue: personalInfo.email,
            onChanged: (val) => ref.read(resumeProvider.notifier).updatePersonalInfo(personalInfo.copyWith(email: val)),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Phone Number',
            icon: Icons.phone_android_outlined,
            keyboardType: TextInputType.phone,
            initialValue: personalInfo.phoneNumber,
            onChanged: (val) => ref.read(resumeProvider.notifier).updatePersonalInfo(personalInfo.copyWith(phoneNumber: val)),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Address',
            icon: Icons.map_outlined,
            initialValue: personalInfo.address,
            onChanged: (val) => ref.read(resumeProvider.notifier).updatePersonalInfo(personalInfo.copyWith(address: val)),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Professional Summary',
            icon: Icons.badge_outlined,
            maxLines: 4,
            initialValue: personalInfo.summary,
            onChanged: (val) => ref.read(resumeProvider.notifier).updatePersonalInfo(personalInfo.copyWith(summary: val)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? initialValue,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        alignLabelWithHint: true,
      ),
      onChanged: onChanged,
    );
  }
}

class ExperienceForm extends ConsumerWidget {
  const ExperienceForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experiences = ref.watch(resumeProvider).experience;

    return Column(
      children: [
        ...experiences.asMap().entries.map((entry) {
          final index = entry.key;
          final exp = entry.value;
          return Card(
            elevation: 0,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Work Experience #${index + 1}',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF4F46E5)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        onPressed: () => ref.read(resumeProvider.notifier).removeExperience(index),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildTextField(
                    label: 'Company / Organization',
                    initialValue: exp.company,
                    onChanged: (val) => ref.read(resumeProvider.notifier).updateExperience(index, exp.copyWith(company: val)),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Job Title / Role',
                    initialValue: exp.role,
                    onChanged: (val) => ref.read(resumeProvider.notifier).updateExperience(index, exp.copyWith(role: val)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Start Date',
                          initialValue: exp.startDate,
                          onChanged: (val) => ref.read(resumeProvider.notifier).updateExperience(index, exp.copyWith(startDate: val)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          label: 'End Date',
                          initialValue: exp.endDate,
                          onChanged: (val) => ref.read(resumeProvider.notifier).updateExperience(index, exp.copyWith(endDate: val)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'What did you do there?',
                    maxLines: 3,
                    initialValue: exp.description,
                    onChanged: (val) => ref.read(resumeProvider.notifier).updateExperience(index, exp.copyWith(description: val)),
                  ),
                ],
              ),
            ),
          );
        }),
        OutlinedButton.icon(
          onPressed: () => ref.read(resumeProvider.notifier).addExperience(Experience()),
          icon: const Icon(Icons.add_circle_outline, size: 18),
          label: const Text('Add Experience'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    int maxLines = 1,
    String? initialValue,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      onChanged: onChanged,
    );
  }
}

class EducationForm extends ConsumerWidget {
  const EducationForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final education = ref.watch(resumeProvider).education;

    return Column(
      children: [
        ...education.asMap().entries.map((entry) {
          final index = entry.key;
          final edu = entry.value;
          return Card(
            elevation: 0,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Education #${index + 1}',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF4F46E5)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        onPressed: () => ref.read(resumeProvider.notifier).removeEducation(index),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildTextField(
                    label: 'Institution / School',
                    initialValue: edu.institution,
                    onChanged: (val) => ref.read(resumeProvider.notifier).updateEducation(index, edu.copyWith(institution: val)),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Degree / Certificate',
                    initialValue: edu.degree,
                    onChanged: (val) => ref.read(resumeProvider.notifier).updateEducation(index, edu.copyWith(degree: val)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Start Date',
                          initialValue: edu.startDate,
                          onChanged: (val) => ref.read(resumeProvider.notifier).updateEducation(index, edu.copyWith(startDate: val)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          label: 'End Date',
                          initialValue: edu.endDate,
                          onChanged: (val) => ref.read(resumeProvider.notifier).updateEducation(index, edu.copyWith(endDate: val)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        OutlinedButton.icon(
          onPressed: () => ref.read(resumeProvider.notifier).addEducation(Education()),
          icon: const Icon(Icons.add_circle_outline, size: 18),
          label: const Text('Add Education'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    int maxLines = 1,
    String? initialValue,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      onChanged: onChanged,
    );
  }
}

class SkillsForm extends ConsumerStatefulWidget {
  const SkillsForm({super.key});

  @override
  ConsumerState<SkillsForm> createState() => _SkillsFormState();
}

class _SkillsFormState extends ConsumerState<SkillsForm> {
  final _skillController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final skills = ref.watch(resumeProvider).skills;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _skillController,
                decoration: InputDecoration(
                  labelText: 'Skill Name',
                  hintText: 'e.g., Flutter, Dart, Python',
                  prefixIcon: const Icon(Icons.offline_bolt_outlined, size: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_circle, color: Color(0xFF4F46E5)),
                    onPressed: () {
                      if (_skillController.text.trim().isNotEmpty) {
                        ref.read(resumeProvider.notifier).addSkill(_skillController.text.trim());
                        _skillController.clear();
                      }
                    },
                  ),
                ),
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    ref.read(resumeProvider.notifier).addSkill(val.trim());
                    _skillController.clear();
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Your Skills Tagged:',
          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF6B7280)),
        ),
        const SizedBox(height: 16),
        if (skills.isEmpty)
          const Center(
            child: Text(
              'No skills added yet. Start typing above!',
              style: TextStyle(color: Colors.black26, fontSize: 13),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills
                .map((skill) => Chip(
                      label: Text(skill),
                      onDeleted: () => ref.read(resumeProvider.notifier).removeSkill(skill),
                      deleteIcon: const Icon(Icons.close, size: 14),
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
                      side: BorderSide.none,
                      labelStyle: TextStyle(color: theme.colorScheme.primary, fontSize: 13, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ))
                .toList(),
          ),
      ],
    );
  }
}
