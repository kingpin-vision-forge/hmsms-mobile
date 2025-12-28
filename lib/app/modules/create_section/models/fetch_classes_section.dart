class FetchClassesSectionResponse {
  final List<ClassDropdownData> data;

  FetchClassesSectionResponse({
    required this.data,
  });

  factory FetchClassesSectionResponse.fromJson(Map<String, dynamic> json) {
    return FetchClassesSectionResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    ClassDropdownData.fromJson(item as Map<String, dynamic>),
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

class ClassDropdownData {
  final String id;
  final String name;

  ClassDropdownData({required this.id, required this.name});

  factory ClassDropdownData.fromJson(Map<String, dynamic> json) {
    return ClassDropdownData(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
