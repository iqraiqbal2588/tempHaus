import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';

import '../../Constants/colors.dart';

class ProfessionalProfileScreen extends StatelessWidget {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/login');
  }

  Future<void> deleteUserAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        Get.offAllNamed('/login');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in again to delete your account.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('professionals')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic> data = {};
          if (snapshot.hasData && snapshot.data!.exists) {
            data = (snapshot.data!.data() as Map<String, dynamic>?) ?? {};
          }

          final imageUrl = data['imageUrl'] ?? '';
          final firstName = data['firstName'] ?? '';
          final lastName = data['lastName'] ?? '';
          final bio = data['bio'] ?? '';

          final hasProfileInfo =
              imageUrl.toString().isNotEmpty ||
                  firstName.toString().isNotEmpty ||
                  lastName.toString().isNotEmpty ||
                  bio.toString().isNotEmpty;

          return Column(
            children: [
              if (hasProfileInfo) ...[
                SizedBox(height: 15.h),

                CircleAvatar(
                  radius: 80.r,
                  backgroundImage: imageUrl.toString().isNotEmpty
                      ? NetworkImage(imageUrl)
                      : AssetImage(Images.onboarding1Img),
                ),

                SizedBox(height: 12.h),

                Text(
                  "$firstName $lastName",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Text(
                    bio.isNotEmpty ? bio : 'No bio added yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                ),

                SizedBox(height: 20.h),
              ],

              /// MENU ALWAYS SHOWS
              Expanded(
                child: ListView(
                  children: [
                    ProfileOption(
                      icon: FontAwesomeIcons.user,
                      title: "Edit Profile",
                      onTap: () => Get.toNamed(AppRoutes.editProfessionalProfile),
                    ),
                    ProfileOption(
                      icon: FontAwesomeIcons.questionCircle,
                      title: "Privacy Policy",
                      onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
                    ),
                    ProfileOption(
                      icon: FontAwesomeIcons.questionCircle,
                      title: "About Us",
                      onTap: () => Get.toNamed(AppRoutes.aboutUs),
                    ),
                    ProfileOption(
                      icon: FontAwesomeIcons.receipt,
                      title: "Transaction",
                      onTap: () => Get.toNamed(AppRoutes.transactionScreen),
                    ),
                    ProfileOption(
                      icon: FontAwesomeIcons.signOutAlt,
                      title: "Logout",
                      onTap: () => logoutUser(context),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: const Text(
                        "Delete Account",
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      onTap: () => deleteUserAccount(context),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap; // Added onTap callback

  const ProfileOption({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap, // Make it required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 20.sp),
      title:
          Text(title, style: TextStyle(color: Colors.white, fontSize: 15.sp)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 17.sp),
      onTap: onTap, // Call the function when tapped
    );
  }
}
