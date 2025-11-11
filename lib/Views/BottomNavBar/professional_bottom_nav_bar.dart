import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Views/DashboardProfessional/dash_board_screen.dart';
import 'package:temp_haus_dental_clinic/Views/NotificationScreen/professional_notification_screen.dart';
import 'package:temp_haus_dental_clinic/Views/ProfileScreen/professional_profile_screen.dart';
import 'package:temp_haus_dental_clinic/Views/ScheduleScreen/professional_schedule_screen.dart';
import 'package:temp_haus_dental_clinic/Widgets/NavBar/nav_bar.dart';

import '../../Routes/approutes.dart';

class MainPageProfessional extends StatefulWidget {
  const MainPageProfessional({super.key});

  @override
  State<MainPageProfessional> createState() => _MainPageProfessionalState();
}

class _MainPageProfessionalState extends State<MainPageProfessional> {
  final List<GlobalKey<NavigatorState>> _navKeys =
      List.generate(4, (index) => GlobalKey<NavigatorState>());
  int _selectedTab = 0;

  final List<Widget> _pages = [
    ProfessionalHomeScreen(),
    ProfessionalNotificationsScreen(),
    ProfessionalCalendarScheduleScreen(),
    ProfessionalProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_navKeys[_selectedTab].currentState?.canPop() ?? false) {
          _navKeys[_selectedTab].currentState?.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colorss.blackColor,
        body: IndexedStack(
          index: _selectedTab,
          children: List.generate(
              _pages.length,
              (index) => Navigator(
                    key: _navKeys[index],
                    onGenerateInitialRoutes: (navigator, initialRoute) {
                      return [
                        MaterialPageRoute(builder: (context) => _pages[index])
                      ];
                    },
                  )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 0,
          onPressed: () {
            Get.toNamed(AppRoutes.professionalsAvailable);
          },
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 6, color: Colorss.appcolor),
            borderRadius: BorderRadius.circular(120),
          ),
          child: Icon(Icons.add, color: Colorss.appcolor, size: 45.sp),
        ),
        bottomNavigationBar: SizedBox(
          height: 90.h,
          child: NavBar(
            pageIndex: _selectedTab,
            onTap: (index) {
              if (index == _selectedTab) {
                _navKeys[index]
                    .currentState
                    ?.popUntil((route) => route.isFirst);
              } else {
                setState(() {
                  _selectedTab = index;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
