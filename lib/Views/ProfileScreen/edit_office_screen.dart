import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Models/office_user_model.dart';
import 'package:temp_haus_dental_clinic/Widgets/custom_text_widget.dart';
import 'package:temp_haus_dental_clinic/Widgets/customtextfeild.dart';
import 'package:uuid/uuid.dart';

class EditProfileOfficeScreen extends StatefulWidget {
  const EditProfileOfficeScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileOfficeScreen> createState() =>
      _EditProfileOfficeScreenState();
}

class _EditProfileOfficeScreenState extends State<EditProfileOfficeScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String? uploadedImageUrl;
  Office? office;
  bool isUploading = false;
  bool isLoading = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
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

  Future<void> updateOfficeProfile() async {
    final uid = _auth.currentUser?.uid;

    if (uid != null) {
      try {
        await _firestore.collection('offices').doc(uid).update({
          'officeName': firstNameController.text.trim(),
          'officeEmail': emailController.text.trim(),
          'phoneNumber': phoneController.text.trim(),
          'address': addressController.text.trim(),
          'image': office!.image,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
      } catch (e) {
        print("Error updating profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile")),
        );
      }
    }
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
        office?.image = downloadURL; // <-- update your local object
        isUploading = false;
      });
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

  Future<void> fetchProfileData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final doc = await _firestore.collection('offices').doc(uid).get();

        if (doc.exists) {
          office = Office.fromJson(doc.data()!);

          firstNameController.text = office?.officeName ?? '';
          emailController.text = office?.officeEmail ?? '';
          phoneController.text = office?.phoneNumber ?? '';
          addressController.text = office?.address ?? '';
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }

    setState(() {
      isLoading = false;
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
                          backgroundImage: office?.image != null
                              ? NetworkImage(office!.image!) as ImageProvider
                              : AssetImage(Images.onboarding1Img),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {},
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
                        hint: 'Name',
                        icon: Icons.person,
                        controller: firstNameController),
                    CustomTextField(
                        hint: 'Email',
                        icon: Icons.email,
                        controller: emailController),
                    CustomTextField(
                        hint: 'Phone Number',
                        icon: Icons.phone_in_talk,
                        controller: phoneController),
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
                          onPressed: () {
                            updateOfficeProfile();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colorss.appcolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const CustomText(
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
