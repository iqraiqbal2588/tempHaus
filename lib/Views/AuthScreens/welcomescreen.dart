import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Controllers/office_controller.dart';
import 'package:temp_haus_dental_clinic/Controllers/professional_controller.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key? key}) : super(key: key);
  final controller = Get.find<ProfessionalController>();
  final officeController = Get.find<OfficeController>();

  @override
  Widget build(BuildContext context) {
    final email = Get.parameters['email'] ?? 'no email';
    final password = Get.parameters['encryptedPassword'] ?? 'no password';
    print('hello $email and me also comming wait $password');
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.only(left: 12.w, right: 12.w, top: 12.h, bottom: 12.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 120.h,
            ),
            SizedBox(
              height: 250.h,
              width: 300.w,
              child: Image.asset(
                Images.logoImage,
              ),
            ),
            SizedBox(
              height: 100.h,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colorss.appcolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.r),
                ),
              ),
              onPressed: () {
                controller.updateProfessional(
                  email: email,
                  password: password,
                );
                Get.toNamed(AppRoutes.professionalsDetail1);
              },
              child: SizedBox(
                height:
                    70.h, // Increased height to accommodate two lines of text
                width: 350.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10.w), // Spacing on the left side
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text to the left
                        children: [
                          Text(
                            'I am a Dental Professional',
                            style: TextStyle(
                              color: Colorss.whiteColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2.h), // Small spacing between lines
                          Text(
                            'looking for a Temp',
                            style: TextStyle(
                              color: Colorss.whiteColor,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 26.r,
                      backgroundColor: Colorss.whiteColor,
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colorss.appcolor,
                        size: 30.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colorss.appcolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.r),
                ),
              ),
              onPressed: () {
                officeController.updateOfficeDetails(
                    email: email, password: password);
                Get.toNamed(AppRoutes.tempDetail1);
              },
              child: SizedBox(
                height: 70.h,
                width: 350.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10.w), // Spacing on the left side
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text to the left
                        children: [
                          Text(
                            'I am a Dental Office looking',
                            style: TextStyle(
                              color: Colorss.whiteColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'for a Temp',
                            style: TextStyle(
                              color: Colorss.whiteColor,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 26.r,
                      backgroundColor: Colorss.whiteColor,
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colorss.appcolor,
                        size: 30.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
