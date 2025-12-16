import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/class_detail_controller.dart';

class ClassDetailView extends GetView<ClassDetailController> {
  const ClassDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClassDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ClassDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
