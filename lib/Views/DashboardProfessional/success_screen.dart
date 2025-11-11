import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "Done",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success animation placeholder
            Container(
              width: 312,
              height: 302,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Confetti effect placeholder
                  Positioned.fill(
                    child:
                        Icon(Icons.celebration, color: Colors.brown, size: 100),
                  ),
                  // Checkmark icon
                  Center(
                    child: SvgPicture.asset(
                      Images.checkMark, // Replace with your SVG file path
                      width: 312.w, // Adjust size as needed
                      height: 300.h,
                      // Apply color if needed
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            // Text message
            Text(
              "You will receive a\nnotification shortly",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colorss.appcolor,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 90.h),
            // Back to dashboard button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colorss.appcolor,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              onPressed: () {
                Get.offAllNamed(AppRoutes.bottomNavProfessional);
              },
              child: Text(
                "Back to Dashboard",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
