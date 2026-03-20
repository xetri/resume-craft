import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:resume_craft/controllers/resume_controller.dart';
import 'package:resume_craft/models/resume_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'export_screen.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = useState(0);
    final showPreview = useState(false);
    final primaryColor = const Color(0xFF4F46E5);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            showPreview.value ? 'Resume Preview' : 'Resume Craft',
            key: ValueKey(showPreview.value),
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
              fontSize: 22,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _buildPreviewToggle(showPreview, primaryColor),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[...previousChildren, ?currentChild],
          );
        },
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: showPreview.value
            ? const ResumePreview(key: ValueKey('preview'))
            : _buildStepper(
                context,
                currentStep,
                showPreview,
                key: const ValueKey('stepper'),
              ),
      ),
      floatingActionButton: showPreview.value
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ExportScreen()),
              ),
              label: Text(
                'Export Now',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              backgroundColor: primaryColor,
              elevation: 4,
            )
          : FloatingActionButton(
              onPressed: () => showPreview.value = true,
              tooltip: 'Preview Your Resume',
              backgroundColor: primaryColor,
              elevation: 4,
              child: const Icon(
                Icons.remove_red_eye_rounded,
                color: Colors.white,
              ),
            ),
    );
  }

  Widget _buildPreviewToggle(
    ValueNotifier<bool> showPreview,
    Color primaryColor,
  ) {
    return InkWell(
      onTap: () => showPreview.value = !showPreview.value,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: showPreview.value
              ? primaryColor
              : primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: showPreview.value
                ? primaryColor
                : primaryColor.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              showPreview.value
                  ? Icons.edit_note_rounded
                  : Icons.visibility_outlined,
              size: 20,
              color: showPreview.value ? Colors.white : primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              showPreview.value ? 'Edit' : 'Preview',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: showPreview.value ? Colors.white : primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper(
    BuildContext context,
    ValueNotifier<int> currentStep,
    ValueNotifier<bool> showPreview, {
    Key? key,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return Theme(
          key: key,
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: const Color(0xFF4F46E5)),
          ),
          child: Stepper(
            type: isMobile ? StepperType.vertical : StepperType.horizontal,
            physics: const ClampingScrollPhysics(),
            currentStep: currentStep.value,
            onStepTapped: (step) => currentStep.value = step,
            onStepContinue: () {
              if (currentStep.value < 3) {
                currentStep.value++;
              } else {
                showPreview.value = true;
              }
            },
            onStepCancel: () {
              if (currentStep.value > 0) {
                currentStep.value--;
              }
            },
            elevation: 0,
            margin: EdgeInsets.zero,
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          currentStep.value == 3 ? 'Finish' : 'Continue',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (currentStep.value > 0) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: details.onStepCancel,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF6B7280),
                            side: const BorderSide(color: Color(0xFFE5E7EB)),
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Back',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: Text('Basic', style: GoogleFonts.outfit(fontSize: 12)),
                isActive: currentStep.value >= 0,
                state: currentStep.value > 0
                    ? StepState.complete
                    : StepState.indexed,
                content: const PersonalInfoForm(),
              ),
              Step(
                title: Text('Work', style: GoogleFonts.outfit(fontSize: 12)),
                isActive: currentStep.value >= 1,
                state: currentStep.value > 1
                    ? StepState.complete
                    : StepState.indexed,
                content: const ExperienceForm(),
              ),
              Step(
                title: Text('Study', style: GoogleFonts.outfit(fontSize: 12)),
                isActive: currentStep.value >= 2,
                state: currentStep.value > 2
                    ? StepState.complete
                    : StepState.indexed,
                content: const EducationForm(),
              ),
              Step(
                title: Text('Skills', style: GoogleFonts.outfit(fontSize: 12)),
                isActive: currentStep.value >= 3,
                state: currentStep.value == 3
                    ? StepState.editing
                    : StepState.indexed,
                content: const SkillsForm(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ResumePreview extends ConsumerWidget {
  const ResumePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(resumeProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                data.personalInfo.name.isNotEmpty
                    ? data.personalInfo.name.toUpperCase()
                    : 'YOUR NAME',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1B4B),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  if (data.personalInfo.email.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          size: 14,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data.personalInfo.email,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  if (data.personalInfo.phoneNumber.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.phone_android_rounded,
                          size: 14,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data.personalInfo.phoneNumber,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              if (data.personalInfo.address.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      data.personalInfo.address,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              const Divider(thickness: 1, color: Color(0xFFF3F4F6)),

              // Summary
              if (data.personalInfo.summary.isNotEmpty) ...[
                _sectionHeader('PROFESSIONAL SUMMARY', Icons.person_rounded),
                Text(
                  data.personalInfo.summary,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.6,
                    color: const Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Experience
              if (data.experience.any(
                (e) => e.company.isNotEmpty || e.role.isNotEmpty,
              )) ...[
                _sectionHeader('EXPERIENCE', Icons.work_rounded),
                ...data.experience
                    .where((e) => e.company.isNotEmpty || e.role.isNotEmpty)
                    .map(
                      (exp) => Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.6,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exp.role,
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: const Color(0xFF111827),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${exp.company} • ${exp.employmentType}',
                                        style: GoogleFonts.inter(
                                          fontStyle: FontStyle.italic,
                                          color: const Color(0xFF4F46E5),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${exp.startDate} – ${exp.endDate}',
                                  style: GoogleFonts.inter(
                                    color: Colors.black45,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              exp.description,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                height: 1.5,
                                color: const Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                const SizedBox(height: 8),
              ],

              // Education
              if (data.education.any((e) => e.institution.isNotEmpty)) ...[
                _sectionHeader('EDUCATION', Icons.school_rounded),
                ...data.education
                    .where((e) => e.institution.isNotEmpty)
                    .map(
                      (edu) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.6,
                                  ),
                                  child: Text(
                                    '${edu.degreeLevel} in ${edu.degree}',
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: const Color(0xFF111827),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${edu.startDate} – ${edu.endDate}',
                                  style: GoogleFonts.inter(
                                    color: Colors.black45,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              edu.institution,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFF4F46E5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                const SizedBox(height: 16),
              ],

              // Skills
              if (data.skills.isNotEmpty) ...[
                _sectionHeader('SKILLS', Icons.terminal_rounded),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: data.skills
                      .map(
                        (s) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Text(
                            s,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF374151),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF4F46E5)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: const Color(0xFF6366F1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 1, color: Color(0xFFF3F4F6)),
        ],
      ),
    );
  }
}

class PersonalInfoForm extends HookConsumerWidget {
  const PersonalInfoForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalInfo = ref.watch(resumeProvider).personalInfo;

    final nameController = useTextEditingController(text: personalInfo.name);
    final emailController = useTextEditingController(text: personalInfo.email);
    final phoneController = useTextEditingController(
      text: personalInfo.phoneNumber,
    );
    final addressController = useTextEditingController(
      text: personalInfo.address,
    );
    final summaryController = useTextEditingController(
      text: personalInfo.summary,
    );

    // Update with debounce or just simple listener
    // For simplicity, we can do it on onChanged which is what they had.
    // If we use controllers, we don't need initialValue anymore.

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          _buildTextField(
            label: 'Full Name',
            icon: Icons.person_outline_rounded,
            controller: nameController,
            onChanged: (val) => ref
                .read(resumeProvider.notifier)
                .updatePersonalInfo(personalInfo.copyWith(name: val)),
          ),
          const SizedBox(height: 18),
          _buildTextField(
            label: 'Email',
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            onChanged: (val) => ref
                .read(resumeProvider.notifier)
                .updatePersonalInfo(personalInfo.copyWith(email: val)),
          ),
          const SizedBox(height: 18),
          _buildTextField(
            label: 'Phone Number',
            icon: Icons.phone_android_rounded,
            keyboardType: TextInputType.phone,
            controller: phoneController,
            onChanged: (val) => ref
                .read(resumeProvider.notifier)
                .updatePersonalInfo(personalInfo.copyWith(phoneNumber: val)),
          ),
          const SizedBox(height: 18),
          _buildTextField(
            label: 'Address',
            icon: Icons.location_on_outlined,
            controller: addressController,
            onChanged: (val) => ref
                .read(resumeProvider.notifier)
                .updatePersonalInfo(personalInfo.copyWith(address: val)),
          ),
          const SizedBox(height: 18),
          _buildTextField(
            label: 'Professional Summary',
            icon: Icons.description_outlined,
            maxLines: 4,
            controller: summaryController,
            onChanged: (val) => ref
                .read(resumeProvider.notifier)
                .updatePersonalInfo(personalInfo.copyWith(summary: val)),
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
    TextEditingController? controller,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF6B7280)),
        alignLabelWithHint: true,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
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
          return ExperienceItem(index: entry.key, experience: entry.value);
        }),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () =>
              ref.read(resumeProvider.notifier).addExperience(Experience()),
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text('Add Another Experience'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF4F46E5),
            minimumSize: const Size(double.infinity, 54),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class ExperienceItem extends HookConsumerWidget {
  final int index;
  final Experience experience;

  const ExperienceItem({
    super.key,
    required this.index,
    required this.experience,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyController = useTextEditingController(
      text: experience.company,
    );
    final roleController = useTextEditingController(text: experience.role);
    final startDateController = useTextEditingController(
      text: experience.startDate,
    );
    final endDateController = useTextEditingController(
      text: experience.endDate,
    );
    final descController = useTextEditingController(
      text: experience.description,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'EXPERIENCE #${index + 1}',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4F46E5),
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.grey,
                    size: 22,
                  ),
                  onPressed: () =>
                      ref.read(resumeProvider.notifier).removeExperience(index),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildTextField(
              label: 'Company / Organization',
              controller: companyController,
              onChanged: (val) => ref
                  .read(resumeProvider.notifier)
                  .updateExperience(index, experience.copyWith(company: val)),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 16,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 200,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: _buildTextField(
                    label: 'Job Title / Role',
                    controller: roleController,
                    onChanged: (val) => ref
                        .read(resumeProvider.notifier)
                        .updateExperience(
                          index,
                          experience.copyWith(role: val),
                        ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 120),
                  child: _buildDropdown(
                    label: 'Type',
                    value: experience.employmentType,
                    items: [
                      'Full-time',
                      'Part-time',
                      'Contract',
                      'Freelance',
                      'Internship',
                    ],
                    onChanged: (val) => ref
                        .read(resumeProvider.notifier)
                        .updateExperience(
                          index,
                          experience.copyWith(
                            employmentType: val ?? 'Full-time',
                          ),
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 16,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 140),
                  child: _buildTextField(
                    label: 'Start Date',
                    controller: startDateController,
                    placeholder: 'November, 2025',
                    onChanged: (val) => ref
                        .read(resumeProvider.notifier)
                        .updateExperience(
                          index,
                          experience.copyWith(startDate: val),
                        ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 140),
                  child: _buildTextField(
                    label: 'End Date',
                    controller: endDateController,
                    placeholder: 'Present',
                    onChanged: (val) => ref
                        .read(resumeProvider.notifier)
                        .updateExperience(
                          index,
                          experience.copyWith(endDate: val),
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Description & Achievements',
              maxLines: 4,
              controller: descController,
              onChanged: (val) => ref
                  .read(resumeProvider.notifier)
                  .updateExperience(
                    index,
                    experience.copyWith(description: val),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    int maxLines = 1,
    TextEditingController? controller,
    String? placeholder,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        hintStyle: const TextStyle(color: Colors.black26),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items
          .map(
            (i) => DropdownMenuItem(
              value: i,
              child: Text(i, style: GoogleFonts.inter(fontSize: 13)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
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
          return EducationItem(index: entry.key, education: entry.value);
        }),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () =>
              ref.read(resumeProvider.notifier).addEducation(Education()),
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text('Add Another Education'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF4F46E5),
            minimumSize: const Size(double.infinity, 54),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class EducationItem extends HookConsumerWidget {
  final int index;
  final Education education;

  const EducationItem({
    super.key,
    required this.index,
    required this.education,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final institutionController = useTextEditingController(
      text: education.institution,
    );
    final degreeController = useTextEditingController(text: education.degree);
    final startDateController = useTextEditingController(
      text: education.startDate,
    );
    final endDateController = useTextEditingController(text: education.endDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'EDUCATION #${index + 1}',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4F46E5),
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.grey,
                    size: 22,
                  ),
                  onPressed: () =>
                      ref.read(resumeProvider.notifier).removeEducation(index),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildTextField(
              label: 'Institution / School Name',
              controller: institutionController,
              onChanged: (val) => ref
                  .read(resumeProvider.notifier)
                  .updateEducation(index, education.copyWith(institution: val)),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 16,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 200,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: _buildTextField(
                    label: 'Major / Field of Study',
                    controller: degreeController,
                    onChanged: (val) => ref
                        .read(resumeProvider.notifier)
                        .updateEducation(
                          index,
                          education.copyWith(degree: val),
                        ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 120),
                  child: _buildDropdown(
                    label: 'Level',
                    value: education.degreeLevel,
                    items: [
                      'High School',
                      'Associate\'s',
                      'Bachelor\'s',
                      'Master\'s',
                      'PhD',
                      'Certificate',
                    ],
                    onChanged: (val) => ref
                        .read(resumeProvider.notifier)
                        .updateEducation(
                          index,
                          education.copyWith(degreeLevel: val ?? 'Bachelor\'s'),
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 16,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 140),
                  child: _buildTextField(
                    label: 'Start Date',
                    controller: startDateController,
                    placeholder: 'November, 2025',
                    onChanged: (val) => ref
                        .read(resumeProvider.notifier)
                        .updateEducation(
                          index,
                          education.copyWith(startDate: val),
                        ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 140),
                  child: _buildTextField(
                    label: 'End Date',
                    controller: endDateController,
                    placeholder: 'Present',
                    onChanged: (val) => ref
                        .read(resumeProvider.notifier)
                        .updateEducation(
                          index,
                          education.copyWith(endDate: val),
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    int maxLines = 1,
    TextEditingController? controller,
    String? placeholder,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        hintStyle: const TextStyle(color: Colors.black26),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items
          .map(
            (i) => DropdownMenuItem(
              value: i,
              child: Text(i, style: GoogleFonts.inter(fontSize: 13)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
    );
  }
}

class SkillsForm extends HookConsumerWidget {
  const SkillsForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillController = useTextEditingController();
    final skills = ref.watch(resumeProvider).skills;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: skillController,
                decoration: InputDecoration(
                  labelText: 'Skill Name',
                  hintText: 'e.g., Flutter, Dart, Python',
                  prefixIcon: const Icon(
                    Icons.offline_bolt_outlined,
                    size: 20,
                    color: Color(0xFF4F46E5),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: Color(0xFF4F46E5),
                      size: 28,
                    ),
                    onPressed: () {
                      if (skillController.text.trim().isNotEmpty) {
                        final multiSkills = skillController.text.split(',');
                        for (var s in multiSkills) {
                          final trimmed = s.trim();
                          if (trimmed.isNotEmpty) {
                            ref.read(resumeProvider.notifier).addSkill(trimmed);
                          }
                        }
                        skillController.clear();
                      }
                    },
                  ),
                ),
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    final multiSkills = val.split(',');
                    for (var s in multiSkills) {
                      final trimmed = s.trim();
                      if (trimmed.isNotEmpty) {
                        ref.read(resumeProvider.notifier).addSkill(trimmed);
                      }
                    }
                    skillController.clear();
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          'Your Skills Tags:',
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 16),
        if (skills.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.terminal_rounded,
                  size: 40,
                  color: Colors.grey.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 12),
                const Text(
                  'No skills added yet.\nStart typing above to build your list!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: skills
                .map(
                  (skill) => Chip(
                    label: Text(skill),
                    onDeleted: () =>
                        ref.read(resumeProvider.notifier).removeSkill(skill),
                    deleteIcon: const Icon(Icons.close, size: 14),
                    backgroundColor: const Color(
                      0xFF4F46E5,
                    ).withValues(alpha: 0.08),
                    side: BorderSide.none,
                    labelStyle: GoogleFonts.inter(
                      color: const Color(0xFF4F46E5),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
