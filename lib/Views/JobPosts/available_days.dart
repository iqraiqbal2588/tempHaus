import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Controllers/office_controller.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Views/JobPosts/Widget/next_button.dart';
import 'package:temp_haus_dental_clinic/Widgets/custom_text_widget.dart';

class AvailableDaysScreen extends StatefulWidget {
  @override
  _AvailableDaysScreenState createState() => _AvailableDaysScreenState();
}

class _AvailableDaysScreenState extends State<AvailableDaysScreen> {
  DateTime _selectedDay = DateTime.now();
  final OfficeController officeController = Get.find<OfficeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Post available days for temping",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width *
                  1, // Adjust the width as needed
              height: 8.h, // Adjust the height for thickness
              decoration: BoxDecoration(
                color: Colors.black, // Black background
                borderRadius: BorderRadius.circular(0),
              ),
              child: Row(
                children: [
                  Container(
                    width: 120.w, // Adjust for the progress percentage
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFC7A777), // Beige/Golden progress bar
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(0)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: Colors.white, // White remaining section
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.circular(0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Let's get started",
                    fontWeight: FontWeight.bold,
                    color: Colorss.whiteColor,
                    fontSize: 20.sp,
                  ),
                  SizedBox(height: 5.h),
                  CustomText(
                    text: "What day(s) are you looking for?",
                    fontWeight: FontWeight.w500,
                    color: Colorss.whiteColor,
                    fontSize: 18.sp,
                  ),
                  SizedBox(height: 20.h),
                  CustomText(
                    text: "Please Select Below",
                    fontWeight: FontWeight.w500,
                    color: Colorss.whiteColor,
                    fontSize: 18.sp,
                  ),
                  SizedBox(height: 20.h),
                  _buildCalendar(),
                  SizedBox(height: 80.h),
                  _buildBottomButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(15.w),
      child: TableCalendar(
        focusedDay: _selectedDay,
        firstDay: DateTime(2021, 1, 1),
        lastDay: DateTime(2030, 12, 31),
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle:
              TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.black),
          weekendStyle: TextStyle(color: Colors.black),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: TextStyle(color: Colors.black),
          weekendTextStyle: TextStyle(color: Colors.black),
        ),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
          });

          // Save the selected date to posting details
          officeController.updatePostingDetails(
            availableDays: [
              _selectedDay.toIso8601String()
            ], // store as ISO string
          );
        },
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
          label: Text("Previous",
              style: TextStyle(color: Colors.white, fontSize: 16.sp)),
        ),
        Center(
          child: NextContainer(
            buttonText: 'Next',
            onPressed: () {
              if (_selectedDay != null) {
                Get.toNamed(AppRoutes.timePicker);
              } else {
                Get.snackbar(
                  "day",
                  "Please select at least one available day",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Please select at least one available day."),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
