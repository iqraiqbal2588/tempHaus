import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';

class UserListTile extends StatelessWidget {
  final String jobTitle;
  final String workplace;
  final String location;
  final String payRate;
  final String imageUrl;
  final String detail;
  final String description;
  final String userId;
  final String docId;
  final String day;
  final String startTime;
  final String endTime;
  final String statusMessage;
  final dynamic createdAt; // can be String or DateTime

  const UserListTile({
    Key? key,
    required this.jobTitle,
    required this.workplace,
    required this.location,
    required this.payRate,
    required this.imageUrl,
    required this.detail,
    required this.description,
    required this.userId,
    required this.docId,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.statusMessage,
    required this.createdAt,
  }) : super(key: key);

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';

    if (date is Timestamp) {
      return DateFormat('MMM d, yyyy').format(date.toDate());
    } else if (date is DateTime) {
      return DateFormat('MMM d, yyyy').format(date);
    } else if (date is String) {
      try {
        final parsed = DateTime.tryParse(date);
        return parsed != null ? DateFormat('MMM d, yyyy').format(parsed) : date;
      } catch (_) {
        return date;
      }
    }
    return date.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.doctorProfileDetail,
          arguments: {
            "jobTitle": jobTitle,
            "workplace": workplace,
            "location": location,
            "payRate": payRate,
            "imageUrl": imageUrl,
            'description': description,
            'detail': detail,
            'userId': userId,
            'docId': docId,
            'startTime': startTime.toString(),
            'endTime': endTime.toString(),
            'day': day,
            'status': statusMessage,
            'createdAt': _formatDate(createdAt),
          },
        );
      },
      child: Card(
        color: Colorss.silkColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 1.w),
        child: Padding(
          padding: EdgeInsets.all(10.0.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: SvgPicture.asset(
                      'assets/post_job.svg',
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _defaultPlaceholder();
                      },
                    )

                  ),
                  SizedBox(height: 20.w),
                  Row(
                    children: [
                      Text(
                        'Interested',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      SvgPicture.asset(
                        Images.forward,
                        width: 20.w,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Job title + bookmark
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            jobTitle,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      //  Icon(Icons.bookmark_border, color: Colors.black),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    Text(
                      workplace,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    Text(
                      'Location: $location',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 4.h),

                    Text(
                      'PayRate: $payRate',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    Text(
                      'Posted on: ${_formatDate(createdAt)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _defaultPlaceholder() {
    return Container(
      width: 100.w,
      height: 100.h,
      color: Colors.white,
      child: Icon(
        Icons.person,
        color: Colors.grey,
        size: 40.sp,
      ),
    );
  }
}
