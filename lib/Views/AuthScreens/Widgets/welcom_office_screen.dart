import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Widgets/call_back_widget.dart';
import 'package:temp_haus_dental_clinic/Widgets/custom_text_widget.dart';

import '../../RoleSelectionScreen/Widget/custom_button.dart';

class WelcomeScreenOffice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Align(
                alignment: Alignment.topLeft,
                child: CustomBackButton(),
              ),
            ),
            CircleAvatar(
              radius: 60.r,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 100.sp, color: Colors.white),
            ),
            SizedBox(height: 30.h),
            CustomText(
              text: "Welcome ",
              fontWeight: FontWeight.bold,
              color: Colorss.whiteColor,
              fontSize: 27.sp,
            ),
            SizedBox(height: 15.h),

            SizedBox(height: 15.h),
            CustomText(
              text: "Family Dental to Temp Haus",
              fontWeight: FontWeight.bold,
              color: Colorss.whiteColor,
              fontSize: 26.sp,
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomText(
                text:
                    "We are so happy to assist you in posting or\n finding your next Dental Professional\n\nYour profile has been completed.\n\nWhat would you like to do next?",
                color: Colorss.whiteColor,
                fontSize: 16.sp,
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  CustomButton(
                    text: "Post for a temp",
                    onPressed: () {
                      Get.toNamed(AppRoutes.postJob1);
                    },
                  ),
                  SizedBox(height: 15.h),
                  CustomButton(
                    text: "See available temps",
                    onPressed: () {
                       Get.toNamed(AppRoutes.bottomNavProfessional);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
