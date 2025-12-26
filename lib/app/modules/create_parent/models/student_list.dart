class FetchStudentForParentResponse {
  final List<StudentDropdownData> data;

  FetchStudentForParentResponse({
    required this.data,
  });

  factory FetchStudentForParentResponse.fromJson(Map<String, dynamic> json) {
    return FetchStudentForParentResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    StudentDropdownData.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class StudentDropdownData {
  final String id;
  final String name;

  StudentDropdownData({required this.id, required this.name});

  factory StudentDropdownData.fromJson(Map<String, dynamic> json) {
    return StudentDropdownData(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
