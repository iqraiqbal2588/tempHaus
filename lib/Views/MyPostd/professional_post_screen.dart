import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';

class ProfessionalPostsScreen extends StatefulWidget {
  const ProfessionalPostsScreen({
    super.key,
  });

  @override
  State<ProfessionalPostsScreen> createState() =>
      _ProfessionalPostsScreenState();
}

class _ProfessionalPostsScreenState extends State<ProfessionalPostsScreen> {
  Map<String, String> nameCache = {};
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<String> fetchOfficeName(String uids) async {
    if (nameCache.containsKey(uids)) {
      return nameCache[uids]!;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('offices')
          .doc(uids)
          .get();

      if (doc.exists) {
        final name = doc.data()?['officeName'] ?? 'Unknown User';
        nameCache[uids] = name;
        return name;
      } else {
        return 'User Not Found';
      }
    } catch (e) {
      print('Error fetching office name: $e');
      return 'Error Loading Name';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colorss.whiteColor),
          backgroundColor: Colorss.blackColor,
          title: Text(
            "My Posts",
            style: TextStyle(color: Colorss.whiteColor, fontSize: 22.sp),
          )),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('professionals')
            .doc(uid)
            .collection('availability')
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
              final data = posts[index].data() as Map<String, dynamic>;

              final name = data['name'] ?? 'No name';
              final about = data['about'] ?? 'No title';
              String? acceptedBy;
              if (data['statusMap'] != null) {
                final statusMap = Map<String, dynamic>.from(data['statusMap']);
                acceptedBy = statusMap.entries
                    .firstWhere(
                      (entry) => entry.value == 'accepted',
                      orElse: () => const MapEntry('', ''),
                    )
                    .key;
              }
              final image = data['image'];
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
                          // Icon or Thumbnail
                          Column(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Image.network(
                                    image,
                                    height: 100.h,
                                    width: 110.w,
                                    fit: BoxFit.fill,
                                  )),
                              SizedBox(height: 12.h),
                            ],
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  about,
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
                      (acceptedBy != null && acceptedBy.isNotEmpty)
                          ? FutureBuilder<String>(
                              future: fetchOfficeName(acceptedBy),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                    'Fetching...',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontStyle: FontStyle.italic),
                                  );
                                }

                                final officeName =
                                    snapshot.data ?? 'User Not Found';
                                if (officeName == 'User Not Found' ||
                                    officeName == 'Error Loading Name') {
                                  return Text(
                                    'Not accepted yet',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                                  );
                                }

                                return Text(
                                  'Accepted by: $officeName',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                );
                              },
                            )
                          : Text(
                              'Not accepted yet',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            )
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
