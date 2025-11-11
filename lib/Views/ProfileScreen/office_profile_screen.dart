import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';

import '../../Constants/colors.dart';

class OfficeProfileScreen extends StatefulWidget {
  @override
  State<OfficeProfileScreen> createState() => _OfficeProfileScreenState();
}

class _OfficeProfileScreenState extends State<OfficeProfileScreen> {
  Future<void> logoutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      Get.offAllNamed('/login'); // replace with your login route
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  Future<void> deleteUserAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.delete();

        // Navigate to login or welcome screen after deletion
        Get.offAllNamed('/login'); // or your route
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please log in again to delete your account.'),
          ),
        );

        // Optionally, redirect to login screen for re-authentication
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: ${e.message}'),
          ),
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
        title: Text("Profile",
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold)),
        centerTitle: true,

      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          CircleAvatar(
            radius: 80.r,
            backgroundImage: AssetImage(
                Images.onboarding1Img), // Replace with actual image path
          ),
          SizedBox(height: 10),
          Text(
            "Dental Office",
            style: TextStyle(
                color: Colors.white,
                fontSize: 21.sp,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "General, Ortho & Whitening",
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ProfileOption(
                  icon: FontAwesomeIcons.user,
                  title: "Edit Profile",
                  onTap: () {
                    Get.toNamed(AppRoutes.editOfficeProfile);
                  },
                ),
                ProfileOption(
                  icon: FontAwesomeIcons.signsPost,
                  title: "All Post",
                  onTap: () {
                    Get.toNamed(AppRoutes.officePostScreen);
                  },
                ),


                ProfileOption(
                  icon: Icons.privacy_tip,
                  title: "Privacy Policy",
                  onTap: () {
                    Get.toNamed(AppRoutes.privacyPolicy);
                  },
                ),
                // ProfileOption(
                //   icon: FontAwesomeIcons.questionCircle,
                //   title: "About Us",
                //   onTap: () {
                //     Get.toNamed(AppRoutes.aboutUs);
                //   },
                // ),
                ProfileOption(
                  icon: FontAwesomeIcons.receipt,
                  title: "Transaction",
                  onTap: () {
                    Get.toNamed(AppRoutes.transactionofficescreen);
                  },
                ),
                ProfileOption(
                  icon: FontAwesomeIcons.signOutAlt,
                  title: "Logout",
                  onTap: () {
                    Get.defaultDialog(
                      title: "Confirm Logout",
                      titleStyle: TextStyle(
                          color: Colorss.appcolor, fontWeight: FontWeight.bold),
                      middleText: "Are you sure you want to logout?",
                      middleTextStyle: TextStyle(color: Colors.black87),
                      textCancel: "No",
                      textConfirm: "Yes",
                      cancelTextColor: Colors.white,
                      confirmTextColor: Colors.white,
                      buttonColor: Colorss.appcolor,
                      // Will be used if `confirm` is not custom
                      radius: 10,
                      onCancel: () {},
                      onConfirm: () {
                        // Logout logic
                        logoutUser(context); // Adjust based on your route
                      },
                      confirm: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colorss.appcolor,
                        ),
                        onPressed: () {
                          logoutUser(context);
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),

                      cancel: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade400,
                        ),
                        onPressed: () {
                          Get.back(); // Close dialog
                        },
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text("Delete Account",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                  onTap: () {
                    deleteUserAccount(context);
                  },
                ),
              ],
            ),
          ),
        ],
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
