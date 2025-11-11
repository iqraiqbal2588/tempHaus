import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_auth_button.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_button.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_text_field.dart';
import 'package:temp_haus_dental_clinic/Widgets/custom_text_widget.dart';
import '../../Services/auth_sevices.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorss.blackColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  CustomText(
                    text: "Welcome Back!",
                    fontWeight: FontWeight.w700,
                    color: Colorss.whiteColor,
                    fontSize: 26.sp,
                  ),
                  SizedBox(height: 15.h),
                  CustomText(
                    text: "Please log in below",
                    fontWeight: FontWeight.w600,
                    color: Colorss.whiteColor,
                    fontSize: 18.sp,
                  ),
                  SizedBox(height: 10.h),
                  Image.asset(
                    Images.logoImage,
                    height: 130.h,
                    width: 156.w,
                  ),
                  const SizedBox(height: 20),
                  PrimaryFieldSignUp(
                    textEditingController: emailController,
                    hintText: 'Email',
                  ),
                  SizedBox(height: 15.h),
                  PrimaryFieldSignUp(
                    textEditingController: passwordController,
                    hintText: 'Password',
                  ),
                  const SizedBox(height: 20),
                  CustomButtonAuth(
                    text: "Sign In",
                    onPressed: () {
                      _authService.signIn(
                        context,
                        _formKey,
                        emailController,
                        passwordController,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed('/dental/forgetScreen');
                      },
                      child: CustomText(
                        text: "Forgot your password?",
                        fontWeight: FontWeight.w700,
                        color: Colorss.whiteColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  CustomButtonWidget(
                    text: "Create new account",
                    onPressed: () {
                      Get.toNamed('/dental/signup');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
