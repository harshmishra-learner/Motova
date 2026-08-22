import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// A single boxed digit input (visual only — used internally by [OtpInputField]).
class OtpDigitBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const OtpDigitBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 68,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,

        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,

        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        maxLength: 1,
        showCursor: false,

        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.0,
        ),

        inputFormatters: [FilteringTextInputFormatter.digitsOnly],

        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.inputBackground,

          // Small controlled padding instead of EdgeInsets.zero
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 8,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.border, width: 1),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.border, width: 1),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: AppColors.borderFocused,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

/// Full OTP entry row — manages [AppConstants.otpLength] boxes,
/// auto-advances focus forward on entry and backward on delete,
/// and reports the combined code via [onCompleted]/[onChanged].
class OtpInputField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  const OtpInputField({super.key, this.onChanged, this.onCompleted});

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      AppConstants.otpLength,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(AppConstants.otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _combinedCode => _controllers.map((c) => c.text).join();

  void _handleChanged(int index, String value) {
    if (value.isNotEmpty && index < AppConstants.otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    widget.onChanged?.call(_combinedCode);

    if (_combinedCode.length == AppConstants.otpLength) {
      widget.onCompleted?.call(_combinedCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        AppConstants.otpLength,
        (index) => OtpDigitBox(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          onChanged: (value) => _handleChanged(index, value),
        ),
      ),
    );
  }
}
