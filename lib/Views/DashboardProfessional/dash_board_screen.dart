import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Models/professional_user_model.dart';
import 'package:temp_haus_dental_clinic/Views/DashboardProfessional/widget/dashboard_widget.dart';
import '../../Controllers/professional_controller.dart';
import 'package:intl/intl.dart'; // For date formatting

class ProfessionalHomeScreen extends StatefulWidget {
  const ProfessionalHomeScreen({super.key});

  @override
  State<ProfessionalHomeScreen> createState() => _ProfessionalHomeScreenState();
}

class _ProfessionalHomeScreenState extends State<ProfessionalHomeScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String searchText = '';
  final controller = Get.find<ProfessionalController>();
  final TextEditingController _searchController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Professional? professional;
  String name = '';

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
          setState(() {
            name = professional!.firstName ?? '';
          });
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Hi, $name',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What would you like to search?',
                style: TextStyle(color: Colors.white70, fontSize: 16.sp)),
            SizedBox(height: 12.h),
            Row(
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
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Container(
                  height: 47.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.all(10.r),
                  child: SvgPicture.asset(Images.setting, width: 22.w, height: 22.h),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Text('All Jobs',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold)),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: SvgPicture.asset(Images.approved, width: 23.w, height: 23.h),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.only(left: 10.w),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("I want to Find a Temping Shift",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                        SizedBox(height: 4.h),
                        Text("Are you looking for a temping shift click here...",
                            style: TextStyle(color: Colors.grey[600], fontSize: 14.sp)),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    height: 100.h,
                    width: 100.w,
                    child: Lottie.asset('assets/Lottie/animations/person.json'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collectionGroup('postingDetails').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (snapshot.hasError)
                    return Center(child: Text('Error: ${snapshot.error}'));
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                    return Center(child: Text('No job postings found.'));

                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final jobTitle = (data['jobTitle'] ?? '').toString().toLowerCase();
                    return jobTitle.contains(searchText);
                  }).toList();

                  if (filteredDocs.isEmpty)
                    return Center(child: Text('No matching job postings.'));

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final data = filteredDocs[index].data() as Map<String, dynamic>;
                      final statusMap = data['statusMap'] as Map<String, dynamic>?;

                      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
                      String statusMessage = "Not responded";
                      if (statusMap != null && statusMap.containsKey(currentUserUid)) {
                        final userStatus = statusMap[currentUserUid];
                        if (userStatus == 'accepted') {
                          statusMessage = "Accepted";
                        } else if (userStatus == 'rejected') {
                          statusMessage = "Rejected";
                        } else {
                          statusMessage = "Requested";
                        }
                      } else if (statusMap != null) {
                        statusMessage = "Requested";
                      }

                      // Updated: Use 'createdAt' instead of 'createdAll'
                      String createdAtFormatted = '';
                      if (data['createdAt'] != null) {
                        try {
                          // Handle both Timestamp and String formats
                          if (data['createdAt'] is Timestamp) {
                            final createdAt = (data['createdAt'] as Timestamp).toDate();
                            createdAtFormatted = DateFormat.yMMMd().format(createdAt);
                          } else if (data['createdAt'] is String) {
                            final parsedDate = DateTime.parse(data['createdAt']);
                            createdAtFormatted = DateFormat.yMMMd().format(parsedDate);
                          }
                        } catch (e) {
                          print('Error formatting date: $e');
                          // Fallback to raw string if parsing fails
                          createdAtFormatted = data['createdAt'].toString();
                        }
                      }

                      return UserListTile(
                      imageUrl: data['image'] ?? 'assets/post_job.svg',
                      jobTitle: data['jobTitle'] ?? 'No title',
                      workplace: data['location'] ?? 'Unknown',
                      payRate: data['amount'] != null ? data['amount'].toString() : '0',
                      location: data['location'] ?? 'Unknown',
                      description: data['description'] ?? '',
                      detail: data['details'] ?? '',
                      userId: data['uid'] ?? '',
                      docId: data['docId'] ?? '',
                      startTime: data['startTime'] ?? '',
                      day: (data['availableDays'] != null &&
                          data['availableDays'] is List &&
                          data['availableDays'].isNotEmpty)
                          ? data['availableDays'][0].toString()
                          : '',
                      endTime: data['endTime'] ?? '',
                      statusMessage: statusMessage,
                      createdAt: data['createdAt'], // Pass the raw value
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
