import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resume_data.dart';

final resumeProvider = StateNotifierProvider<ResumeNotifier, ResumeData>((ref) {
  return ResumeNotifier();
});

class ResumeNotifier extends StateNotifier<ResumeData> {
  ResumeNotifier()
      : super(ResumeData(
          personalInfo: PersonalInfo(),
          experience: [],
          education: [],
          skills: [],
        ));

  void updatePersonalInfo(PersonalInfo info) {
    state = state.copyWith(personalInfo: info);
  }

  void addExperience(Experience exp) {
    state = state.copyWith(experience: [...state.experience, exp]);
  }

  void removeExperience(int index) {
    final newList = [...state.experience];
    newList.removeAt(index);
    state = state.copyWith(experience: newList);
  }

  void updateExperience(int index, Experience exp) {
    final newList = [...state.experience];
    newList[index] = exp;
    state = state.copyWith(experience: newList);
  }

  void addEducation(Education edu) {
    state = state.copyWith(education: [...state.education, edu]);
  }

  void removeEducation(int index) {
    final newList = [...state.education];
    newList.removeAt(index);
    state = state.copyWith(education: newList);
  }

  void updateEducation(int index, Education edu) {
    final newList = [...state.education];
    newList[index] = edu;
    state = state.copyWith(education: newList);
  }

  void addSkill(String skill) {
    if (!state.skills.contains(skill)) {
      state = state.copyWith(skills: [...state.skills, skill]);
    }
  }

  void removeSkill(String skill) {
    state = state.copyWith(
        skills: state.skills.where((s) => s != skill).toList());
  }

  void updateFileName(String fileName) {
    state = state.copyWith(fileName: fileName);
  }
}
