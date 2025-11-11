import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';

import '../../Models/office_schedule_model.dart';

class OfficeCalendarScheduleScreen extends StatefulWidget {
  @override
  _OfficeCalendarScheduleScreenState createState() =>
      _OfficeCalendarScheduleScreenState();
}

class _OfficeCalendarScheduleScreenState
    extends State<OfficeCalendarScheduleScreen> {
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Map<DateTime, List<OfficeScheduleModel>> _events = {};

  // Fetching schedules with real-time updates using snapshots
  void fetchSchedules() {
    FirebaseFirestore.instance
        .collection('offices')
        .doc(uid) // Replace with actual userId
        .collection('ScheduleTimings')
        .doc('20318298')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final List<dynamic> scheduleList = data['schedules'];

        final Map<DateTime, List<OfficeScheduleModel>> loadedEvents = {};

        for (var item in scheduleList) {
          final model =
              OfficeScheduleModel.fromMap(Map<String, dynamic>.from(item));
          final date =
              DateTime(model.date.year, model.date.month, model.date.day);

          if (loadedEvents[date] == null) {
            loadedEvents[date] = [model];
          } else {
            loadedEvents[date]!.add(model);
          }
        }

        setState(() {
          _events = loadedEvents;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSchedules(); // Start listening to schedule changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Calendar",
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0.w),
            child: CircleAvatar(
              radius: 30.r,
              backgroundColor: Colors.brown[200], // Profile icon background
              child: SvgPicture.asset(
                Images.calender, // Replace with your SVG file path
                width: 30.w, // Adjust size as needed
                height: 30.h,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _selectedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                  },
                  eventLoader: (day) {
                    final date = DateTime(day.year, day.month, day.day);
                    return _events[date] ?? [];
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                        color: Colors.orange, shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    markerDecoration: BoxDecoration(
                        color: Colors.blue, shape: BoxShape.circle),
                  ),
                )),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.addScheduleOffice);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFDCC7A3),
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                "Add Scheduling",
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView(
                children: (_events[DateTime(_selectedDay.year,
                            _selectedDay.month, _selectedDay.day)] ??
                        [])
                    .map((event) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                Divider(
                                  height: 1.h,
                                  color: Colors.black,
                                ),
                                Text(
                                  event.time,
                                  style: TextStyle(
                                      fontSize: 17.sp, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
