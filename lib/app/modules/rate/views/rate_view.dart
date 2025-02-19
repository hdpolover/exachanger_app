import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/rate_controller.dart';

class RateView extends GetView<RateController> {
  const RateView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RateView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RateView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
