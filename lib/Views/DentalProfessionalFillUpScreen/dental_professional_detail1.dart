import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Controllers/professional_controller.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_text_field.dart';
import 'package:temp_haus_dental_clinic/Widgets/call_back_widget.dart';
import 'package:temp_haus_dental_clinic/Widgets/custom_text_widget.dart';
import 'package:temp_haus_dental_clinic/Widgets/forward_circle_widget.dart';

class DentalProfessionalForm1Screen extends StatefulWidget {
  @override
  State<DentalProfessionalForm1Screen> createState() =>
      _DentalProfessionalForm1ScreenState();
}

class _DentalProfessionalForm1ScreenState
    extends State<DentalProfessionalForm1Screen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  final controller = Get.find<ProfessionalController>();

  @override
  Widget build(BuildContext context) {
    controller.professional;
    return Scaffold(
      backgroundColor: Colorss.blackColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(),
                    CustomText(
                      text: "Dental Professional",
                      fontWeight: FontWeight.bold,
                      color: Colorss.appcolor,
                      fontSize: 20.sp,
                    ),
                    SizedBox(width: 40.w),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              // Progress Bar
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
                      width: 80.w, // Adjust for the progress percentage
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
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              // Form Fields
              Padding(
                padding: EdgeInsets.all(12.0.w),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Enter your personal information below ",
                        fontWeight: FontWeight.w700,
                        color: Colorss.whiteColor,
                        fontSize: 20.sp,
                      ),
                      SizedBox(height: 20.h),
                      CustomText(
                        text: "First Name",
                        fontWeight: FontWeight.w600,
                        color: Colorss.whiteColor,
                        fontSize: 16.sp,
                      ),
                      SizedBox(height: 15.h),
                      PrimaryFieldSignUp(
                        textEditingController: firstName,
                        hintText: 'Enter your First Name',
                      ),
                      SizedBox(height: 15.h),
                      CustomText(
                        text: "Last Name",
                        fontWeight: FontWeight.w600,
                        color: Colorss.whiteColor,
                        fontSize: 16.sp,
                      ),
                      SizedBox(height: 15.h),
                      PrimaryFieldSignUp(
                        textEditingController: lastName,
                        hintText: 'Enter your Last Name',
                      ),
                      SizedBox(height: 15.h),
                      CustomText(
                        text: "Address",
                        fontWeight: FontWeight.w600,
                        color: Colorss.whiteColor,
                        fontSize: 16.sp,
                      ),
                      SizedBox(height: 15.h),
                      PrimaryFieldSignUp(
                        textEditingController: address,
                        hintText: 'Enter your address',
                      ),
                      SizedBox(height: 15.h),
                      CustomText(
                        text: "Phone Number",
                        fontWeight: FontWeight.w600,
                        color: Colorss.whiteColor,
                        fontSize: 16.sp,
                      ),
                      SizedBox(height: 15.h),
                      PrimaryFieldSignUp(
                        textEditingController: phoneNumber,
                        hintText: 'Enter your phone',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 5.7),
              Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      label: Text("Previous",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp)),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CustomCircleAvatar(
                        onPressed: () {
                          controller.updateProfessional(
                            firstName: firstName.text,
                            lastName: lastName.text,
                            address: address.text,
                            phoneNumber: phoneNumber.text,
                          );
                          Get.toNamed(AppRoutes.professionalsDetail2);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
