import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';

class DoctorWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String experience;
  final String location;
  final String rate;
  final VoidCallback onSendInvitation;
  final VoidCallback onSeeInvitation;

  const DoctorWidget({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.experience,
    required this.location,
    required this.rate,
    required this.onSendInvitation,
    required this.onSeeInvitation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      width: 100.w,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.w)),
        elevation: 4,
        child: Padding(
          padding:
              EdgeInsets.only(left: 7.0.w, top: 10, right: 6.w, bottom: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: SvgPicture.asset(
                      imageUrl,
                      width: 103.w,
                      height: 108.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Work Experience : $experience',
                        style:
                            TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
                      ),
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Location : $location',
                        style:
                            TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Rate : $rate',
                        style: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onSendInvitation,
                    child: SizedBox(
                      width: 150.w,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Send Invitation",
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            decoration: BoxDecoration(
                              color: Colorss.lightAppColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(4.w),
                            child: Padding(
                              padding: EdgeInsets.all(4.0.w),
                              child: SvgPicture.asset(
                                Images.forward,
                                width: 21.w,
                                height: 21.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  GestureDetector(
                    onTap: onSeeInvitation,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("See Invitation"),
                        SizedBox(width: 10.w),
                        Container(
                          decoration: BoxDecoration(
                            color: Colorss.lightAppColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(6.w),
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: SvgPicture.asset(
                              Images.eye,
                              width: 21.w,
                              height: 21.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
