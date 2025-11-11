import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Make it nullable
  final bool isDisabled; // Add an optional isDisabled parameter

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed, // Nullable onPressed
    this.isDisabled = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? Colors.grey : Colorss.appcolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r), // Fully rounded shape
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 3.w),
        elevation: 2,
      ),
      onPressed:
          isDisabled ? null : onPressed, // Disable button if isDisabled is true
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 23.w),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.arrow_forward,
              color: Color(0xFF1C2C4D),
              size: 30.sp,
            ),
          ),
        ],
      ),
    );
  }
}
