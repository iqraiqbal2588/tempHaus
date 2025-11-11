import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomBackButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 15.h,
      // width: 15.w,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: Colorss.whiteColor),
      child: IconButton(
        icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
        onPressed: onPressed ?? () => Get.back(),
      ),
    );
  }
}
