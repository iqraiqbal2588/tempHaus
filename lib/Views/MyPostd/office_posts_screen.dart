import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';

class OfficePostsScreen extends StatefulWidget {
  const OfficePostsScreen({super.key});

  @override
  State<OfficePostsScreen> createState() => _OfficePostsScreenState();
}

class _OfficePostsScreenState extends State<OfficePostsScreen> {
  final Map<String, String> nameCache = {};
  late String officeDocId;

  @override
  void initState() {
    super.initState();

    // 🔥 Always load saved office posts (even without login)
    officeDocId = FirebaseAuth.instance.currentUser?.uid ?? "defaultOffice";
  }

  Future<void> markPostAsCompleted(String postId) async {
    try {
      await FirebaseFirestore.instance
          .collection('offices')
          .doc(officeDocId)
          .collection('postingDetails')
          .doc(postId)
          .update({'isCompleted': true});
    } catch (e) {
      print('Error marking as completed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to mark as completed')),
      );
    }
  }

  Future<String> fetchProfessionalName(String? uid) async {
    if (uid == null || uid.isEmpty) return 'Not accepted yet';
    if (nameCache.containsKey(uid)) return nameCache[uid] ?? 'Unknown';

    try {
      final doc = await FirebaseFirestore.instance
          .collection('professionals')
          .doc(uid)
          .get();

      if (doc.exists) {
        final name =
        (doc.data()?['firstName']?.toString() ?? 'Unknown Professional');
        nameCache[uid] = name;
        return name;
      }
      return 'Professional Not Found';
    } catch (e) {
      print('Error fetching professional name: $e');
      return 'Error Loading Name';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colorss.whiteColor),
        backgroundColor: Colorss.blackColor,
        title: Text(
          "My Posts",
          style: TextStyle(color: Colorss.whiteColor, fontSize: 22.sp),
        ),
      ),

      /// 🔥 Removed "User not logged in" – we ALWAYS show posts.
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('offices')
            .doc(officeDocId)
            .collection('postingDetails')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No posts available.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final post = docs[index];
              final postId = post.id;
              final data = (post.data() as Map<String, dynamic>? ?? {});

              final bool isCompleted = data['isCompleted'] == true;
              final String title = data['jobTitle']?.toString() ?? 'No Title';
              final String description =
                  data['description']?.toString() ?? 'No Description';
              final String? image = data['image']?.toString();

              /// ✔ SAFELY FETCH acceptedBy
              String? acceptedBy;
              final statusMap =
              data['statusMap'] is Map ? data['statusMap'] as Map? : null;

              if (statusMap != null) {
                final acceptedEntry = statusMap.entries.firstWhere(
                      (entry) => entry.value == 'accepted',
                  orElse: () => const MapEntry('', ''),
                );
                if (acceptedEntry.key.toString().isNotEmpty) {
                  acceptedBy = acceptedEntry.key.toString();
                }
              }

              return Card(
                color: Colorss.silkColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                child: Padding(
                  padding: EdgeInsets.all(12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE + DATA
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (image != null && image.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                image,
                                height: 100.h,
                                width: 110.w,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 100.h,
                                  width: 110.w,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error),
                                ),
                              ),
                            )
                          else
                            Container(
                              height: 100.h,
                              width: 110.w,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image),
                            ),

                          SizedBox(width: 12.w),

                          /// TEXT
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10.h),

                      /// ACCEPTED BY
                      if (acceptedBy != null)
                        FutureBuilder<String>(
                          future: fetchProfessionalName(acceptedBy),
                          builder: (context, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('Loading...');
                            }
                            return Text(
                              'Accepted by: ${snap.data}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            );
                          },
                        )
                      else
                        Text(
                          'Not accepted yet',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),

                      SizedBox(height: 10.h),

                      /// ACTION BUTTON
                      if (acceptedBy != null && !isCompleted)
                        ElevatedButton(
                          onPressed: () => markPostAsCompleted(postId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colorss.blackColor,
                          ),
                          child: Text(
                            'Mark as Completed',
                            style: TextStyle(color: Colorss.whiteColor),
                          ),
                        )
                      else if (isCompleted)
                        const Text(
                          'Completed',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
