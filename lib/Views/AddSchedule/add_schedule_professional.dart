import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';

import '../../Models/office_schedule_model.dart';
import '../../Widgets/8_didgit_code.dart';

class AddScheduleScreen extends StatefulWidget {
  @override
  _AddScheduleScreenState createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String code = generate8DigitCode();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> uploadScheduleToList({
    required String userId,
    required OfficeScheduleModel schedule,
    required BuildContext context,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('professionals')
          .doc(userId)
          .collection('ScheduleTimings')
          .doc('20318298')
          .set({
        'schedules': FieldValue.arrayUnion([schedule.toMap()])
      }, SetOptions(merge: true));
      Get.snackbar(
        "",
        "Schedule added successfully.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(16.w),
      );
      Navigator.pop(context, true);
    } catch (e) {
      Get.snackbar("Error:", "$e",
          backgroundColor: Colorss.lightAppColor, colorText: Colors.black);
    }
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Add Scheduling", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Schedule Title",
                style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            SizedBox(height: 5),
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colorss.blackColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colorss.whiteColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                hintText: "Enter title",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 15.h),
            Text("Select Date",
                style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            SizedBox(height: 5.h),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: Colorss.whiteColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedDate == null
                        ? "Select a Date"
                        : _selectedDate.toString()),
                    Icon(Icons.calendar_today, color: Colors.white),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Text("Time",
                style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            SizedBox(height: 5.h),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 16.w),
                decoration: BoxDecoration(
                  color: Colorss.whiteColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTime != null
                          ? _selectedTime!.format(context)
                          : "Select Time",
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    ),
                    Icon(
                      Icons.access_time,
                      color: Colors.black,
                      size: 22.sp,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colorss.appcolor,
                  padding: EdgeInsets.all(16.w),
                ),
                onPressed: () async {
                  if (_titleController.text.isEmpty ||
                      _selectedDate == null ||
                      _selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }
                  final schedule = OfficeScheduleModel(
                    title: _titleController.text.trim(),
                    date: _selectedDate!,
                    time: _selectedTime!.format(context),
                  );
                  await uploadScheduleToList(
                    userId: uid,
                    schedule: schedule,
                    context: context,
                  );
                  _titleController.clear();
                  _descriptionController.clear();
                  setState(() {
                    _selectedDate = null;
                    _selectedTime = null;
                  });
                },
                child: Text(
                  "Add Scheduling",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: Colorss.whiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
