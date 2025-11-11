import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Controllers/office_controller.dart'; // Import the OfficeController
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Widgets/8_didgit_code.dart';

import '../../Constants/colors.dart';

class PostJobDetailBasicScreen extends StatelessWidget {
  final OfficeController officeController =
      Get.find(); // Initialize the controller
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final descriptionController = TextEditingController();

  PostJobDetailBasicScreen({super.key});

  Future<void> addOfficeToFirestore(String userId, BuildContext context) async {
    officeController.updateOfficeDetails(uid: userId);
    officeController.updatePostingDetails(
        details: descriptionController.text, uid: userId);

    final office = officeController.getOfficeData();
    String code = generate8DigitCode();
    final officeData = office.toJson();
    final postingData = officeController.getPostingDetails();
    Map<String, dynamic> postingMap = postingData.toJson();
    postingMap['docId'] = code;
    postingMap['officeName'] = office.officeName;
    postingMap['image'] = office.image;

    await FirebaseFirestore.instance
        .collection('offices')
        .doc(userId)
        .set(officeData);

    await FirebaseFirestore.instance
        .collection('offices')
        .doc(userId)
        .collection('postingDetails')
        .doc(code)
        .set(postingMap);
    showSuccessDialog(context);
  }

  void validateAndSubmit(BuildContext context) {
    if (descriptionController.text.isEmpty) {
      // Show an error if the description is empty
      Get.snackbar(
        "Success",
        'Please enter the job description',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.snackbar("Write", "'Please enter the job description'",
          backgroundColor: Colorss.lightAppColor, colorText: Colors.black);
    } else {
      addOfficeToFirestore(userId, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Post Job", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Bar
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
                  width: 375.w, // Adjust progress width
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC7A777), // Gold color
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(5.r)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                _buildLabel("Job Details"),
                _buildDescriptionField(),
              ],
            ),
          ),
          const Spacer(),

          // Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: Text("Previous",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC7A777), // Gold color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                ),
                onPressed: () {
                  validateAndSubmit(context); // Validate before submitting
                },
                child: Text("Next",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextFormField(
        controller: descriptionController,
        maxLines: 8,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Dress code (scrub or uniform colour)",
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        Future.delayed(const Duration(seconds: 4), () {
          Get.offAllNamed(AppRoutes.bottomNav);
        });

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20.r),
            ),
            height: 360.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Your Posting is now live!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Center(
                  child: SvgPicture.asset(
                    Images.checkMark, // Replace with your SVG file path
                    width: 90.w, // Adjust size as needed
                    height: 200.h,
                    // Apply color if needed
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Our dental Professionals will be receiving a notification with this posting",
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
