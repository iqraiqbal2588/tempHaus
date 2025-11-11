import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Controllers/office_controller.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Views/officeHomePage/widget/doctor_widget.dart';

import '../../Constants/colors.dart';
import '../../Models/office_user_model.dart';

class OfficeHomeScreen extends StatefulWidget {
  const OfficeHomeScreen({super.key});

  @override
  State<OfficeHomeScreen> createState() => _OfficeHomeScreenState();
}

class _OfficeHomeScreenState extends State<OfficeHomeScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String searchText = '';
  final controller = Get.find<OfficeController>();
  final TextEditingController _searchController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Office? office;
  String name = '';
  @override
  void initState() {
    fetchProfileData();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  Future<void> fetchProfileData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final doc = await _firestore.collection('offices').doc(uid).get();

        if (doc.exists) {
          office = Office.fromJson(doc.data()!);
          setState(() {
            name = office!.officeName ?? '';
          });
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
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
          'Hi, ${name}',
          style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What would you like to search?',
              style: TextStyle(color: Colors.white70, fontSize: 16.sp),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 290.w,
                  height: 56.h,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchText = value.trim().toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Container(
                  height: 47.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.all(10.w),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: SvgPicture.asset(
                      Images.setting, // Replace with your SVG file path
                      width: 23.w, // Adjust size as needed
                      height: 23.h,
                      // Apply color if needed
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(
                  'All Jobs',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0.w),
                  child: SvgPicture.asset(
                    Images.approved, // Replace with your SVG file path
                    width: 23.w, // Adjust size as needed
                    height: 23.h,
                    // Apply color if needed
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collectionGroup('availability')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No job posts available."));
                }
                final allJobs = snapshot.data!.docs;
                final filteredJobs = allJobs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name =
                      (data['officeName'] ?? '').toString().toLowerCase();
                  final profession =
                      (data['profession'] ?? '').toString().toLowerCase();
                  final location =
                      (data['location'] ?? '').toString().toLowerCase();
                  return name.contains(searchText) ||
                      profession.contains(searchText) ||
                      location.contains(searchText);
                }).toList();

                if (filteredJobs.isEmpty) {
                  return const Center(child: Text("No matching jobs found."));
                }

                return ListView.builder(
                  itemCount: filteredJobs.length,
                  itemBuilder: (context, index) {
                    final job =
                        filteredJobs[index].data() as Map<String, dynamic>;
                    return DoctorWidget(
                      imageUrl: 'assets/post_job.svg',
                      name: safeValue(job['name'], 'Dr Unknown'),
                      experience: safeValue(job['experience'], 'N/A'),
                      location: safeValue(job['location'], 'Unknown'),
                      rate: '\$${safeValue(job['hourlyWage'], '0')}',
                      onSendInvitation: () async {
                        String currentUserId =
                            FirebaseAuth.instance.currentUser!.uid;
                        String professionalUid = safeValue(job['uid'], '');
                        String docId = safeValue(job['docId'], '');

                        if (professionalUid.isEmpty || docId.isEmpty) return;

                        final docRef = FirebaseFirestore.instance
                            .collection('professionals')
                            .doc(professionalUid)
                            .collection('availability')
                            .doc(docId);

                        final docSnapshot = await docRef.get();
                        final invitedList = List<String>.from(
                            docSnapshot.data()?['invited'] ?? []);

                        if (invitedList.contains(currentUserId)) {
                          Get.snackbar(
                              'Notice', 'You already marked as interested.',
                              backgroundColor: Colorss.lightAppColor,
                              colorText: Colors.black);
                          return;
                        }

                        await docRef.update({
                          'invited': FieldValue.arrayUnion([currentUserId]),
                        });

                        Get.snackbar('Notice', 'Successfully sent invitation',
                            backgroundColor: Colorss.lightAppColor,
                            colorText: Colors.black);
                      },
                      onSeeInvitation: () {
                        Get.toNamed(
                          AppRoutes.doctorProfile,
                          arguments: {
                            'imageUrl': safeValue(job['image'], ''),
                            'name': safeValue(job['name'], 'Dr Unknown'),
                            'experience': safeValue(job['experience'], 'N/A'),
                            'location': safeValue(job['location'], 'Unknown'),
                            'rate': '\$${safeValue(job['hourlyWage'], '0')}',
                            'about':
                                safeValue(job['about'], 'Nothing added yet'),
                            'profession': safeValue(
                                job['profession'], 'Dental Hygienist'),
                          },
                        );
                      },
                    );
                  },
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  String safeValue(dynamic value, String defaultValue) {
    if (value == null ||
        value.toString().toLowerCase() == 'null' ||
        value.toString().trim().isEmpty) {
      return defaultValue;
    }
    return value.toString();
  }
}
