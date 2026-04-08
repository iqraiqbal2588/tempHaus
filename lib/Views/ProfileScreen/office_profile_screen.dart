import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Models/office_user_model.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';

class OfficeProfileScreen extends StatefulWidget {
  const OfficeProfileScreen({Key? key}) : super(key: key);

  @override
  State<OfficeProfileScreen> createState() => _OfficeProfileScreenState();
}

class _OfficeProfileScreenState extends State<OfficeProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Office? office;
  bool isLoading = true;

  String get uid => _auth.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchOfficeProfile();
  }

  // ================= FETCH OFFICE =================
  Future<void> fetchOfficeProfile() async {
    try {
      final doc = await _firestore.collection('offices').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        setState(() {
          office = Office.fromJson(doc.data()!);
        });
      }
    } catch (e) {
      debugPrint('Fetch office error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ================= LOGOUT =================
  Future<void> logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(AppRoutes.login);
  }

  // ================= DELETE ACCOUNT =================
  Future<void> deleteUserAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.delete();
      Get.offAllNamed(AppRoutes.login);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please login again to delete account')),
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
          style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.white),
      )
          : Column(
        children: [
          SizedBox(height: 20.h),

          // ================= HEADER =================
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 80.r,
                backgroundColor: Colors.grey.shade800,
                child: ClipOval(
                  child: SizedBox(
                    width: 160.r,
                    height: 160.r,
                    child: office != null &&
                        office!.image != null &&
                        office!.image!.isNotEmpty
                        ? Image.network(
                      office!.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          Images.onboarding1Img,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                        : Image.asset(
                      Images.onboarding1Img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Camera icon for future edit
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colorss.appcolor,
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          Text(
            office?.officeName?.isNotEmpty == true
                ? office!.officeName!
                : 'Office Name',
            style: TextStyle(
                color: Colors.white,
                fontSize: 21.sp,
                fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 4.h),

          Text(
            office?.officeType?.isNotEmpty == true
                ? office!.officeType!
                : 'Office Type',
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),

          SizedBox(height: 20.h),

          // ================= OPTIONS =================
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
                      middleText: "Are you sure you want to logout?",
                      textConfirm: "Yes",
                      textCancel: "No",
                      confirmTextColor: Colors.white,
                      cancelTextColor: Colors.black,
                      buttonColor: Colorss.appcolor,
                      onConfirm: () => logoutUser(context),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    "Delete Account",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onTap: () => deleteUserAccount(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= PROFILE OPTION =================
class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileOption({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 20.sp),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 15.sp),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 17.sp),
      onTap: onTap,
    );
  }
}
