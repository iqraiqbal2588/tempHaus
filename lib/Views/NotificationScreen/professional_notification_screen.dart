import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Views/NotificationScreen/Widgets/notification_tile.dart';

import 'Widgets/OfficeInviteYou/office_invite_you.dart';

class ProfessionalNotificationsScreen extends StatefulWidget {
  const ProfessionalNotificationsScreen({super.key});

  @override
  State<ProfessionalNotificationsScreen> createState() =>
      _ProfessionalNotificationsScreenState();
}

class _ProfessionalNotificationsScreenState
    extends State<ProfessionalNotificationsScreen> {
  List<Map<String, dynamic>> officeNotifications = [];
  bool isLoading = true;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  StreamSubscription? listener;

  @override
  void initState() {
    super.initState();
    startListeningToAvailability();
  }

  DateTime? parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  void startListeningToAvailability() {
    listener = FirebaseFirestore.instance
        .collection('professionals')
        .doc(uid)
        .collection('availability')
        .snapshots()
        .listen((snapshot) async {
      List<Map<String, dynamic>> newNotifications = [];

      for (var doc in snapshot.docs) {
        final availabilityData = doc.data();
        final List<dynamic> invitedOffices = availabilityData['invited'] ?? [];

        for (String officeUid in invitedOffices) {
          final officeDoc = await FirebaseFirestore.instance
              .collection('offices')
              .doc(officeUid)
              .get();

          if (!officeDoc.exists) continue;

          final officeData = officeDoc.data()!;
          final String name = officeData['officeName'] ?? 'Dental Office';
          final DateTime? calendarDate =
              parseDateTime(availabilityData['calendarDate']);
          final DateTime? startTime =
              parseDateTime(availabilityData['startTime']);
          final DateTime? endTime = parseDateTime(availabilityData['endTime']);
          String formattedDate = calendarDate != null
              ? "${calendarDate.day}/${calendarDate.month}/${calendarDate.year}"
              : "";

          String formattedStartTime = startTime != null
              ? "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}"
              : "";
          String formattedEndTime = endTime != null
              ? "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}"
              : "";

          newNotifications.add({
            'officeName': name,
            'availabilityId': doc.id,
            'day': formattedDate ?? '',
            'startTime': formattedStartTime ?? '',
            'endTime': formattedEndTime ?? '',
            'image': officeData['image'] ?? Images.onboarding2Img,
            'inviteOfficeUid': officeUid,
            'jobTitle': availabilityData['profession'],
            'workplace': availabilityData['location'],
            'location': availabilityData['location'],
            'payRate': availabilityData['hourlyWage'],
            'preferredHourlyWage': availabilityData['preferredHourlyWage'],
            'about': availabilityData['about'],
          });
        }
      }

      setState(() {
        officeNotifications = newNotifications;
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Notification",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0.w),
            child: CircleAvatar(
              backgroundColor: Colors.brown[200],
              child:
                  Icon(Icons.notifications, color: Colors.white, size: 24.sp),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : officeNotifications.isEmpty
              ? Center(
                  child: Text(
                    "No notifications yet.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: officeNotifications.length,
                  padding: EdgeInsets.all(16.w),
                  itemBuilder: (context, index) {
                    final office = officeNotifications[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => OfficeInviteYou(), arguments: {
                              'jobTitle': office['jobTitle'],
                              'workplace': office['workPlace'],
                              'location': office['location'],
                              'payRate': office['hourlyWage'],
                              //'imageUrl': office['image'],
                              'about': office['about'],
                              'preferredHourlyWage':
                                  office['preferredHourlyWage'],
                              'userId':
                                  uid, // ID of the office user (job poster)
                              'docId':
                                  office['availabilityId'], // ID of the post
                              'day': office['day'],
                              'startTime': office['startTime'],
                              'endTime': office['endTime'],
                              'inviteOfficeUid': office['inviteOfficeUid'],
                              'name': office['officeName']
                            });
                          },
                          child: NotificationCard(
                            imagePath:  Images.onboarding2Img,
                            title: "${office['officeName']} is invited",
                            subtitle: "in your availability on ${office['day']} at ${office['time']}",

                            time: "Just now",
                            tags: ["Interested"],
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],
                    );
                  },
                ),
    );
  }
}
