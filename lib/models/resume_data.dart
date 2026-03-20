class ResumeData {
  final PersonalInfo personalInfo;
  final List<Experience> experience;
  final List<Education> education;
  final List<String> skills;
  final String fileName;

  ResumeData({
    required this.personalInfo,
    this.experience = const [],
    this.education = const [],
    this.skills = const [],
    this.fileName = 'my_resume',
  });

  ResumeData copyWith({
    PersonalInfo? personalInfo,
    List<Experience>? experience,
    List<Education>? education,
    List<String>? skills,
    String? fileName,
  }) {
    return ResumeData(
      personalInfo: personalInfo ?? this.personalInfo,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      fileName: fileName ?? this.fileName,
    );
  }
}

class PersonalInfo {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String summary;

  PersonalInfo({
    this.name = '',
    this.email = '',
    this.phoneNumber = '',
    this.address = '',
    this.summary = '',
  });

  PersonalInfo copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    String? summary,
  }) {
    return PersonalInfo(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      summary: summary ?? this.summary,
    );
  }
}

class Experience {
  final String company;
  final String role;
  final String employmentType;
  final String startDate;
  final String endDate;
  final String description;

  Experience({
    this.company = '',
    this.role = '',
    this.employmentType = 'Full-time',
    this.startDate = '',
    this.endDate = '',
    this.description = '',
  });

  Experience copyWith({
    String? company,
    String? role,
    String? employmentType,
    String? startDate,
    String? endDate,
    String? description,
  }) {
    return Experience(
      company: company ?? this.company,
      role: role ?? this.role,
      employmentType: employmentType ?? this.employmentType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
    );
  }
}

class Education {
  final String institution;
  final String degree;
  final String degreeLevel;
  final String fieldOfStudy;
  final String startDate;
  final String endDate;

  Education({
    this.institution = '',
    this.degree = '',
    this.degreeLevel = 'Bachelor\'s',
    this.fieldOfStudy = '',
    this.startDate = '',
    this.endDate = '',
  });

  Education copyWith({
    String? institution,
    String? degree,
    String? degreeLevel,
    String? fieldOfStudy,
    String? startDate,
    String? endDate,
  }) {
    return Education(
      institution: institution ?? this.institution,
      degree: degree ?? this.degree,
      degreeLevel: degreeLevel ?? this.degreeLevel,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
