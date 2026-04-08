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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Office? office;
  bool isLoading = true;
  bool isUploadingImage = false;

  String get uid => _auth.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchOfficeProfile();
  }

  // ================= FETCH DATA =================
  Future<void> fetchOfficeProfile() async {
    try {
      final doc =
      await _firestore.collection('offices').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        office = Office.fromJson(doc.data()!);

        nameController.text = office!.officeName!;
        emailController.text = office!.officeEmail!;
        phoneController.text = office!.phoneNumber!;
        addressController.text = office!.address!;
      }
    } catch (e) {
      debugPrint('Fetch error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }


  // ================= UPDATE PROFILE =================
  Future<void> updateProfile() async {
    try {
      await _firestore.collection('offices').doc(uid).update({
        'officeName': nameController.text.trim(),
        'officeEmail': emailController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'image': office!.image,

      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      debugPrint('Update error: $e');
    }
  }

  // ================= PICK & UPLOAD IMAGE =================
  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final XFile? picked =
    await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    try {
      setState(() => isUploadingImage = true);

      File file = File(picked.path);
      String id = const Uuid().v4();

      Reference ref = FirebaseStorage.instance
          .ref()
          .child('officeProfile/$id.jpg');

      TaskSnapshot snap = await ref.putFile(file);

      String image = await snap.ref.getDownloadURL();

      // 🔥 FIRST: save in Firestore
      await _firestore.collection('offices').doc(uid).update({
        'image': image,
      });

      // 🔥 SECOND: update local model
      setState(() {
        office!.image = image;
        isUploadingImage = false;
      });
    } catch (e) {
      setState(() => isUploadingImage = false);
      debugPrint('Upload error: $e');
    }
  }


  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorss.whiteColor,
      appBar: AppBar(
        backgroundColor: Colorss.appcolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colorss.whiteColor),
          onPressed: () => Navigator.pop(context),
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
          : SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),

            // ================= IMAGE =================
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 55.r,
                  backgroundImage: (office?.image != null && office!.image!.isNotEmpty)
                      ? NetworkImage(office!.image!)
                      : AssetImage(Images.onboarding1Img) as ImageProvider,
                ),
                GestureDetector(
                  onTap: pickAndUploadImage,
                  child: CircleAvatar(
                    radius: 17.r,
                    backgroundColor: Colorss.appcolor,
                    child: isUploadingImage
                        ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Icon(Icons.camera_alt, size: 16.sp, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            // ================= FORM =================
            CustomTextField(
              hint: 'Office Name',
              icon: Icons.business,
              controller: nameController,
            ),
            CustomTextField(
              hint: 'Email',
              icon: Icons.email,
              controller: emailController,
            ),
            CustomTextField(
              hint: 'Phone Number',
              icon: Icons.phone,
              controller: phoneController,
            ),
            CustomTextField(
              hint: 'Address',
              icon: Icons.location_on,
              controller: addressController,
            ),

            SizedBox(height: 30.h),

            // ================= SAVE =================
            SizedBox(
              height: 45,
              width: 200,
              child: ElevatedButton(
                onPressed: updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colorss.appcolor,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),
                child: const CustomText(
                  text: 'Save',
                  color: Colorss.whiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
