import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/values/app_values.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_outlined_button.dart';
import '../../../core/widgets/cutom_text_form_field.dart';
import '../controllers/sign_in_controller.dart';

class SignInView extends BaseView<SignInController> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  void _submit() {
    Get.offNamed(Routes.HOME);
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            'Welcome Back!',
            style: titleTextStyle,
          ),
          Text(
            'Sign in to continue',
            style: regularBodyTextStyle,
          ),
          _signInForm(),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter, // align bottom
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account? ',
                  style: regularBodyTextStyle,
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Sign Up',
                    style: regularBodyTextStyle.copyWith(
                      color: AppColors.colorPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppValues.largePadding),
        ],
      ),
    );
  }

  _signInForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          SizedBox(height: AppValues.halfPadding),
          CustomTextFormField(
            labelText: 'Email',
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.email_outlined),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
            onChanged: (value) => _email = value, // Dynamically save value
          ),
          CustomTextFormField(
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Icon(Icons.lock_outline),
            isObscure: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            onChanged: (value) => _password = value, // Dynamically save value
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {},
              child: Text(
                'Forgot Password?',
                style: regularBodyTextStyle.copyWith(color: Colors.red),
              ),
            ),
          ),
          CustomButton(
            label: "Sign In",
            onPressed: _submit,
          ),
          Center(
            child: Text(
              'or',
              style: regularBodyTextStyle.copyWith(color: Colors.grey),
            ),
          ),
          CustomOutlinedButton(
            label: "Google",
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
