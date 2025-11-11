import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Controllers/professional_controller.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Widgets/forward_circle_widget.dart';

class professional_experience extends StatefulWidget {
  @override
  State<professional_experience> createState() =>
      _professional_experienceState();
}

class _professional_experienceState extends State<professional_experience> {
  List<String> experienceOptions = List.generate(50, (index) => '${index + 1}');


  String get selectedExperiences =>
      professionalController.professional.value.workExperience == null
          ? '1'
          : professionalController.professional.value.workExperience!;

  TextEditingController bioController = TextEditingController();
  final ProfessionalController professionalController =
      Get.put(ProfessionalController());

  @override
  Widget build(BuildContext context) {
    bioController.text =
        professionalController.professional.value.bio ?? ""; // Set initial bio

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
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
                  width: 300.w, // Adjust progress width
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFC7A777), // Gold color
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
                // Job Title
                _buildLabel("Work Experience"),
                GestureDetector(
                  onTap: () {
                    _showSingleSelectDialog();
                  },
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
                          selectedExperiences.isEmpty
                              ? "Enter your work experience"
                              : selectedExperiences,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.black),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Description
                _buildLabel("Bio"),
                _buildDescriptionField(),
              ],
            ),
          ),
          Spacer(),

          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: CustomCircleAvatar(
                onPressed: () {
                  // Check for work experience and bio before updating
                  if (selectedExperiences.isEmpty ||
                      bioController.text.isEmpty) {
                    // Show a snackbar or an alert to notify the user
                    Get.snackbar(
                      "Validation Error",
                      "Please fill in all the required fields.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else {
                    // Update the professional info and navigate
                    professionalController.updateProfessional(
                      workExperience: selectedExperiences,
                      bio: bioController.text,
                    );
                    Get.toNamed(AppRoutes.professionalsUploads);
                  }
                },
              ),
            ),
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

  Widget _buildTextField({required IconData icon, required String hintText}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(icon, color: Colors.black),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      height: 150.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextFormField(
        maxLines: 8,
        controller: bioController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Hey Cristina, tell us about yourself!",
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  void _showSingleSelectDialog() {
    String? tempSelected =
        professionalController.professional.value.workExperience;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colorss.appcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return SizedBox(
                width: double.maxFinite, // Let it expand horizontally as needed
                height: 400, // Fixed height so it won't overflow vertically
                child: ListView(
                  children: experienceOptions.map((experience) {
                    return RadioListTile<String>(
                      title: Text(
                        experience,
                        style: const TextStyle(color: Colors.black),
                      ),
                      value: experience,
                      groupValue: tempSelected,
                      activeColor: Colors.black,
                      onChanged: (String? value) {
                        setDialogState(() {
                          tempSelected = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                professionalController.updateProfessional(
                    workExperience: tempSelected);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }


}
