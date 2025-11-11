import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_text_field.dart';
import 'package:temp_haus_dental_clinic/Widgets/call_back_widget.dart';
import 'package:temp_haus_dental_clinic/Widgets/custom_text_widget.dart';

import 'Widgets/custom_auth_button.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  @override
  _CreateNewPasswordScreenState createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorss.blackColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              CustomBackButton(),
              SizedBox(height: 80.h),
              Center(
                child: CustomText(
                  text: "Create New Password",
                  fontWeight: FontWeight.bold,
                  color: Colorss.appcolor,
                  fontSize: 27.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: CustomText(
                  text:
                      "Please enter and confirm your new password.\nYou will need to login after you reset.",
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 13.sp,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30.h),
              CustomText(
                text: "Password",
                fontWeight: FontWeight.w500,
                color: Colorss.appcolor,
                fontSize: 16.sp,
              ),
              SizedBox(height: 10.h),
              PrimaryFieldSignUp(
                textEditingController: _passwordController,
                hintText: '********',
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              SizedBox(height: 5.h),
              CustomText(
                text: "must contain 8 char.",
                fontWeight: FontWeight.w400,
                color: Colors.black54,
                fontSize: 12.sp,
              ),
              SizedBox(height: 20.h),
              CustomText(
                text: "Confirm Password",
                fontWeight: FontWeight.w500,
                color: Colorss.appcolor,
                fontSize: 16.sp,
              ),
              SizedBox(height: 10.h),
              PrimaryFieldSignUp(
                textEditingController: _passwordController,
                hintText: '********',
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              SizedBox(height: 30.h),
              CustomButtonAuth(
                text: "Create New Account",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
