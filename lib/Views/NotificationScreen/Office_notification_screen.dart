import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:temp_haus_dental_clinic/Constants/images.dart';
import 'package:temp_haus_dental_clinic/Views/NotificationScreen/Widgets/notification_tile.dart';
import 'Widgets/ProfessionalInterestedInYou/professional_interested_in_you.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> interestedUsers = [];
  Set<String> processedUserJobPairs = {};
  bool isLoading = true;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  StreamSubscription? listener;

  @override
  void initState() {
    super.initState();
    startListeningToInterests();
  }

  void startListeningToInterests() {
    listener = FirebaseFirestore.instance
        .collection('offices')
        .doc(uid)
        .collection('postingDetails')
        .snapshots()
        .listen((snapshot) async {
      List<Map<String, dynamic>> newInterestedUsers = [];
      Set<String> newProcessedPairs = {};

      for (var doc in snapshot.docs) {
        final postData = doc.data();
        final List<dynamic> interestedList = postData['interested'] ?? [];

        for (String interestedUid in interestedList) {
          String pairKey = '${interestedUid}_${doc.id}';
          if (newProcessedPairs.contains(pairKey)) continue;

          final professionalDoc = await FirebaseFirestore.instance
              .collection('professionals')
              .doc(interestedUid)
              .get();

          if (!professionalDoc.exists) continue;

          final String workPlace = postData['location'] ?? 'No Name';
          final String location = postData['location'] ?? '';
          final String day = postData['imageUrl'] ?? '';
          final String startTime = postData['startTime'] ?? 'No Name';
          final String endTime = postData['endTime'] ?? '';
          final double payRate = postData['amount']?.toDouble() ?? 0.0;
          final String jobTitle = postData['jobTitle'] ?? '';

          // ✅ SAFELY HANDLE TIMESTAMP
          Timestamp? createdAtTimestamp;
          if (postData['createdAt'] is Timestamp) {
            createdAtTimestamp = postData['createdAt'];
          } else if (postData['createdAt'] is String) {
            try {
              createdAtTimestamp = Timestamp.fromDate(
                  DateFormat('yyyy-MM-dd').parse(postData['createdAt']));
            } catch (_) {}
          }

          final String formattedDate = createdAtTimestamp != null
              ? DateFormat('MMM d, yyyy – hh:mm a')
              .format(createdAtTimestamp.toDate())
              : 'Unknown';

          final professionalData = professionalDoc.data()!;
          final String name = professionalData['firstName'] ?? 'No Name';
          final String about = professionalData['bio'] ?? '';
          final String image = professionalData['imageUrl'] ?? '';

          newInterestedUsers.add({
            'workPlace': workPlace,
            'location': location,
            'day': day,
            'startT': startTime,
            'endT': endTime,
            'payRate': payRate,
            'uid': interestedUid,
            'docId': doc.id,
            'name': name,
            'about': about,
            'jobDetails': postData['details'],
            'image': image,
            'jobTitle': jobTitle,
            'createdAt': formattedDate,
          });

          newProcessedPairs.add(pairKey);
        }
      }

      setState(() {
        interestedUsers = newInterestedUsers;
        processedUserJobPairs = newProcessedPairs;
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
          "Notifications",
          style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold),
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
          : interestedUsers.isEmpty
          ? Center(
        child: Text(
          "No notifications yet.",
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        itemCount: interestedUsers.length,
        itemBuilder: (context, index) {
          final user = interestedUsers[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => ProfessionalInterestedInYou(),
                      arguments: {
                        'jobTitle': user['jobTitle'],
                        'workplace': user['workPlace'],
                        'location': user['location'],
                        'payRate': user['payRate'],
                        'imageUrl': user['image'],
                        'description': user['jobDetails'],
                        'detail': user['jobDetails'],
                        'userId': uid,
                        'docId': user['docId'],
                        'day': user['day'],
                        'startTime': user['startT'],
                        'endTime': user['endT'],
                        'interestedUserId': user['uid'],
                        'name': user['name']
                      });
                },
                child: NotificationCard(
                  imagePath: user['image'] ?? Images.profile,
                  title: "${user['name']} shown interest",
                  subtitle:
                  "${user['name']} shown interest in your job: ${user['jobTitle']}",
                  time: user['createdAt'] ?? 'Unknown',
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
