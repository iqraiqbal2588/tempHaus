import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Views/NotificationScreen/Office_notification_screen.dart';
import 'package:temp_haus_dental_clinic/Views/OfficeHomePage/office_home_page.dart';
import 'package:temp_haus_dental_clinic/Views/ProfileScreen/office_profile_screen.dart';
import 'package:temp_haus_dental_clinic/Views/ScheduleScreen/office_schedule_screen.dart';
import 'package:temp_haus_dental_clinic/Widgets/NavBar/nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<GlobalKey<NavigatorState>> _navKeys =
      List.generate(4, (index) => GlobalKey<NavigatorState>());
  int _selectedTab = 0;

  final List<Widget> _pages = [
    OfficeHomeScreen(),
    NotificationsScreen(),
    OfficeCalendarScheduleScreen(),
    OfficeProfileScreen(),
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
            Get.toNamed(AppRoutes.availableTime);
          },
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 6.w, color: Colorss.appcolor),
            borderRadius: BorderRadius.circular(120.r),
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
