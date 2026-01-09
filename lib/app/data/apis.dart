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

  @GET(path: '/students/by-parent/{parentId}')
  Future<Response> fetchStudentsByParent(@Path('parentId') String parentId);

  // Student Rank endpoints
  @GET(path: '/students/rank/{studentId}')
  Future<Response> fetchStudentRank(
    @Path('studentId') String studentId, {
    @Query('examId') String? examId,
    @Query('term') String? term,
  });

  @GET(path: '/students/rank/class/{classId}')
  Future<Response> fetchClassRankings(
    @Path('classId') String classId, {
    @Query('sectionId') String? sectionId,
    @Query('examId') String? examId,
    @Query('term') String? term,
    @Query('limit') int? limit,
  });

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

  // Profile endpoints
  @GET(path: '/profile')
  Future<Response> fetchProfile();

  @PATCH(path: '/profile')
  Future<Response> updateProfile(@Body() Map<String, dynamic> body);

  // Notification endpoints
  @GET(path: '/notifications')
  Future<Response> fetchNotifications({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('unreadOnly') bool? unreadOnly,
  });

  @GET(path: '/notifications/unread-count')
  Future<Response> getUnreadCount();

  @PATCH(path: '/notifications/{id}/read')
  Future<Response> markNotificationAsRead(@Path('id') String notificationId);

  @POST(path: '/notifications/mark-all-read')
  Future<Response> markAllNotificationsAsRead();

  @GET(path: '/notifications/fee')
  Future<Response> fetchFeeNotifications();

  // Announcement endpoints
  @POST(path: '/notifications/announcement')
  Future<Response> createAnnouncement(@Body() Map<String, dynamic> body);

  @GET(path: '/notifications/announcements')
  Future<Response> fetchAnnouncements({
    @Query('schoolId') String? schoolId,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  // Device registration endpoints
  @POST(path: '/devices/register')
  Future<Response> registerDevice(@Body() Map<String, dynamic> body);

  @DELETE(path: '/devices/{token}')
  Future<Response> unregisterDevice(@Path('token') String token);

  // Timetable endpoints
  @POST(path: '/timetable')
  Future<Response> createTimetableSlot(@Body() Map<String, dynamic> body);

  @GET(path: '/timetable')
  Future<Response> fetchTimetable();

  @GET(path: '/timetable/by-class/{classId}')
  Future<Response> fetchTimetableByClass(
    @Path('classId') String classId, {
    @Query('sectionId') String? sectionId,
  });

  @GET(path: '/timetable/by-teacher/{teacherId}')
  Future<Response> fetchTimetableByTeacher(@Path('teacherId') String teacherId);

  @GET(path: '/timetable/{id}')
  Future<Response> getTimetableSlot(@Path('id') String slotId);

  @PATCH(path: '/timetable/{id}')
  Future<Response> updateTimetableSlot(
    @Path('id') String slotId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: '/timetable/{id}')
  Future<Response> deleteTimetableSlot(@Path('id') String slotId);

  // Attendance endpoints
  @POST(path: '/attendance/mark')
  Future<Response> markAttendance(@Body() Map<String, dynamic> body);

  @GET(path: '/attendance/student/{studentId}')
  Future<Response> fetchStudentAttendance(
    @Path('studentId') String studentId, {
    @Query('from') String? from,
    @Query('to') String? to,
  });

  @GET(path: '/attendance/class/{classId}')
  Future<Response> fetchClassAttendance(
    @Path('classId') String classId, {
    @Query('sectionId') String? sectionId,
    @Query('date') String? date,
  });

  // Fees endpoints
  @GET(path: '/fees')
  Future<Response> fetchFees();

  @GET(path: '/fees/by-student/{studentId}')
  Future<Response> fetchFeesByStudent(@Path('studentId') String studentId);

  @GET(path: '/fees/by-parent/{parentId}')
  Future<Response> fetchFeesByParent(@Path('parentId') String parentId);

  // Role-specific Dashboard endpoints
  @GET(path: '/dashboard/teacher')
  Future<Response> fetchTeacherDashboard();

  @GET(path: '/dashboard/student')
  Future<Response> fetchStudentDashboard();

  @GET(path: '/dashboard/parent')
  Future<Response> fetchParentDashboard();

  // Student Timetable endpoint
  @GET(path: '/timetable/by-student/{studentId}')
  Future<Response> fetchTimetableByStudent(
    @Path('studentId') String studentId, {
    @Query('dayOfWeek') String? dayOfWeek,
  });

  // Attendance Summary endpoint
  @GET(path: '/attendance/summary/{studentId}')
  Future<Response> fetchAttendanceSummary(
    @Path('studentId') String studentId, {
    @Query('period') String? period,
  });

  // Fees Summary endpoint
  @GET(path: '/fees/summary')
  Future<Response> fetchFeesSummary();

  // Admin Dashboard endpoints
  @GET(path: '/dashboard/admin/stats')
  Future<Response> fetchAdminStats({@Query('schoolId') String? schoolId});

  @GET(path: '/dashboard/admin/student-distribution')
  Future<Response> fetchStudentDistribution({@Query('schoolId') String? schoolId});

  @GET(path: '/dashboard/admin/fees-collection')
  Future<Response> fetchFeesCollection({
    @Query('schoolId') String? schoolId,
    @Query('year') int? year,
    @Query('months') int? months,
  });

  @GET(path: '/dashboard/admin/class-performance')
  Future<Response> fetchClassPerformance({
    @Query('schoolId') String? schoolId,
    @Query('year') int? year,
  });

  // Attendance report endpoints
  @GET(path: '/attendance/report')
  Future<Response> fetchAttendanceReport({
    @Query('classId') String? classId,
    @Query('sectionId') String? sectionId,
    @Query('studentId') String? studentId,
    @Query('from') required String from,
    @Query('to') required String to,
  });

  @GET(path: '/attendance/report/download')
  Future<Response> downloadAttendanceReport({
    @Query('classId') String? classId,
    @Query('sectionId') String? sectionId,
    @Query('from') required String from,
    @Query('to') required String to,
    @Query('format') String? format, // 'pdf' or 'csv'
  });

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
