import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Professional {
  String? firstName;
  String? lastName;
  String? address;
  String? phoneNumber;
  String? email;
  String? password;
  String? emailPayment;
  String? role;
  int? graduatingYear;
  String? licenseNumber;
  List<String>? skillsAndQualifications;
  String? workExperience;
  String? bio;
  String? imageUrl;
  String? uid;
  Timestamp? createdAt;

  Professional({
    this.firstName,
    this.lastName,
    this.address,
    this.phoneNumber,
    this.email,
    this.password,
    this.role,
    this.graduatingYear,
    this.licenseNumber,
    this.skillsAndQualifications,
    this.workExperience,
    this.bio,
    this.imageUrl,
    this.uid,
    this.emailPayment,
    this.createdAt,
  });

  factory Professional.fromJson(Map<String, dynamic> json) {
    return Professional(
      uid: json['uid'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      graduatingYear: json['graduatingYear'] is int
          ? json['graduatingYear']
          : int.tryParse(json['graduatingYear']?.toString() ?? ''),
      licenseNumber: json['licenseNumber'],
      skillsAndQualifications: json['skillsAndQualifications'] != null
          ? List<String>.from(json['skillsAndQualifications'])
          : null,
      workExperience: json['workExperience'],
      bio: json['bio'],
      imageUrl: json['imageUrl'],
      emailPayment: json['emailPayment'],
      createdAt: json['createdAt'] is Timestamp
          ? json['createdAt']
          : json['createdAt'] is String
          ? Timestamp.fromDate(DateTime.parse(json['createdAt']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'role': role,
      'graduatingYear': graduatingYear,
      'licenseNumber': licenseNumber,
      'skillsAndQualifications': skillsAndQualifications,
      'workExperience': workExperience,
      'bio': bio,
      'imageUrl': imageUrl,
      'emailPayment': emailPayment,
      'createdAt': createdAt,
    };
  }
}

class Availability {
  DateTime? calendarDate;
  DateTime? startTime;
  DateTime? endTime;
  double? hourlyWage;
  double? preferredHourlyWage;
  String? uid;

  Availability({
    this.calendarDate,
    this.startTime,
    this.endTime,
    this.hourlyWage,
    this.preferredHourlyWage,
    this.uid,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      calendarDate: json['calendarDate'] != null
          ? (json['calendarDate'] is Timestamp
          ? (json['calendarDate'] as Timestamp).toDate()
          : DateTime.tryParse(json['calendarDate'].toString()))
          : null,
      startTime: json['startTime'] != null
          ? (json['startTime'] is Timestamp
          ? (json['startTime'] as Timestamp).toDate()
          : DateTime.tryParse(json['startTime'].toString()))
          : null,
      endTime: json['endTime'] != null
          ? (json['endTime'] is Timestamp
          ? (json['endTime'] as Timestamp).toDate()
          : DateTime.tryParse(json['endTime'].toString()))
          : null,
      hourlyWage: json['hourlyWage'] != null
          ? double.tryParse(json['hourlyWage'].toString())
          : null,
      preferredHourlyWage: json['preferredHourlyWage'] != null
          ? double.tryParse(json['preferredHourlyWage'].toString())
          : null,
      uid: json['uid'] ?? FirebaseAuth.instance.currentUser?.uid,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calendarDate': calendarDate?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'hourlyWage': hourlyWage,
      'preferredHourlyWage': preferredHourlyWage,
      'uid': uid,
    };
  }
}
