import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sign_up_controller.dart';

class SignUpView extends BaseView<SignUpController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      title: const Text('SignUpView'),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return const Center(
      child: Text(
        'SignUpView is working',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
