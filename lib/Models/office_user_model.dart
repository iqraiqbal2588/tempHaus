class Office {
  String? email;
  String? password;
  String? officeName;
  String? address;
  String? phoneNumber;
  String? officeEmail;
  String? officeType;
  String? image;
  String? uid;
  List<CardDetails>? cardDetailsList;

  Office({
    this.email,
    this.password,
    this.officeName,
    this.address,
    this.phoneNumber,
    this.officeEmail,
    this.officeType,
    this.image,
    this.uid,
    this.cardDetailsList,
  });

  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(
      email: json['email'],
      password: json['password'],
      officeName: json['officeName'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      officeEmail: json['officeEmail'],
      officeType: json['officeType'],
      image: json['image'],
      uid: json['uid'],
      // ✅ use what's in Firestore
      cardDetailsList: json['cardDetailsList'] != null
          ? List<CardDetails>.from(
              json['cardDetailsList'].map((x) => CardDetails.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'officeName': officeName,
      'address': address,
      'phoneNumber': phoneNumber,
      'officeEmail': officeEmail,
      'officeType': officeType,
      'image': image,
      'uid': uid,
      'cardDetailsList': cardDetailsList?.map((x) => x.toJson()).toList(),
    };
  }
}

class CardDetails {
  String? cardName;
  DateTime? expiryDate;
  String? cvv;

  CardDetails({this.cardName, this.expiryDate, this.cvv});

  factory CardDetails.fromJson(Map<String, dynamic> json) {
    return CardDetails(
      cardName: json['cardName'],
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      cvv: json['cvv'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardName': cardName,
      'expiryDate': expiryDate?.toIso8601String(),
      'cvv': cvv,
    };
  }
}

class PostingDetails {
  List<String>? availableDays;
  DateTime? startTime;
  DateTime? endTime;
  double? amount;
  String? jobTitle;
  String? location;
  String? description;
  String? details;
  String? uid;
  List<String>? interested;

  // ✅ Add this field
  DateTime? createdAt;

  PostingDetails({
    this.availableDays,
    this.startTime,
    this.endTime,
    this.amount,
    this.jobTitle,
    this.location,
    this.description,
    this.details,
    this.uid,
    this.interested,
    this.createdAt, // ✅ Include in constructor
  });

  factory PostingDetails.fromJson(Map<String, dynamic> json) {
    return PostingDetails(
      availableDays: json['availableDays'] != null
          ? List<String>.from(json['availableDays'])
          : null,
      startTime:
      json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime:
      json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      amount: json['amount'] != null ? json['amount'].toDouble() : null,
      jobTitle: json['jobTitle'],
      location: json['location'],
      description: json['description'],
      details: json['details'],
      uid: json['uid'],
      interested: json['interested'] != null
          ? List<String>.from(json['interested'])
          : [],
      // ✅ Parse createdAt from Firestore if exists
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availableDays': availableDays,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'amount': amount,
      'jobTitle': jobTitle,
      'location': location,
      'description': description,
      'details': details,
      'uid': uid,
      'interested': interested ?? [],
      // ✅ Store createdAt in Firestore-compatible format
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
