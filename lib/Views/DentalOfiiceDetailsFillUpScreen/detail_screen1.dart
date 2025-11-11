import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Controllers/office_controller.dart'; // Import OfficeController
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_text_field.dart';
import 'package:temp_haus_dental_clinic/Widgets/call_back_widget.dart';
import 'package:temp_haus_dental_clinic/Widgets/custom_text_widget.dart';
import 'package:temp_haus_dental_clinic/Widgets/forward_circle_widget.dart';

class DentalOfficeFormScreen extends StatelessWidget {
  final OfficeController officeController = Get.put(OfficeController());
  final TextEditingController officeNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorss.blackColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Padding(
                padding:  EdgeInsets.all(12.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(),
                    CustomText(
                      text: "Dental Office",
                      fontWeight: FontWeight.bold,
                      color: Colorss.appcolor,
                      fontSize: 20.sp,
                    ),
                    SizedBox(width: 40.w),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: Color(0xFFC7A777),
                        borderRadius:
                            BorderRadius.horizontal(left: Radius.circular(0)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding:  EdgeInsets.all(12.0.w),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.76,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text:
                            "Please Enter your Dental Office \ninformation for your profile",
                        fontWeight: FontWeight.w700,
                        color: Colorss.whiteColor,
                        fontSize: 20.sp,
                      ),
                      SizedBox(height: 20.h),
                      CustomText(
                        text: "Office Name",
                        fontWeight: FontWeight.w600,
                        color: Colorss.whiteColor,
                        fontSize: 16.sp,
                      ),
                      PrimaryFieldSignUp(
                        textEditingController: officeNameController,
                        hintText: 'Enter your office Name',
                        onChanged: (value) {
                          officeController.updateOfficeDetails(
                              officeName: value);
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomText(
                        text: "Address",
                        fontWeight: FontWeight.w600,
                        color: Colorss.whiteColor,
                        fontSize: 16.sp,
                      ),
                      PrimaryFieldSignUp(
                        textEditingController: addressController,
                        hintText: 'Enter your address',
                        onChanged: (value) {
                          officeController.updateOfficeDetails(address: value);
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomText(
                        text: "Phone Number",
                        fontWeight: FontWeight.w600,
                        color: Colorss.whiteColor,
                        fontSize: 16.sp,
                      ),
                      PrimaryFieldSignUp(
                        textEditingController: phoneController,
                        hintText: 'Enter your phone',
                        onChanged: (value) {
                          officeController.updateOfficeDetails(
                              phoneNumber: value);
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomText(
                        text: "Email",
                        fontWeight: FontWeight.w600,
                        color: Colorss.whiteColor,
                        fontSize: 16.sp,
                      ),
                      PrimaryFieldSignUp(
                        textEditingController: emailController,
                        hintText: 'Enter your email',
                        onChanged: (value) {
                          officeController.updateOfficeDetails(
                              officeEmail: value);
                        },
                      ),
                      SizedBox(height: 30.h),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CustomCircleAvatar(
                          onPressed: () {
                            if (officeNameController.text.trim().isEmpty ||
                                addressController.text.trim().isEmpty ||
                                phoneController.text.trim().isEmpty ||
                                emailController.text.trim().isEmpty) {
                              Get.snackbar(
                                "Missing Fields",
                                "Please fill out all the fields before continuing.",
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.TOP,
                                margin: EdgeInsets.all(16),
                              );
                            } else {
                              Get.toNamed(AppRoutes.tempDetail2);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
