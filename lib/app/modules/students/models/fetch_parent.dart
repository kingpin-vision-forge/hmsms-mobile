class FetchParentResponse {
  final List<ParentDropdownData> data;

  FetchParentResponse({required this.data});

  factory FetchParentResponse.fromJson(Map<String, dynamic> json) {
    return FetchParentResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    ParentDropdownData.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data.map((item) => item.toJson()).toList()};
  }
}

class ParentDropdownData {
  final String id;
  final String name;

  ParentDropdownData({required this.id, required this.name});

  factory ParentDropdownData.fromJson(Map<String, dynamic> json) {
    return ParentDropdownData(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
