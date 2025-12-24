import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/parent_detail_controller.dart';

class ParentDetailView extends GetView<ParentDetailController> {
  const ParentDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ParentDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ParentDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
