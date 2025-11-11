import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Controllers/availability_controller.dart';
import 'package:temp_haus_dental_clinic/Controllers/professional_controller.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_auth_button.dart';

class CompletedProfessionalScreen extends StatelessWidget {
  final controller = Get.find<ProfessionalController>();
  final availabilityController = Get.find<AvailabilityController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.h, bottom: 40.h, right: 10.w),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  "Skip",
                  style: TextStyle(
                      color: Colorss.appcolor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp),
                ),
              ),
            ),
            Container(
              height: 450.h,
              decoration: BoxDecoration(
                color: Color(0xFFF5E8D6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "You are all set Cristina!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: SvgPicture.asset(
                      Images.checkMark, // Replace with your SVG file path
                      width: 90.w, // Adjust size as needed
                      height: 200.h,
                      // Apply color if needed
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "We are so happy to have you join Temp Haus.\nNow lets get started!",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  CustomButtonAuth(
                    text: "Post Available Days",
                    onPressed: () {
                      Get.toNamed(AppRoutes.professionalsAvailable);
                    },
                  ),
                  SizedBox(height: 10.h),
                  CustomButtonAuth(
                    text: "See all postings",
                    onPressed: () {
                      print(
                          "Availability Data: ${availabilityController.getAvailabilityData()}");

                      print(
                          "Professional Data: ${controller.professional.value}");
                      Get.offAllNamed(AppRoutes.bottomNavProfessional);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
