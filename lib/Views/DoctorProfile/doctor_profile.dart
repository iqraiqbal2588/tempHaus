import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';

class DoctorProfileScreen extends StatefulWidget {
  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    final String imageUrl = args['imageUrl'] ?? '';
    final String name = args['name'] ?? 'Dr Unknown';
    final String experience = args['experience'] ?? 'N/A';
    final String location = args['location'] ?? 'Unknown';
    final String rate = args['rate'] ?? '\$0';
    final String about =
        args['about'] ?? "This professional has not added a description yet.";
    final String profession = args['profession'];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colorss.appcolor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 3.5),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colorss.lightAppColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.r)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.h, left: 16.w, right: 16.w, bottom: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colorss.appcolor,
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 18.sp),
                                Text(
                                  " 4.2",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              "Dental Professional: $profession",
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Text(
                                  "$experience of Experience",
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Colors.black87),
                                ),
                                Spacer(),
                                Text(
                                  "Rate: $rate",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        height: 50.h,
                        width: 185.w,
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(0.r),
                        ),
                        child: Center(
                          child: Text(
                            "About",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.h, left: 16.w, right: 16.w, bottom: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isExpanded
                                  ? "$about\n\nThis specialist is highly recommended.\nAvailable for consultations weekly."
                                  : "${about.substring(0, about.length > 120 ? 120 : about.length)}...\n\nHighly recommended!",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                child: Text(
                                  isExpanded ? "Read Less" : "Read More",
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Colorss.appcolor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -250.h,
                  left: 16.w,
                  right: 16.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      width: double.infinity,
                      height: 270.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5.r,
                              spreadRadius: 2.r),
                        ],
                      ),
                      child: imageUrl.startsWith('http')
                          ? Image.network(imageUrl, fit: BoxFit.cover)
                          : Image.asset(imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
