import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

///
final userRef = firestore.collection('Users');
final notificationRef = firestore.collection('Notification');
final vehicleRef = firestore.collection('Vehicle');
final fuelRef = firestore.collection('Fuels');
final fuelTransaction = firestore.collection('FuelsTransactions');
final PrivacyPolicyRef = firestore.collection('Privacypolicy');
final TandCRef = firestore.collection('Termandcondition');
final FAQRef = firestore.collection('Faq');
final membershipRef = firestore.collection('Membership');
