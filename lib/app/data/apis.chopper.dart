// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'apis.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ApiService extends ApiService {
  _$ApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ApiService;

  @override
  Future<Response<dynamic>> login(Map<String, dynamic> credentials) {
    final Uri $url = Uri.parse('api/auth/login');
    final $body = credentials;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> refreshToken(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('api/auth/refresh');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> signOut(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('api/auth/logout');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createClass(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('api/classes');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> fetchClasses() {
    final Uri $url = Uri.parse('api/classes');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createSection(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('api/sections');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> fetchClassesForSection() {
    final Uri $url = Uri.parse('api/classes/by-school');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> fetchSections() {
    final Uri $url = Uri.parse('api/sections');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> classDetails(String classId) {
    final Uri $url = Uri.parse('api/classes/${classId}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sectionDetails(String sectionId) {
    final Uri $url = Uri.parse('api/sections/${sectionId}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateSection(
    String sectionId,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('api/sections/${sectionId}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateClass(
    String classId,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('api/classes/${classId}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createStudent(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('api/students');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> fetchSectionForClass({String? classId}) {
    final Uri $url = Uri.parse('api/sections/by-class');
    final Map<String, dynamic> $params = <String, dynamic>{'classId': classId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createParent(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('api/parents');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> fetchParentForStudent({String? schoolId}) {
    final Uri $url = Uri.parse('api/parents/by-school');
    final Map<String, dynamic> $params = <String, dynamic>{
      'schoolId': schoolId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> fetchStudentList() {
    final Uri $url = Uri.parse('api/students');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> studentDetails(String studentId) {
    final Uri $url = Uri.parse('api/students/${studentId}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateStudent(
    String studentId,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('api/students/${studentId}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> fetchStudentForParent({String? schoolId}) {
    final Uri $url = Uri.parse('api/students/by-school');
    final Map<String, dynamic> $params = <String, dynamic>{
      'schoolId': schoolId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> fetchParents() {
    final Uri $url = Uri.parse('api/parents');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> parentDetail(String parentId) {
    final Uri $url = Uri.parse('api/parents/${parentId}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateParent(
    String parentId,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('api/parents/${parentId}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createSubject(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('api/subjects');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> fetchSubjects() {
    final Uri $url = Uri.parse('api/subjects');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> subjectDetails(String subjectId) {
    final Uri $url = Uri.parse('api/subjects/${subjectId}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateSubject(
    String subjectId,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('api/subjects/${subjectId}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
