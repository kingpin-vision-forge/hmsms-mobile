import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/student_detail_controller.dart';

class StudentDetailView extends GetView<StudentDetailController> {
  const StudentDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudentDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StudentDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
