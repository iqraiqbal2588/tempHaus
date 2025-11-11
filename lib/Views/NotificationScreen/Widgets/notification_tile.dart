import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';

class NotificationCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String time;
  final List<String>? tags;
  final IconData? statusIcon;
  final String? errorMessage;

  const NotificationCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.time,
    this.tags,
    this.statusIcon,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

            Container(
              width: 80.r,
              height: 80.r,
              color: Colors.grey[300], // Background color
              child: SvgPicture.asset(
                Images.jobPost,
                fit: BoxFit.cover,
              ),
            ),

          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                  ),
                ),
                if (errorMessage != null && errorMessage!.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Text(
                    errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (tags != null && tags!.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 4.h,
                    children: tags!.map((tag) {
                      final isNewWage = tag == 'New Wage';
                      return GestureDetector(
                        onTap: () {
                          if (isNewWage) showWageOfferBottomSheet(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: isNewWage
                                ? Colors.amber[100]
                                : Colors.green[100],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: isNewWage
                                  ? Colors.orange
                                  : Colors.green[700],
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (statusIcon != null)
                Icon(
                  statusIcon,
                  color: Colors.green,
                  size: 24.sp,
                ),
              if (time.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  void showWageOfferBottomSheet(BuildContext context) {
    final TextEditingController _wageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: const Color(0xFFF5EAD6),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    backgroundImage: AssetImage(Images.onboarding1Img),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      "Enter a new Wage Offer",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: _wageController,
                decoration: InputDecoration(
                  hintText: "Enter a new offer",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  String offer = _wageController.text.trim();
                  if (offer.isNotEmpty) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('New offer submitted: \$${offer}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // You can add API or logic to handle the submission here
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  "Send New Offer",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
