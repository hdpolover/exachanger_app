import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/exchange_controller.dart';

class ExchangeView extends GetView<ExchangeController> {
  const ExchangeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExchangeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ExchangeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
