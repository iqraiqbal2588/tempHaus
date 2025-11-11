import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_auth_button.dart';
import 'package:temp_haus_dental_clinic/Widgets/call_back_widget.dart';
import 'package:temp_haus_dental_clinic/Widgets/custom_text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeDentalOfficeScreen extends StatelessWidget {
  final String userName; // Pass this from your login screen
  final DateTime loginDate = DateTime.now();

  WelcomeDentalOfficeScreen({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM dd, yyyy').format(loginDate);
    final formattedTime = DateFormat('hh:mm a').format(loginDate);

    return Scaffold(
      backgroundColor: Colorss.whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              CustomBackButton(),
              SizedBox(height: 20.h),
              // User and Date Info Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  color: Colorss.appcolor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colorss.appcolor.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_outline, color: Colorss.appcolor, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          "Logged in as:",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colorss.darkGreyColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colorss.appcolor, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          "Login Date:",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colorss.darkGreyColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "$formattedDate at $formattedTime",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: CircleAvatar(
                  radius: 70.r,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 70.sp, color: Colors.white),
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: CustomText(
                  text: "Welcome $userName to Temp Haus",
                  fontWeight: FontWeight.bold,
                  color: Colorss.velvetColor,
                  fontSize: 26.sp,
                  textAlign: TextAlign.center,
                  shadows: [
                    Shadow(
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: CustomText(
                  text: "Please check your email to verify your account",
                  fontWeight: FontWeight.w400,
                  color: Colorss.darkGreyColor,
                  fontSize: 14.sp,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 60.h),
              CustomButtonAuth(
                text: "Click here",
                onPressed: () {
                  Get.toNamed('/dental/temp/posting');
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}