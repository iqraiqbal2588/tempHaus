import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Views/JobPosts/Widget/next_button.dart';
import 'package:temp_haus_dental_clinic/Widgets/call_back_widget.dart';
import 'package:temp_haus_dental_clinic/Widgets/custom_text_widget.dart';

class PostJobScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(),
                  CustomText(
                    text: "Post Job",
                    fontWeight: FontWeight.bold,
                    color: Colorss.whiteColor,
                    fontSize: 18.sp,
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: MediaQuery.of(context).size.width *
                  1, // Adjust the width as needed
              height: 8.h, // Adjust the height for thickness
              decoration: BoxDecoration(
                color: Colors.black, // Black background
                borderRadius: BorderRadius.circular(0),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.w, // Adjust for the progress percentage
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFC7A777), // Beige/Golden progress bar
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(0)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: Colors.white, // White remaining section
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.circular(0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.9, // Adjust width as needed
                height: MediaQuery.of(context).size.height *
                    0.3, // Adjust height as needed
                decoration: BoxDecoration(
                  color: Colors.transparent, // White background
                  borderRadius:
                      BorderRadius.circular(10), // Optional: Rounded corners
                  boxShadow: [
                    // Optional: Adds a shadow for better visibility
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Images.jobPost, // Replace with your SVG file path
                    width: 100, // Adjust size as needed
                    height: 210,
                    // Apply color if needed
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomText(
                text: "Posting a Temping Position ?",
                fontWeight: FontWeight.bold,
                color: Colorss.whiteColor,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomText(
                text: "We are so happy to help! Kindly let us know what you \n"
                    "are looking for so we can find the right temp \nfor your dental office\n\n",


                fontWeight: FontWeight.w500,
                color: Colorss.whiteColor,
                fontSize: 14.sp,
              ),
            ),
            Spacer(),
            Center(
              child: NextContainer(
                buttonText: 'Next',
                onPressed: () {
                  Get.toNamed(AppRoutes.availableTime);
                },
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
