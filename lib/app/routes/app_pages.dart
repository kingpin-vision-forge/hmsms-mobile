import 'package:get/get.dart';

import '../modules/bottom_navbar/bindings/bottom_navbar_binding.dart';
import '../modules/bottom_navbar/views/bottom_navbar_view.dart';
import '../modules/class_detail/bindings/class_detail_binding.dart';
import '../modules/class_detail/views/class_detail_view.dart';
import '../modules/class_list/bindings/class_list_binding.dart';
import '../modules/class_list/views/class_list_view.dart';
import '../modules/create_class/bindings/create_class_binding.dart';
import '../modules/create_class/views/create_class_view.dart';
import '../modules/create_parent/bindings/create_parent_binding.dart';
import '../modules/create_parent/views/create_parent_view.dart';
import '../modules/create_section/bindings/create_section_binding.dart';
import '../modules/create_section/views/create_section_view.dart';
import '../modules/create_subject/bindings/create_subject_binding.dart';
import '../modules/create_subject/views/create_subject_view.dart';
import '../modules/fees/bindings/fees_binding.dart';
import '../modules/fees/views/fees_view.dart';
import '../modules/fees_detail/bindings/fees_detail_binding.dart';
import '../modules/fees_detail/views/fees_detail_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/menu/bindings/menu_binding.dart';
import '../modules/menu/views/menu_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/parent_detail/bindings/parent_detail_binding.dart';
import '../modules/parent_detail/views/parent_detail_view.dart';
import '../modules/parent_list/bindings/parent_list_binding.dart';
import '../modules/parent_list/views/parent_list_view.dart';
import '../modules/section_detail/bindings/section_detail_binding.dart';
import '../modules/section_detail/views/section_detail_view.dart';
import '../modules/section_list/bindings/section_list_binding.dart';
import '../modules/section_list/views/section_list_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/student_detail/bindings/student_detail_binding.dart';
import '../modules/student_detail/views/student_detail_view.dart';
import '../modules/student_list/bindings/student_list_binding.dart';
import '../modules/student_list/views/student_list_view.dart';
import '../modules/students/bindings/students_binding.dart';
import '../modules/students/views/students_view.dart';
import '../modules/subject_detail/bindings/subject_detail_binding.dart';
import '../modules/subject_detail/views/subject_detail_view.dart';
import '../modules/subject_list/bindings/subject_list_binding.dart';
import '../modules/subject_list/views/subject_list_view.dart';
import '../modules/teacher_detail/bindings/teacher_detail_binding.dart';
import '../modules/teacher_detail/views/teacher_detail_view.dart';
import '../modules/teacher_list/bindings/teacher_list_binding.dart';
import '../modules/teacher_list/views/teacher_list_view.dart';
import '../modules/teachers/bindings/teachers_binding.dart';
import '../modules/teachers/views/teachers_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOM_NAVBAR,
      page: () => BottomNavbarView(),
      binding: BottomNavbarBinding(),
    ),
    GetPage(
      name: _Paths.STUDENTS,
      page: () => const StudentsView(),
      binding: StudentsBinding(),
    ),
    GetPage(
      name: _Paths.TEACHERS,
      page: () => const TeachersView(),
      binding: TeachersBinding(),
    ),
    GetPage(
      name: _Paths.MENU,
      page: () => const MenuView(),
      binding: MenuBinding(),
    ),
    GetPage(
      name: _Paths.FEES,
      page: () => const FeesView(),
      binding: FeesBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.STUDENT_LIST,
      page: () => const StudentListView(),
      binding: StudentListBinding(),
    ),
    GetPage(
      name: _Paths.STUDENT_DETAIL,
      page: () => StudentDetailView(),
      binding: StudentDetailBinding(),
    ),
    GetPage(
      name: _Paths.TEACHER_LIST,
      page: () => const TeacherListView(),
      binding: TeacherListBinding(),
    ),
    GetPage(
      name: _Paths.TEACHER_DETAIL,
      page: () => const TeacherDetailView(),
      binding: TeacherDetailBinding(),
    ),
    GetPage(
      name: _Paths.FEES_DETAIL,
      page: () => const FeesDetailView(),
      binding: FeesDetailBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_CLASS,
      page: () => const CreateClassView(),
      binding: CreateClassBinding(),
    ),
    GetPage(
      name: _Paths.CLASS_LIST,
      page: () => const ClassListView(),
      binding: ClassListBinding(),
    ),
    GetPage(
      name: _Paths.CLASS_DETAIL,
      page: () => ClassDetailView(),
      binding: ClassDetailBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_SECTION,
      page: () => CreateSectionView(),
      binding: CreateSectionBinding(),
    ),
    GetPage(
      name: _Paths.SECTION_LIST,
      page: () => const SectionListView(),
      binding: SectionListBinding(),
    ),
    GetPage(
      name: _Paths.SECTION_DETAIL,
      page: () => SectionDetailView(),
      binding: SectionDetailBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_PARENT,
      page: () => const CreateParentView(),
      binding: CreateParentBinding(),
    ),
    GetPage(
      name: _Paths.PARENT_LIST,
      page: () => const ParentListView(),
      binding: ParentListBinding(),
    ),
    GetPage(
      name: _Paths.PARENT_DETAIL,
      page: () => ParentDetailView(),
      binding: ParentDetailBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_SUBJECT,
      page: () => const CreateSubjectView(),
      binding: CreateSubjectBinding(),
    ),
    GetPage(
      name: _Paths.SUBJECT_LIST,
      page: () => const SubjectListView(),
      binding: SubjectListBinding(),
    ),
    GetPage(
      name: _Paths.SUBJECT_DETAIL,
      page: () => SubjectDetailView(),
      binding: SubjectDetailBinding(),
    ),
  ];
}
