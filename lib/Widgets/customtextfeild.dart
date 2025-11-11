import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomTextField({
    Key? key,
    required this.hint,
    required this.icon,
    this.controller,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(icon, color: Colors.grey, size: 18.sp),
          filled: true,
          fillColor: Colorss.marbleColor,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: Colorss.appcolor,
              width: 1.5,
            ),
          ),
        ),
        obscureText: obscureText,
      ),
    );
  }
}
