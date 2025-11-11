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
  late String uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  Future<void> markPostAsCompleted(String postId) async {
    try {
      await FirebaseFirestore.instance
          .collection('offices')
          .doc(uid)
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
    if (nameCache.containsKey(uid)) return nameCache[uid]!;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('professionals')
          .doc(uid)
          .get();

      if (doc.exists) {
        final name = doc.data()?['firstName']?.toString() ?? 'Unknown Professional';
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('offices')
            .doc(uid)
            .collection('postingDetails')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No posts available."));
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final postId = post.id;
              final data = post.data() as Map<String, dynamic>;

              final isCompleted = data['isCompleted'] == true;
              final title = data['jobTitle']?.toString() ?? 'No Title';
              final description = data['description']?.toString() ?? 'No Description';
              final image = data['image']?.toString();

              // Handle status map safely
              String? acceptedBy;
              final statusMap = data['statusMap'] as Map<String, dynamic>?;
              if (statusMap != null) {
                final acceptedEntry = statusMap.entries.firstWhere(
                      (entry) => entry.value == 'accepted',
                  orElse: () => const MapEntry('', ''),
                );
                if (acceptedEntry.key.isNotEmpty) {
                  acceptedBy = acceptedEntry.key;
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image with null check
                          if (image != null && image.isNotEmpty)
                            Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Image.network(
                                    image,
                                    height: 100.h,
                                    width: 110.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                          height: 100.h,
                                          width: 110.w,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.error),
                                        ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                              ],
                            )
                          else
                            Container(
                              height: 100.h,
                              width: 110.w,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image),
                            ),

                          SizedBox(width: 12.w),
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
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 6.h),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Accepted by section
                      if (acceptedBy != null)
                        FutureBuilder<String>(
                          future: fetchProfessionalName(acceptedBy),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text(
                                'Loading...',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontStyle: FontStyle.italic,
                                ),
                              );
                            }
                            return Text(
                              'Accepted by: ${snapshot.data ?? 'Unknown'}',
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

                      // Action buttons
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
                        Text(
                          'Completed',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
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