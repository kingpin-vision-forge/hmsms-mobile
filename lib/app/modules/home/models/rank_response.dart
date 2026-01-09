/// Model for individual student rank response
class StudentRankResponse {
  final bool success;
  final StudentRankData? data;
  final String? message;

  StudentRankResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory StudentRankResponse.fromJson(Map<String, dynamic> json) {
    return StudentRankResponse(
      success: json['success'] ?? false,
      data: json['data'] != null 
          ? StudentRankData.fromJson(json['data']) 
          : null,
      message: json['message'],
    );
  }
}

class StudentRankData {
  final String studentId;
  final String studentName;
  final String classId;
  final String className;
  final String? sectionId;
  final String? sectionName;
  final int rank;
  final int totalStudents;
  final double percentage;
  final String grade;
  final int? previousRank;
  final int rankChange;
  final String? examName;

  StudentRankData({
    required this.studentId,
    required this.studentName,
    required this.classId,
    required this.className,
    this.sectionId,
    this.sectionName,
    required this.rank,
    required this.totalStudents,
    required this.percentage,
    required this.grade,
    this.previousRank,
    required this.rankChange,
    this.examName,
  });

  factory StudentRankData.fromJson(Map<String, dynamic> json) {
    return StudentRankData(
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      classId: json['classId'] ?? '',
      className: json['className'] ?? '',
      sectionId: json['sectionId'],
      sectionName: json['sectionName'],
      rank: json['rank'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
      grade: json['grade'] ?? '',
      previousRank: json['previousRank'],
      rankChange: json['rankChange'] ?? 0,
      examName: json['examName'],
    );
  }

  /// Check if rank improved
  bool get hasImproved => rankChange > 0;

  /// Check if rank dropped
  bool get hasDropped => rankChange < 0;

  /// Get ordinal suffix (1st, 2nd, 3rd, etc.)
  String get rankOrdinal {
    if (rank >= 11 && rank <= 13) return '${rank}th';
    switch (rank % 10) {
      case 1:
        return '${rank}st';
      case 2:
        return '${rank}nd';
      case 3:
        return '${rank}rd';
      default:
        return '${rank}th';
    }
  }
}

/// Model for class rankings response
class ClassRankingsResponse {
  final bool success;
  final ClassRankingsData? data;
  final String? message;

  ClassRankingsResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ClassRankingsResponse.fromJson(Map<String, dynamic> json) {
    return ClassRankingsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null 
          ? ClassRankingsData.fromJson(json['data']) 
          : null,
      message: json['message'],
    );
  }
}

class ClassRankingsData {
  final String classId;
  final String className;
  final String? examName;
  final int totalStudents;
  final List<StudentRankEntry> rankings;

  ClassRankingsData({
    required this.classId,
    required this.className,
    this.examName,
    required this.totalStudents,
    required this.rankings,
  });

  factory ClassRankingsData.fromJson(Map<String, dynamic> json) {
    return ClassRankingsData(
      classId: json['classId'] ?? '',
      className: json['className'] ?? '',
      examName: json['examName'],
      totalStudents: json['totalStudents'] ?? 0,
      rankings: (json['rankings'] as List<dynamic>?)
              ?.map((e) => StudentRankEntry.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class StudentRankEntry {
  final int rank;
  final String studentId;
  final String studentName;
  final String? admissionNumber;
  final String? sectionName;
  final double percentage;
  final String grade;
  final int? previousRank;
  final int rankChange;

  StudentRankEntry({
    required this.rank,
    required this.studentId,
    required this.studentName,
    this.admissionNumber,
    this.sectionName,
    required this.percentage,
    required this.grade,
    this.previousRank,
    required this.rankChange,
  });

  factory StudentRankEntry.fromJson(Map<String, dynamic> json) {
    return StudentRankEntry(
      rank: json['rank'] ?? 0,
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      admissionNumber: json['admissionNumber'],
      sectionName: json['sectionName'],
      percentage: (json['percentage'] ?? 0).toDouble(),
      grade: json['grade'] ?? '',
      previousRank: json['previousRank'],
      rankChange: json['rankChange'] ?? 0,
    );
  }

  /// Get ordinal suffix (1st, 2nd, 3rd, etc.)
  String get rankOrdinal {
    if (rank >= 11 && rank <= 13) return '${rank}th';
    switch (rank % 10) {
      case 1:
        return '${rank}st';
      case 2:
        return '${rank}nd';
      case 3:
        return '${rank}rd';
      default:
        return '${rank}th';
    }
  }
}
