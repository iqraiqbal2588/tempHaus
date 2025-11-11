import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_auth_button.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_button.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), checkAuthenticationAndNavigate);
  }

  Future<void> checkAuthenticationAndNavigate() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {

      Get.offAllNamed(AppRoutes.login);
      return;
    }

    final uid = user.uid;

    try {
      final officeDoc = await FirebaseFirestore.instance
          .collection('offices')
          .doc(uid)
          .get();

      final professionalDoc = await FirebaseFirestore.instance
          .collection('professionals')
          .doc(uid)
          .get();

      if (officeDoc.exists) {
        // User is dental office
        Get.offAllNamed(AppRoutes.bottomNav);
      } else if (professionalDoc.exists) {
        // User is professional
        Get.offAllNamed(AppRoutes.bottomNavProfessional);
      } else {
        // User exists in auth but not in Firestore roles
        await FirebaseAuth.instance.signOut();
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      print("Error determining user role: $e");
      Get.snackbar("Error", "Something went wrong. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 120.h),
              SizedBox(
                height: 290.h,
                width: 300.w,
                child: Image.asset(
                  Images.logoImage,
                ),
              ),
              SizedBox(height: 200.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SizedBox(
                  height: 60.h,
                  child: CustomButtonAuth(
                    text: "Sign up",
                    onPressed: () {
                      Get.toNamed(AppRoutes.signup);
                    },
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              CustomButtonWidget(
                text: 'Already have an account? Login',
                onPressed: () {
                  Get.toNamed(AppRoutes.login);
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
