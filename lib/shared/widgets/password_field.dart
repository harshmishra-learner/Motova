import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'app_text_field.dart';

/// Password input with the eye-icon visibility toggle seen in the
/// wireframes (Sign Up, Login, Change Password).
class PasswordField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    this.hintText = 'Password',
    this.controller,
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      hintText: widget.hintText,
      controller: widget.controller,
      obscureText: _obscured,
      validator: widget.validator,
      suffixIcon: IconButton(
        icon: Icon(
          _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.textSecondary,
          size: 22,
        ),
        onPressed: () => setState(() => _obscured = !_obscured),
      ),
    );
  }
}