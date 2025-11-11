import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Controllers/availability_controller.dart';
import 'package:temp_haus_dental_clinic/Controllers/professional_controller.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/custom_text_field.dart';

import '../../Widgets/8_didgit_code.dart';

class ProfessionalWages extends StatefulWidget {
  @override
  State<ProfessionalWages> createState() => _ProfessionalWagesState();
}

class _ProfessionalWagesState extends State<ProfessionalWages> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = false;
  final AvailabilityController availabilityController = Get.put(AvailabilityController());
  final ProfessionalController controller = Get.find<ProfessionalController>();
  final TextEditingController wageController = TextEditingController();
  List<String> experienceOptions = ["Single Day", "Hourly wage"];
  String selectedExperiences = 'Single Day';

  Future<void> uploadProfessionalAndAvailability(String uid) async {
    setState(() {
      isLoading = true;
    });

    try {
      // 1. Prepare professional data
      final professional = controller.professional.value;
      final professionalData = professional.toJson();

      // 2. Prepare availability data
      final availabilityData = availabilityController.getAvailabilityData();
      String code = generate8DigitCode();

      Map<String, dynamic> availabilityMap = availabilityData.toJson();
      availabilityMap['docId'] = code;
      availabilityMap['experience'] = professional.workExperience;
      availabilityMap['about'] = professional.bio;
      availabilityMap['image'] = professional.imageUrl;
      availabilityMap['location'] = professional.address;
      availabilityMap['profession'] = professional.role;
      availabilityMap['name'] = '${professional.firstName} ${professional.lastName}';
      availabilityMap['status'] = 'Pending';
      availabilityMap['hourlyWage'] = double.tryParse(wageController.text) ?? 0;
      availabilityMap['wageType'] = selectedExperiences;
      availabilityMap['createdAt'] = FieldValue.serverTimestamp();
      availabilityMap['uid'] = uid; // Store the user ID with availability

      // 3. Use batch write for atomic operation
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Update main professional document
      DocumentReference professionalRef = FirebaseFirestore.instance
          .collection('professionals')
          .doc(uid);
      batch.set(professionalRef, professionalData, SetOptions(merge: true));

      // Add availability document
      DocumentReference availabilityRef = FirebaseFirestore.instance
          .collection('professionals')
          .doc(uid)
          .collection('availability')
          .doc(code);
      batch.set(availabilityRef, availabilityMap);

      // Also add to a separate availability collection for easy querying
      DocumentReference globalAvailabilityRef = FirebaseFirestore.instance
          .collection('availability')
          .doc(code);
      batch.set(globalAvailabilityRef, availabilityMap);

      await batch.commit();

      print("Data uploaded successfully!");
      showSuccessDialog(context, true);
    } catch (e) {
      print("Error uploading data: $e");
      showSuccessDialog(context, false);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Dental Professional",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Row(
                    children: [
                    Container(
                    width: 300.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFC7A777),
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(5.r)),
                    ),
                    )
                    ],
                  ),
                ),
                SizedBox(height: 30.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Enter preferred hourly wage below"),
                      GestureDetector(
                        onTap: _showWageTypeDialog,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedExperiences,
                                style: TextStyle(color: Colors.black, fontSize: 14.sp),
                              ),
                              Icon(Icons.arrow_drop_down, color: Colors.black),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      _buildLabel("Amount (\$)"),
                      PrimaryFieldSignUp(
                        textEditingController: wageController,
                        hintText: 'Enter hourly wage',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),

                Padding(
                  padding: EdgeInsets.only(left: 8.w, right: 10.w, bottom: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        label: Text("Previous",
                            style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFC7A777),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                        ),
                        onPressed: _validateAndSubmit,
                        child: Text("Next",
                            style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC7A777)),
              ),
            ),
        ],
      ),
    );
  }

  void _validateAndSubmit() {
    double? wage = double.tryParse(wageController.text);
    if (wage == null || wage <= 0) {
      Get.snackbar(
        "Invalid Input",
        "Please enter a valid hourly wage greater than 0.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedExperiences.isEmpty) {
      Get.snackbar(
        "Select Wage Type",
        "Please select a wage type.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    availabilityController.updateHourlyWage(wage);
    availabilityController.updateUid(uid);
    availabilityController.updatePreferredHourlyWage(selectedExperiences);
    controller.updateProfessional(uid: uid);
    uploadProfessionalAndAvailability(uid);
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
    );
  }

  void showSuccessDialog(BuildContext context, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        if (isSuccess) {
          Future.delayed(Duration(seconds: 2), () {
            Get.offAllNamed(AppRoutes.bottomNavProfessional);
          });
        }

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20.r),
            ),
            height: 400.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isSuccess
                      ? "Your Posting is now live!"
                      : "Upload Failed",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Center(
                  child: SvgPicture.asset(
                    Images.checkMark ,
                    width: 90.w,
                    height: 200.h,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  isSuccess
                      ? "Thank you. Your availability has now been saved\nand posted for all dental offices to see.\n${DateTime.now().toString().substring(0, 10)}"
                      : "Failed to save your data. Please try again.",
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
                if (!isSuccess)
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        uploadProfessionalAndAvailability(uid);
                      },
                      child: Text("Retry"),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showWageTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text("Select Wage Type", style: TextStyle(color: Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: experienceOptions.map((experience) {
              return RadioListTile<String>(
                title: Text(experience, style: TextStyle(color: Colors.black)),
                value: experience,
                groupValue: selectedExperiences,
                activeColor: Color(0xFFC7A777),
                onChanged: (String? value) {
                  setState(() {
                    selectedExperiences = value!;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}