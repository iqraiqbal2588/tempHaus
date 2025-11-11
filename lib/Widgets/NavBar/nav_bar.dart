import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';

import '../../Constants/images.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        bottomAppBarTheme: BottomAppBarTheme(
          padding: EdgeInsets.zero, // Remove default padding
        ),
      ),
      child: BottomAppBar(
      
        child: Container(
          // height: 40.h,
          width: MediaQuery.of(context).size.width,
          color: Colorss.appcolor,
          child: Row(
            children: [
              navItem(
                Images.home,
                pageIndex == 0,
                onTap: () => onTap(0),
              ),
              navItem(
                Images.bell,
                pageIndex == 1,
                onTap: () => onTap(1),
              ),
               SizedBox(width: 80.w),
              navItem(
                Images.calender,
                pageIndex == 2,
                onTap: () => onTap(2),
              ),
              navItem(
                Images.profile,
                pageIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem(String icon, bool selected, {Function()? onTap}) {
    return Expanded(
      child: InkWell(
          onTap: onTap,
          child: SvgPicture.asset(
            icon, // Replace with your SVG file path
            width: 30.w, // Adjust size as needed
            height: 30.h,
            // Apply color if needed
          )),
    );
  }
}
