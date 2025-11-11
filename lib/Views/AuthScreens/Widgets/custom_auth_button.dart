import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';

class CustomButtonAuth extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final double? size;

  const CustomButtonAuth({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colorss.appcolor, // Default Dark Navy Blue
    this.textColor = Colors.white,
    this.iconBackgroundColor = Colors.white,
    this.iconColor = Colorss.appcolor,
    this.size, // Default Dark Navy Blue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35.r),
        ),
      ),
      onPressed: onPressed,
      child: SizedBox(
        height: 55.h,
        width: 350.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 10.w),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: size == null ? 18.sp : size,
                fontWeight: FontWeight.w600,
              ),
            ),
            CircleAvatar(
              radius: 22.r,
              backgroundColor: iconBackgroundColor,
              child: Icon(
                Icons.arrow_forward,
                color: iconColor,
                size: 31.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
