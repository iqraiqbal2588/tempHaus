import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Views/RoleSelectionScreen/Widget/custom_button.dart';

class RoleSelection extends StatelessWidget {
  const RoleSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image


          // Gradient Overlay (Optional for better readability)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),

          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pushes content towards the bottom
              const SizedBox(height: 30),
              // Logo
              Image.asset(
                Images.logoImage, // Replace with your actual logo
                height: 290,
              ),

              Spacer(),

              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CustomButton(
                      text:
                          "I am a dental professional \n looking for temp works",
                      onPressed: () {
                        Get.toNamed(AppRoutes.signup);
                      },
                    ),
                    SizedBox(height: 18.h,),
                    CustomButton(
                      text: "I am a dental Office Looking\n for a Temp",
                      onPressed: () {
                        Get.toNamed(AppRoutes.tempDetail1);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ],
      ),
    );
  }
}
