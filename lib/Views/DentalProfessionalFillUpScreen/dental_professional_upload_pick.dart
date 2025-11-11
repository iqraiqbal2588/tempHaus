import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Widgets/call_back_widget.dart';
import 'package:temp_haus_dental_clinic/Widgets/custom_text_widget.dart';
import 'package:temp_haus_dental_clinic/Widgets/forward_circle_widget.dart';
import 'package:uuid/uuid.dart';

import '../../Controllers/professional_controller.dart';

class DentalProfessionalUpload extends StatefulWidget {
  @override
  _DentalProfessionalUploadState createState() =>
      _DentalProfessionalUploadState();
}

class _DentalProfessionalUploadState extends State<DentalProfessionalUpload> {
  final ProfessionalController controller = Get.find<ProfessionalController>();
  bool isUploading = false;
  String? uploadedImageUrl;

  Future<String?> uploadImageToFirebase(String imageType) async {
    if (imageType != 'officeProfile' && imageType != 'professional') {
      print('Invalid image type.');
      return null;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    File file = File(pickedFile.path);
    String fileName = const Uuid().v4(); // Unique file name

    try {
      setState(() {
        isUploading = true;
      });

      Reference ref =
          FirebaseStorage.instance.ref().child('$imageType/$fileName.jpg');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      String downloadURL = await snapshot.ref.getDownloadURL();
      controller.updateProfessional(imageUrl: downloadURL);

      setState(() {
        uploadedImageUrl = downloadURL;
        isUploading = false;
      });

      return downloadURL;
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      print('Error uploading $imageType image: $e');
      return null;
    }
  }

  Future<void> handleProfessionalUpload() async {
    String? professionalUrl = await uploadImageToFirebase('professional');

    if (professionalUrl != null) {
      print("Professional Profile Uploaded: $professionalUrl");
    }
  }

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
                    text: "Dental Professional",
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
              width: MediaQuery.of(context).size.width * 1, // Full width
              height: 8.h, // Adjust height for thickness
              decoration: BoxDecoration(
                color: Colors.black, // Black background
                borderRadius: BorderRadius.circular(0),
              ),
              child: Row(
                children: [
                  Container(
                    width: 250.w, // Adjust for the progress percentage
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
              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 90.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CustomText(
                      text: "Upload Image (Optional)",
                      fontWeight: FontWeight.bold,
                      color: Colorss.whiteColor,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width *
                          0.9, // Adjust width
                      height: MediaQuery.of(context).size.height *
                          0.3, // Adjust height
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          await handleProfessionalUpload();
                        },
                        child: Center(
                          child: () {
                            // 1) No image yet → placeholder
                            if (uploadedImageUrl == null && !isUploading) {
                              return SvgPicture.asset(
                                Images.dentalDetails,
                                width: 180,
                              );
                            }
                            // 2) Uploading → spinner
                            if (isUploading) {
                              return const CircularProgressIndicator();
                            }
                            // 3) Uploaded → show the image
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                uploadedImageUrl!,
                                width: 240,
                                height: 200,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const CircularProgressIndicator();
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error,
                                      color: Colors.red);
                                },
                              ),
                            );
                          }(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Center(
                    child: Container(
                        height: 100.h,
                        width: 100.w,
                        child: SvgPicture.asset(Images.tooth)
                        // Lottie.asset(
                        //     'assets/Lottie/animations/6793c5a5-0795-4193-92a3-5f3f6dd10316.json'),
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
                    if (uploadedImageUrl == null) {
                      Get.snackbar(
                        "Image Required",
                        "Please upload your image before proceeding.",
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: EdgeInsets.all(10),
                      );
                    } else {
                      Get.toNamed(AppRoutes.professionalsCompleted);
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
