import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Controllers/office_controller.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';

class PostJobDetailScreen extends StatefulWidget {
  @override
  _PostJobDetailScreenState createState() => _PostJobDetailScreenState();
}

class _PostJobDetailScreenState extends State<PostJobDetailScreen> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final OfficeController officeController =
      Get.put(OfficeController()); // Instantiate the controller

  @override
  void dispose() {
    _jobTitleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Post Job", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Wrap the body in a SingleChildScrollView
        child: Column(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tell us more about what you are looking for.\nEnter the information below.",
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                  SizedBox(height: 25.h),

                  // Job Title
                  _buildLabel("Job Title"),
                  _buildTextField(
                      controller: _jobTitleController,
                      icon: Icons.list,
                      hintText: "Job title"),
                  SizedBox(height: 20.h),

                  // Location
                  _buildLabel("Location"),
                  _buildTextField(
                      controller: _locationController,
                      icon: Icons.location_on,
                      hintText: "City/Address"),
                  SizedBox(height: 20.h),

                  // Description
                  _buildLabel("Description"),
                  _buildDescriptionField(),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  label: Text("Previous",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC7A777), // Gold color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                  ),
                  onPressed: () {
                    // Validation check before moving to next screen
                    if (_jobTitleController.text.isEmpty) {
                      Get.snackbar(
                        "Input Required",
                        "Please enter a job title",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else if (_locationController.text.isEmpty) {
                      Get.snackbar(
                        "Input Required",
                        "Please enter a location",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else if (_descriptionController.text.isEmpty) {
                      Get.snackbar(
                        "Input Required",
                        "Please enter a description",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else {
                      // Call the controller to update posting details before navigating
                      officeController.updatePostingDetails(
                        jobTitle: _jobTitleController.text,
                        location: _locationController.text,
                        description: _descriptionController.text,
                      );
                      Get.toNamed(AppRoutes.postJobDetailBasic);
                    }
                  },
                  child: Text("Next",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextField(
        controller: controller,
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
      child: TextField(
        controller: _descriptionController,
        maxLines: 8,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Type description...",
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
