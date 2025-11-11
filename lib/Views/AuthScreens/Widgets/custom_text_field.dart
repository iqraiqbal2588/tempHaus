import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';

class PrimaryFieldSignUp extends StatefulWidget {
  final bool enabled;
  final bool obscureText;
  final TextEditingController textEditingController;
  final String hintText;
  final String type;
  final String? label;
  final Widget? suffixIcon; // Add this parameter
  final Function(String)?
      onChanged; // Add this parameter for onChanged callback

  const PrimaryFieldSignUp({
    this.enabled = true,
    this.obscureText = false,
    required this.textEditingController,
    required this.hintText,
    this.type = 'none',
    this.label,
    this.suffixIcon, // Initialize here
    this.onChanged, // Initialize here
    super.key,
  });

  @override
  State<PrimaryFieldSignUp> createState() => _PrimaryFieldSignUpState();
}

class _PrimaryFieldSignUpState extends State<PrimaryFieldSignUp> {
  String? Function(String?)? validator;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 'email') {
      validator = (value) {
        RegExp emailRegExp =
            RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

        if (value == null || value == '') {
          return 'Enter a valid email';
        }
        if (!emailRegExp.hasMatch(value)) {
          return 'Invalid email format';
        }

        return null;
      };
    } else if (widget.type == 'password') {
      validator = (value) {
        if (value == null || value == '') {
          return 'Enter a valid password';
        }
        if (value.length <= 7) {
          return 'Password must be greater than 8 characters';
        }
        return null;
      };
    } else if (widget.type == 'confirmPassword') {
      validator = (value) {
        RegExp passwordRegExp = RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[@#\$!%]).{8,}\$');

        if (value == null || value == '') {
          return 'Enter a valid password';
        }

        if (!passwordRegExp.hasMatch(value)) {
          return 'Use Upper & Lowercase letters, Numbers, @, #, \$, !, %';
        }
        return null;
      };
    }

    return TextFormField(
      enabled: widget.enabled,
      controller: widget.textEditingController,
      obscureText: _obscureText,
      style: TextStyle(
        fontSize: 14.sp,
        color: Colorss.darkGreyColor,
        fontWeight: FontWeight.w400,
      ),
      validator: validator,
      onChanged: widget.onChanged,
      // Trigger onChanged callback
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
        label: widget.label != null ? Text(widget.label!) : null,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 12.sp,
          color: Colorss.darkGreyColor,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(
            color: Colorss.darkGreyColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: const BorderSide(
            color: Color(0xffD8D8D8),
          ),
        ),
        suffixIcon: widget.suffixIcon, // Use the passed suffixIcon
      ),
    );
  }
}
