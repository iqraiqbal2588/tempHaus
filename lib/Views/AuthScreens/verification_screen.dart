import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_text_field.dart';
import 'package:temp_haus_dental_clinic/Widgets/call_back_widget.dart';

import '../../Widgets/custom_text_widget.dart';
import 'Widgets/custom_auth_button.dart';

class VerifyAccountScreen extends StatefulWidget {
  @override
  _VerifyAccountScreenState createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  TextEditingController _codeController = TextEditingController();
  int _resendTimer = 59;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _resendCode() {
    if (_canResend) {
      setState(() {
        _resendTimer = 59;
        _canResend = false;
      });
      _startResendTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorss.whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              CustomBackButton(), // Using
              SizedBox(height: 80.h),
              Center(
                  child: CustomText(
                text: "Verify Account",
                fontWeight: FontWeight.bold,
                color: Colorss.velvetColor,
                fontSize: 27.sp,
              )),
              SizedBox(height: 10.h),
              Center(
                  child: CustomText(
                text: "A reset code has sent to ****@gmail.com.",
                fontWeight: FontWeight.bold,
                color: Colorss.velvetColor,
                fontSize: 12.sp,
              )),
              SizedBox(height: 10.h),
              Center(
                  child: CustomText(
                text: "Please enter the code to verify your account.",
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 12.sp,
              )),
              SizedBox(height: 30.h),
              CustomText(
                text: "Enter Code",
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                fontSize: 16.sp,
              ),
              SizedBox(height: 10.h),
              PrimaryFieldSignUp(
                textEditingController: _codeController,
                hintText: 'Enter Code',
              ),
              SizedBox(height: 20.h),
              Center(
                child: GestureDetector(
                    onTap: _canResend ? _resendCode : null,
                    child: CustomText(
                      text: "Didn't Receive Code?  Resend Code",
                      fontWeight: FontWeight.w500,
                      color: _canResend ? Colors.blue : Colors.grey,
                      fontSize: 14.sp,
                    )

                    // Text(
                    //   "Didn't Receive Code?  Resend Code",
                    //   style: GoogleFonts.poppins(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w500,
                    //     color: _canResend ? Colors.blue : Colors.grey,
                    //   ),
                    // ),
                    ),
              ),
              SizedBox(height: 5),
              Center(
                  child: CustomText(
                text:
                    "Resend code in 00:${_resendTimer.toString().padLeft(2, '0')}",
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 14.sp,
              )),
              SizedBox(height: 30),

              CustomButtonAuth(
                text: "Verify Account",
                onPressed: () {
                  // Get.toNamed('/dental/verfication');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
