import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Widgets/custom_text_widget.dart';
import 'package:temp_haus_dental_clinic/Widgets/customtextfeild.dart';
import 'package:uuid/uuid.dart';

import '../../Models/professional_user_model.dart';

class EditProfileProfessionalScreen extends StatefulWidget {
  const EditProfileProfessionalScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileProfessionalScreen> createState() =>
      _EditProfileProfessionalScreenState();
}

class _EditProfileProfessionalScreenState
    extends State<EditProfileProfessionalScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Professional? professional;
  bool isLoading = true;
  bool isSaving = false;
  String? uploadedImageUrl;
  bool isUploading = false;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final graduatingYearController = TextEditingController();
  final bioController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final doc = await _firestore.collection('professionals').doc(uid).get();

        if (doc.exists) {
          professional = Professional.fromJson(doc.data()!);

          firstNameController.text = professional?.firstName ?? '';
          lastNameController.text = professional?.lastName ?? '';
          emailController.text = professional?.email ?? '';
          passwordController.text = professional?.password ?? '';
          phoneController.text = professional?.phoneNumber ?? '';
          graduatingYearController.text =
              professional?.graduatingYear?.toString() ?? '';
          bioController.text = professional?.bio ?? '';
          addressController.text = professional?.address ?? '';
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> uploadImageToFirebase(String imageType) async {
    if (imageType != 'officeProfile' && imageType != 'professional') {
      print('Invalid image type.');
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

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

      setState(() {
        uploadedImageUrl = downloadURL;
        professional?.imageUrl = downloadURL; // <-- update your local object
        isUploading = false;
      });

      // Now update directly in Firestore after successful upload
      await _firestore.collection('professionals').doc(uid).update({
        'imageUrl': downloadURL,
      });

      print('Image uploaded and profile updated successfully.');
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      print('Error uploading image: $e');
    }
  }

  Future<void> updateProfile() async {
    setState(() {
      isSaving = true;
    });

    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        await _firestore.collection('professionals').doc(uid).update({
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'emailPayment': emailController.text.trim(),
          'phoneNumber': phoneController.text.trim(),
          'graduatingYear':
              int.tryParse(graduatingYearController.text.trim()) ?? 0,
          'bio': bioController.text.trim(),
          'address': addressController.text.trim(),
          'imageUrl': professional?.imageUrl,
        });
        Get.snackbar("", 'Profile updated successfully!',
            backgroundColor: Colorss.lightAppColor, colorText: Colors.black);
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar("Failed to update profile:", '$e',
          backgroundColor: Colorss.lightAppColor, colorText: Colors.black);
    }

    setState(() {
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorss.whiteColor,
      appBar: AppBar(
        backgroundColor: Colorss.appcolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colorss.whiteColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const CustomText(
          text: 'Edit Profile',
          color: Colorss.whiteColor,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(20.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50.r,
                          backgroundImage: professional?.imageUrl != null
                              ? NetworkImage(professional!.imageUrl!)
                                  as ImageProvider
                              : AssetImage(Images.onboarding1Img),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              await uploadImageToFirebase('professional');
                            },
                            child: CircleAvatar(
                              radius: 15.r,
                              backgroundColor: Colorss.appcolor,
                              child: Icon(Icons.camera_alt,
                                  color: Colors.white, size: 15.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                        hint: 'First Name',
                        icon: Icons.person,
                        controller: firstNameController),
                    CustomTextField(
                        hint: 'Last Name',
                        icon: Icons.person,
                        controller: lastNameController),
                    CustomTextField(
                        hint: 'Email',
                        icon: Icons.email,
                        controller: emailController),
                    CustomTextField(
                        hint: 'Phone Number',
                        icon: Icons.phone_in_talk,
                        controller: phoneController),
                    CustomTextField(
                        hint: 'Graduating Year',
                        icon: Icons.school,
                        controller: graduatingYearController),
                    CustomTextField(
                        hint: 'Bio',
                        icon: Icons.description,
                        controller: bioController),
                    CustomTextField(
                        hint: 'Address',
                        icon: Icons.location_on,
                        controller: addressController),
                    SizedBox(height: 20.h),
                    Center(
                      child: SizedBox(
                        height: 45,
                        width: 200,
                        child: ElevatedButton(
                          onPressed: isSaving ? null : updateProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colorss.appcolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isSaving
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const CustomText(
                                  text: 'Save',
                                  color: Colorss.whiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
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
