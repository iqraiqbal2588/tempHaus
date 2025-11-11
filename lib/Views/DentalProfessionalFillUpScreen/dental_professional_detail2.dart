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

class DentalProfessionalForm2Screen extends StatefulWidget {
  @override
  State<DentalProfessionalForm2Screen> createState() =>
      _DentalProfessionalForm2ScreenState();
}

class _DentalProfessionalForm2ScreenState
    extends State<DentalProfessionalForm2Screen> {
  TextEditingController emailTransfer = TextEditingController();
  TextEditingController graduatingController = TextEditingController();
  TextEditingController licenseNumber = TextEditingController();
  final controller = Get.find<ProfessionalController>();
  String? selectedValue;
  Map<String, bool> options = {
    "Dental Assistant": false,
    "Dental Hygienist": false,
  };

  @override
  void initState() {
    super.initState();
    options.updateAll((key, value) => false);
    selectedValue = null;
    emailTransfer.clear();
    graduatingController.clear();
    licenseNumber.clear();
  }

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
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.76,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 20.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Email ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colorss.whiteColor,
                                fontSize: 16.sp,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "(this email will be used for e-transfer payments from dental office to you)",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colorss.whiteColor,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PrimaryFieldSignUp(
                        textEditingController: emailTransfer,
                        hintText: 'Enter your Email',
                      ),
                      SizedBox(height: 15.h),
                      CustomText(
                        text: "Role",
                        fontWeight: FontWeight.w600,
                        color: Colorss.whiteColor,
                        fontSize: 16.sp,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedValue,
                            hint: Text("Select Role",
                                style: TextStyle(color: Colors.black)),
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.black),
                            onChanged: (newValue) {
                              setState(() {
                                selectedValue = newValue;
                                options.updateAll((key, value) => false);
                                options[selectedValue!] = true;
                              });
                            },
                            items: options.keys.map((String role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Row(
                                  children: [
                                    if (selectedValue == role)
                                      Icon(Icons.check,
                                          color: Colors.green, size: 18),
                                    SizedBox(width: 8),
                                    Text(role,
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      CustomText(
                        text: "Graduating Year ",
                        fontWeight: FontWeight.w600,
                        color: Colorss.whiteColor,
                        fontSize: 16.sp,
                      ),
                      PrimaryFieldSignUp(
                        textEditingController: graduatingController,
                        hintText: 'Enter graduation year',
                      ),
                      SizedBox(height: 15.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "License Number",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colorss.whiteColor,
                                fontSize: 16.sp,
                              ),
                            ),
                            TextSpan(
                              text: "(only for hygienists)",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colorss.whiteColor,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PrimaryFieldSignUp(
                        textEditingController: licenseNumber,
                        hintText: 'Enter your license number',
                      ),
                      SizedBox(height: 30.h),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CustomCircleAvatar(
                          onPressed: () {
                            controller.updateProfessional(
                              emailPayment: emailTransfer.text,
                              role: selectedValue,
                              graduatingYear:
                                  int.tryParse(graduatingController.text),
                              licenseNumber: licenseNumber.text,
                            );
                            Get.toNamed(AppRoutes.professionalSkills);
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
