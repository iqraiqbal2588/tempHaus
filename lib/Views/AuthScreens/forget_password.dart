import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_auth_button.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_text_field.dart';
import 'package:temp_haus_dental_clinic/Widgets/call_back_widget.dart';
import 'package:temp_haus_dental_clinic/Widgets/custom_text_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return Scaffold(
      backgroundColor: Colorss.blackColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            CustomBackButton(), // Using the reusable back button
            SizedBox(height: 30.h),
            Center(
                child: CustomText(
              text: "Forgot Password",
              fontWeight: FontWeight.bold,
              color: Colorss.appcolor,
              fontSize: 24.sp,
            )),
            SizedBox(height: 10.h),
            Center(
                child: CustomText(
              text:
                  "Please enter your email address below\nassociated with your account to receive a reset\ncode for your password. Send Reset code.",
              fontWeight: FontWeight.w600,
              color: Colors.grey[400]!,
              fontSize: 14.sp,
            )),
            SizedBox(height: 30.h),
            CustomText(
              text: "E-mail",
              fontWeight: FontWeight.w600,
              color: Colorss.whiteColor,
              fontSize: 14.sp,
            ),
            SizedBox(height: 10.h),
            PrimaryFieldSignUp(
              textEditingController: emailController,
              hintText: 'Enter your email',
            ),
            SizedBox(height: 40.h),
            CustomButtonAuth(
              text: "Send Reset Instruction",
              onPressed: () {
                Get.toNamed('/dental/newPassword');
              },
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: const Color(0xFF1C2C4D),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(35.r),
            //     ),
            //   ),
            //   onPressed: () {
            //     // Reset password logic
            //   },
            //   child: SizedBox(
            //     height: 60.h,
            //     width: double.infinity,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         SizedBox(width: 20.w),
            //         Text(
            //           "Send Reset Instruction",
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 16.sp,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         CircleAvatar(
            //           radius: 22.r,
            //           backgroundColor: Colors.white,
            //           child: Icon(
            //             Icons.arrow_forward,
            //             color: const Color(0xFF1C2C4D),
            //             size: 24.sp,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
