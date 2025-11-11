import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Controllers/availability_controller.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Views/JobPosts/Widget/next_button.dart';

class StartTimePickerProfessionalsScreen extends StatefulWidget {
  @override
  _StartTimePickerProfessionalsScreenState createState() =>
      _StartTimePickerProfessionalsScreenState();
}

class _StartTimePickerProfessionalsScreenState
    extends State<StartTimePickerProfessionalsScreen> {
  TimeOfDay get selectedTime {
    DateTime startDate =
        availabilityController.availability.value.startTime ?? DateTime.now();
    return TimeOfDay(hour: startDate.hour, minute: startDate.minute);
  }

  final AvailabilityController availabilityController =
      Get.put(AvailabilityController());

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

    if (picked != null) {
      DateTime now = DateTime.now();
      DateTime startTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

      availabilityController.updateStartDate(startTime);

      setState(() {}); // Refresh UI
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
                    width: 140.w, // Adjust for the progress percentage
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
              "START TIME",
              style: TextStyle(color: Colors.white, fontSize: 18),
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
                      DateTime now = DateTime.now();
                      DateTime startTime = DateTime(now.year, now.month,
                          now.day, selectedTime.hour, selectedTime.minute);
                      availabilityController.updateStartDate(startTime);
                      Get.toNamed(AppRoutes.professionalsEndTime);
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
