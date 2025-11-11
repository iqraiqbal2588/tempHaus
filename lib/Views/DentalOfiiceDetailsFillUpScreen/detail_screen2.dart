import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Widgets/call_back_widget.dart';
import 'package:temp_haus_dental_clinic/Widgets/custom_text_widget.dart';
import 'package:temp_haus_dental_clinic/Widgets/forward_circle_widget.dart';

import '../../Controllers/office_controller.dart';

class DentalOfficeScreen2 extends StatefulWidget {
  @override
  _DentalOfficeScreen2State createState() => _DentalOfficeScreen2State();
}

class _DentalOfficeScreen2State extends State<DentalOfficeScreen2> {
  List<String> officeTypes = [
    "Orthodontic Office",
    "Pediatric Office",
    "Oral Surgery",
    "Endo Office",
    "Perio Office",
    "Other"
  ];
  final OfficeController officeController =
      Get.put(OfficeController()); // Bind the controller

  String? selectedOfficeType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
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
            SizedBox(height: 20.h),
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
                    width: 170.w, // Adjust for the progress percentage
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
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.circular(0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Please enter your Dental Office information for your profile",
                    style: TextStyle(color: Colors.white, fontSize: 20.sp),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Office Type",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: MediaQuery.of(context).size.width *
                        1, // Half of screen width
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white, // Keep the button background white
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedOfficeType,
                        hint: Text(
                          "Select Office Type",
                          style: TextStyle(color: Colors.black),
                        ),
                        isExpanded: true,
                        dropdownColor: Colors.black,
                        icon: Icon(Icons.arrow_drop_down,
                            color: Colorss.appcolor),
                        items: officeTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  type,
                                  style: TextStyle(color: Colors.white),
                                ),
                                if (selectedOfficeType == type)
                                  Icon(Icons.check, color: Colorss.appcolor)
                                else
                                  SizedBox(width: 24), // Keep alignment
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOfficeType = newValue;
                            officeController.updateOfficeDetails(
                                officeType: newValue);
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return officeTypes.map((String type) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                type,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: CustomCircleAvatar(
                  onPressed: () {
                    if (selectedOfficeType == null ||
                        selectedOfficeType!.isEmpty) {
                      Get.snackbar(
                        "Missing Information",
                        "Please select an office type before continuing.",
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      Get.toNamed(AppRoutes.tempDetail3);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DentalOfficeScreen2(),
  ));
}
