import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Services/auth_sevices.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_button.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_text_field.dart';
import 'package:temp_haus_dental_clinic/Widgets/custom_text_widget.dart';

import 'Widgets/custom_auth_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isChecked = false;
  final AuthService _authService = AuthService();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  CustomText(
                    text: "Create Account",
                    fontWeight: FontWeight.w700,
                    color: Colorss.whiteColor,
                    fontSize: 28.sp,
                  ),
                  SizedBox(height: 15.h),
                  CustomText(
                    text: "Let's get started and create your account!",
                    fontWeight: FontWeight.w700,
                    color: Colorss.whiteColor,
                    fontSize: 14.sp,
                  ),
                  SizedBox(height: 20.h),
                  Image.asset(
                    Images.logoImage,
                    height: 130.h,
                    width: 156.w,
                  ),
                  const SizedBox(height: 20),
                  PrimaryFieldSignUp(
                    textEditingController: emailController,
                    hintText: 'Email',
                    type: 'email',
                  ),
                  SizedBox(height: 15.h),
                  PrimaryFieldSignUp(
                    textEditingController: passwordController,
                    hintText: 'Password',
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 15.h),
                  PrimaryFieldSignUp(
                    textEditingController: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                      Expanded(
                        child: Text(
                          "Agree to Terms & Conditions",
                          style: TextStyle(
                              fontSize: 14.sp, color: Colorss.whiteColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  CustomButtonAuth(
                    text: "Sign Up",
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      if (!isChecked) {
                        Get.snackbar("Terms Required",
                            "Please agree to the terms & conditions.",
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                        return;
                      }

                      _authService.signUp(
                        context,
                        _formKey,
                        emailController,
                        passwordController,
                        "", // don't use route here
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed('/dental/forgetScreen');
                      },
                      child: Text(
                        "Forgot your password?",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colorss.whiteColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  CustomButtonWidget(
                    text: "Already have an account? Login",
                    onPressed: () {
                      Get.offNamed('/dental/login');
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
