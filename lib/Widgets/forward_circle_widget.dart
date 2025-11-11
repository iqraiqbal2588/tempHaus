import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';

class CustomCircleAvatar extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomCircleAvatar({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        radius: 26.r,
        backgroundColor: Colorss.appcolor, // Velvet Color
        child: Icon(
          Icons.arrow_forward, // Arrow Forward Icon
          color: Colors.white, // White Icon
          size: 24.sp,
        ),
      ),
    );
  }
}
