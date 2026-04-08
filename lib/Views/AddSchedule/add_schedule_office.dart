import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Models/office_schedule_model.dart';
import 'package:temp_haus_dental_clinic/Widgets/8_didgit_code.dart';

class OfficeAddScheduleScreen extends StatefulWidget {
  @override
  _OfficeAddScheduleScreenState createState() =>
      _OfficeAddScheduleScreenState();
}

class _OfficeAddScheduleScreenState extends State<OfficeAddScheduleScreen> {
  final TextEditingController _titleController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String code = generate8DigitCode();

  // 🔥 SAFE UID (NO NULL CRASH)
  String get uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return "guest_office"; // store schedule for guest/no-login user
    }
    return user.uid;
  }

  // ---------------- UPLOAD SCHEDULE ----------------
  Future<void> uploadScheduleToList({
    required String userId,
    required OfficeScheduleModel schedule,
    required BuildContext context,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('offices')
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
        margin: EdgeInsets.all(16),
      );

      Navigator.pop(context, true);
    } catch (e) {
      Get.snackbar("Error", '$e',
          backgroundColor: Colorss.lightAppColor, colorText: Colors.black);
    }
  }

  // ---------------- PICK DATE ----------------
  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  // ---------------- PICK TIME ----------------
  void _pickTime() async {
    TimeOfDay? pickedTime =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (pickedTime != null) {
      setState(() => _selectedTime = pickedTime);
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
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Schedule Title",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 5),
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: "Enter title",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 15.h),

            // ------------ DATE PICKER ------------
            Text("Select Date",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 5),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? "Select a Date"
                          : _selectedDate.toString().split(" ").first,
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(Icons.calendar_today, color: Colors.black),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),

            // ------------ TIME PICKER ------------
            Text("Time",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 5),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTime != null
                          ? _selectedTime!.format(context)
                          : "Select Time",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Icon(Icons.access_time, color: Colors.black),
                  ],
                ),
              ),
            ),

            SizedBox(height: 25.h),

            // ------------ SAVE BUTTON ------------
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
                    Get.snackbar("Error", 'Please fill all fields',
                        backgroundColor: Colorss.lightAppColor,
                        colorText: Colors.black);
                    return;
                  }

                  final schedule = OfficeScheduleModel(
                    title: _titleController.text.trim(),
                    date: _selectedDate!,
                    time: _selectedTime!.format(context),
                  );

                  await uploadScheduleToList(
                    userId: uid, // <-- SAFE UID
                    schedule: schedule,
                    context: context,
                  );

                  _titleController.clear();
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
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
