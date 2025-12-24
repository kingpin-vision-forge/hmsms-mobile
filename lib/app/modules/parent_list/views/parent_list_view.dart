import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/parent_list_controller.dart';

class ParentListView extends GetView<ParentListController> {
  const ParentListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ParentListView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ParentListView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
