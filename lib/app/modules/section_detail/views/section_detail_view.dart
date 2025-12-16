import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/section_detail_controller.dart';

class SectionDetailView extends GetView<SectionDetailController> {
  const SectionDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SectionDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SectionDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
