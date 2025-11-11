import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Widgets/custom_text_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      "description": "Track Your Workouts",
      "subDescription": "Post/find jobs for Dental \n          Professionals",
      "image": Images.onboarding1Img,
    },
    {
      "description": "Set Your Fitness Goals",
      "subDescription":
          "Select Your Hourly , weekly and \n           & Monthly Rates",
      "image": Images.onboarding2Img,
    },
    {
      "description": "Join Fitness Challenges",
      "subDescription":
          "10000+ Dental Professionals \n     here in this Platform ",
      "image": Images.onboarding3Img,
    },
  ];

  void _goToNextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offNamed('/dental/roleSelection');
    }
  }

  void _skipOnboarding() {
    Get.offNamed('/dental/roleSelection');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    // width: 375.w,
                    height: 650.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.r),
                      image: DecorationImage(
                        image: AssetImage(onboardingData[index]["image"] ?? ""),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      onboardingData[index]["description"] ?? "",
                      style: TextStyle(
                        color: Colorss.whiteColor,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: CustomText(
                        text: onboardingData[index]["subDescription"] ?? "",
                        fontWeight: FontWeight.w600,
                        color: Colorss.velvetColor,
                        fontSize: 22.sp,
                      )
                      // Text(
                      //
                      //         style: TextStyle(
                      //           color: Colorss.velvetColor,
                      //           fontSize: 24.sp,
                      //           fontWeight: FontWeight.w700
                      //         ),
                      //         textAlign: TextAlign.center,
                      //       ),
                      ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 30.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // GestureDetector(
                //   onTap: _skipOnboarding,
                //   child: Text(
                //     "Skip",
                //     style: TextStyle(
                //       color: Colorss.champagneColor,
                //       fontSize: 16.sp,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                    (index) => buildDot(index),
                  ),
                ),
                GestureDetector(
                    onTap: _goToNextPage,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colorss.velvetColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 36.sp,
                          color: Colorss.whiteColor,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 10.h,
      width: _currentPage == index ? 10.w : 10.w,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Colorss.velvetColor
            : Colorss.backButtonColor,
        borderRadius: BorderRadius.circular(5.r),
      ),
    );
  }
}
