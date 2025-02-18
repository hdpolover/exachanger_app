import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool isObscure;
  final Widget? prefixIcon;
  final int? maxLength;
  final int? maxLines;
  final Function(String)? onChanged;

  const CustomTextFormField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isObscure = false,
    this.prefixIcon,
    this.maxLength,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isObscure; // Initialize with the passed isObscure value
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Text(
            widget.labelText!,
            style: regularBodyTextStyle.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isObscure ? _isObscure : false,
          validator: widget.validator,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: regularBodyTextStyle.copyWith(
              color: Colors.grey,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isObscure
                ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
