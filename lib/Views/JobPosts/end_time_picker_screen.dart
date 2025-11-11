import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Controllers/office_controller.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Views/JobPosts/Widget/next_button.dart';

class EndTimePickerScreen extends StatefulWidget {
  @override
  _EndTimePickerScreenState createState() => _EndTimePickerScreenState();
}

class _EndTimePickerScreenState extends State<EndTimePickerScreen> {
  TimeOfDay selectedTime = TimeOfDay(hour: 9, minute: 0);
  final OfficeController officeController = Get.find<OfficeController>();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.black,
              dialHandColor: Colors.white,
              dialTextColor: Colors.white,
              hourMinuteTextColor: Colors.white,
              entryModeIconColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });

      final now = DateTime.now();
      final endDateTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      officeController.updatePostingDetails(endTime: endDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.black, // Black background
                borderRadius: BorderRadius.circular(0),
              ),
              child: Row(
                children: [
                  Container(
                    width: 180.w, // Adjust for the progress percentage
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
            SizedBox(height: 20),
            Text(
              "END TIME",
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectTime(context),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[900],
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedTime.format(context),
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                    Icon(Icons.access_time, color: Colors.white),
                  ],
                ),
              ),
            ),
            Spacer(),
            Row(
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
                      Get.toNamed(AppRoutes.hourlyRate);
                    },
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
