import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import '../../../Constants/colors.dart';

class ProfessionalDentalsDetail extends StatelessWidget {
  const ProfessionalDentalsDetail({Key? key}) : super(key: key);

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';

    try {
      if (date is Timestamp) {
        return DateFormat('EEE, MMM d, yyyy').format(date.toDate());
      } else if (date is DateTime) {
        return DateFormat('EEE, MMM d, yyyy').format(date);
      } else if (date is String) {
        final parsed = DateTime.tryParse(date);
        return parsed != null ? DateFormat('EEE, MMM d, yyyy').format(parsed) : date;
      }
      return date.toString();
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatTime(dynamic time) {
    if (time == null || time.toString().isEmpty) return 'N/A';

    try {
      if (time is Timestamp) {
        return DateFormat('hh:mm a').format(time.toDate());
      } else if (time is DateTime) {
        return DateFormat('hh:mm a').format(time);
      } else if (time is String) {
        // Try parsing as full datetime first
        DateTime? parsed = DateTime.tryParse(time);
        if (parsed != null) {
          return DateFormat('hh:mm a').format(parsed);
        }

        // Try parsing as time only (HH:mm)
        final timeParts = time.split(':');
        if (timeParts.length >= 2) {
          final now = DateTime.now();
          parsed = DateTime(now.year, now.month, now.day,
              int.parse(timeParts[0]), int.parse(timeParts[1]));
          return DateFormat('hh:mm a').format(parsed);
        }

        return time;
      }
      return time.toString();
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final String userId = args['userId'] ?? '';
    final String docId = args['docId'] ?? '';

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('offices')
            .doc(userId)
            .collection('postingDetails')
            .doc(docId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Job not found"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          // Format dates and times
          final String formattedCreatedAt = _formatDate(data['createdAt'] ?? args['createdAt']);
          final String formattedDay = _formatDate(args['day']);
          final String formattedStartTime = _formatTime(args['startTime']);
          final String formattedEndTime = _formatTime(args['endTime']);

          // Passed arguments
          final String jobTitle = args['jobTitle'] ?? 'Job Title';
          final String workplace = args['workplace'] ?? 'Workplace';
          final String location = args['location'] ?? 'Location';
          final String payRate = args['payRate'] ?? '0';
          final String imageUrl = args['imageUrl'] ?? '';
          final String description = args['description'] ?? '';
          final String details = args['detail'] ?? '';
          final String status = args['status'] ?? '';
          final String currentUserID = FirebaseAuth.instance.currentUser?.uid ?? '';

          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSection(imageUrl),
                  _buildContentSection(
                    jobTitle,
                    workplace,
                    location,
                    payRate,
                    details,
                    description,
                    userId,
                    docId,
                    currentUserID,
                    formattedDay,
                    formattedStartTime,
                    formattedEndTime,
                    status,
                    formattedCreatedAt,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection(String imageUrl) {
    return Center(
      child: Container(
        height: 280.h,
        width: 350.w,
        margin: EdgeInsets.only(top: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          image: DecorationImage(
            image:
                 AssetImage(Images.onboarding1Img) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection(
      String jobTitle,
      String workplace,
      String location,
      String payRate,
      String detail,
      String description,
      String userId,
      String docId,
      String currentUserId,
      String day,
      String startTime,
      String endTime,
      String status,
      String createdAt,
      ) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colorss.silkColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildJobDetails(
            jobTitle,
            workplace,
            location,
            payRate,
            detail,
            description,
            day,
            startTime,
            endTime,
            createdAt,
          ),
          SizedBox(height: 90.h),
          _buildInterestedButton(userId, docId, currentUserId, status),
        ],
      ),
    );
  }

  Widget _buildJobDetails(
      String jobTitle,
      String workplace,
      String location,
      String payRate,
      String detail,
      String description,
      String day,
      String startTime,
      String endTime,
      String createdAt,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          jobTitle,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        Text(workplace, style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
        SizedBox(height: 10.h),
        _buildInfoRow(Icons.location_on, location, 'Rate: $payRate / Day', ),
        SizedBox(height: 10.h),
        _buildInfoRow(Icons.calendar_today, 'Date:', createdAt),


        SizedBox(height: 16.h),
        _buildSectionHeader('Job Detail'),
        SizedBox(height: 8.h),
        Text(detail, style: TextStyle(fontSize: 12.sp)),
        SizedBox(height: 16.h),
        _buildSectionHeader('Key Responsibility'),
        SizedBox(height: 8.h),
        Text(description, style: TextStyle(fontSize: 13.sp)),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {},
          child: Text(
            'Read More',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colorss.appcolor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
      IconData icon,
      String text,
      String createdAt,

      ) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 16.sp),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Text(
          "$createdAt",
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInterestedButton(
      String uid,
      String docId,
      String currentUserId,
      String? status,
      ) {
    if (status == 'Accepted') {
      return _statusButton('Accepted', Colors.green);
    } else if (status == 'Rejected') {
      return _statusButton('Rejected', Colors.red);
    } else {
      return Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 10.h),
          ),
          onPressed: () async {
            try {
              final docRef = FirebaseFirestore.instance
                  .collection('offices')
                  .doc(uid)
                  .collection('postingDetails')
                  .doc(docId);

              final docSnapshot = await docRef.get();
              final interestedList =
              List<String>.from(docSnapshot.data()?['interested'] ?? []);

              if (interestedList.contains(currentUserId)) {
                Get.snackbar(
                  'Notice',
                  'You already marked as interested.',
                  backgroundColor: Colorss.lightAppColor,
                  colorText: Colors.black,
                );
                return;
              }

              await docRef.update({
                'interested': FieldValue.arrayUnion([currentUserId]),
              });

              Get.toNamed(AppRoutes.successScreenProfessional);
            } catch (e) {
              Get.snackbar('Error', 'Could not mark as interested.');
            }
          },
          child: Text(
            'Interested',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  Widget _statusButton(String label, Color color) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}