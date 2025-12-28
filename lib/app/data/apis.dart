import 'dart:io';
import 'package:student_management/app/data/api_athenticator.dart';
import 'package:student_management/app/data/header.interceptor.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:http/io_client.dart';
import 'package:chopper/chopper.dart';
// import 'package:ultra/app/data/refresh.interceptor.dart';
part 'apis.chopper.dart';

String apiBaseUrl = 'https://sms-api-dev.up.railway.app/';

@ChopperApi(baseUrl: 'api')
abstract class ApiService extends ChopperService {
  @POST(path: '/auth/login')
  Future<Response> login(@Body() Map<String, dynamic> credentials);

  @POST(path: '/auth/refresh')
  Future<Response> refreshToken(@Body() Map<String, dynamic> body);

  @POST(path: '/auth/logout')
  Future<Response> signOut(@Body() Map<String, dynamic> body);

  @POST(path: '/classes')
  Future<Response> createClass(@Body() Map<String, dynamic> body);

  @GET(path: '/classes')
  Future<Response> fetchClasses();

  @POST(path: '/sections')
  Future<Response> createSection(@Body() Map<String, dynamic> body);

  @GET(path: '/classes/by-school')
  Future<Response> fetchClassesForSection();

  @GET(path: '/sections')
  Future<Response> fetchSections();

  @GET(path: '/classes/{id}')
  Future<Response> classDetails(@Path('id') String classId);

  @GET(path: '/sections/{id}')
  Future<Response> sectionDetails(@Path('id') String sectionId);

  @PATCH(path: '/sections/{id}')
  Future<Response> updateSection(
    @Path('id') String sectionId,
    @Body() Map<String, dynamic> body,
  );

  @PATCH(path: '/classes/{id}')
  Future<Response> updateClass(
    @Path('id') String classId,
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/students')
  Future<Response> createStudent(@Body() Map<String, dynamic> body);

  @GET(path: '/sections/by-class')
  Future<Response> fetchSectionForClass({@Query('classId') String? classId});

  @POST(path: '/parents')
  Future<Response> createParent(@Body() Map<String, dynamic> body);

  @GET(path: '/parents/by-school')
  Future<Response> fetchParentForStudent({@Query('schoolId') String? schoolId});

  @GET(path: '/students')
  Future<Response> fetchStudentList();

  @GET(path: '/students/{id}')
  Future<Response> studentDetails(@Path('id') String studentId);

  @PATCH(path: '/students/{id}')
  Future<Response> updateStudent(
    @Path('id') String studentId,
    @Body() Map<String, dynamic> body,
  );

  @GET(path: '/students/by-school')
  Future<Response> fetchStudentForParent({@Query('schoolId') String? schoolId});

  @GET(path: '/parents')
  Future<Response> fetchParents();

  @GET(path: '/parents/{id}')
  Future<Response> parentDetail(@Path('id') String parentId);

  @PATCH(path: '/parents/{id}')
  Future<Response> updateParent(
    @Path('id') String parentId,
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/subjects')
  Future<Response> createSubject(@Body() Map<String, dynamic> body);

  @GET(path: '/subjects')
  Future<Response> fetchSubjects();

  @GET(path: '/subjects/{id}')
  Future<Response> subjectDetails(@Path('id') String subjectId);

  @PATCH(path: '/subjects/{id}')
  Future<Response> updateSubject(
    @Path('id') String subjectId,
    @Body() Map<String, dynamic> body,
  );

  // Teacher endpoints
  @GET(path: '/teachers')
  Future<Response> fetchTeachers();

  @GET(path: '/teachers/{id}')
  Future<Response> teacherDetails(@Path('id') String teacherId);

  @POST(path: '/teachers')
  Future<Response> createTeacher(@Body() Map<String, dynamic> body);

  @PATCH(path: '/teachers/{id}')
  Future<Response> updateTeacher(
    @Path('id') String teacherId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: '/teachers/{id}')
  Future<Response> deleteTeacher(@Path('id') String teacherId);

  static ApiService create() {
    final authenticator = ApiAuthenticator(baseUrl: apiBaseUrl);
    final client = ChopperClient(
      baseUrl: Uri.parse(apiBaseUrl),
      services: [_$ApiService()],
      converter: const JsonConverter(),
      authenticator: authenticator,
      interceptors: [HeaderInterceptor(authenticator)],
      client: IOClient(
        HttpClient()
          ..connectionTimeout = Constants.CONFIG['CONNECTION_TIMEOUT'],
      ),
    );
    return _$ApiService(client);
  }
}
