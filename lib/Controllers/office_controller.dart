import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Models/office_user_model.dart';

class OfficeController extends GetxController {
  var office = Office().obs;
  var cardDetailsList = <CardDetails>[].obs;
  var postingDetails = PostingDetails().obs;

  void updateOfficeDetails({
    String? email,
    String? password,
    String? officeName,
    String? address,
    String? phoneNumber,
    String? officeEmail,
    String? officeType,
    String? image,
    String? uid,
    List<CardDetails>? cardDetailsList,
    PostingDetails? postingDetails,
  }) {
    office.update((o) {
      if (email != null) o?.email = email;
      if (password != null) o?.password = password;
      if (officeName != null) o?.officeName = officeName;
      if (address != null) o?.address = address;
      if (phoneNumber != null) o?.phoneNumber = phoneNumber;
      if (officeEmail != null) o?.officeEmail = officeEmail;
      if (officeType != null) o?.officeType = officeType;
      if (image != null) o?.image = image;
      if (uid != null) o?.uid = uid;
      if (cardDetailsList != null) o?.cardDetailsList = cardDetailsList;
    });
  }

  void addCard(CardDetails card) {
    cardDetailsList.add(card);
    office.update((o) {
      o?.cardDetailsList = cardDetailsList.toList();
    });
  }

  void removeCard(int index) {
    if (index >= 0 && index < cardDetailsList.length) {
      cardDetailsList.removeAt(index);
      office.update((o) {
        o?.cardDetailsList = cardDetailsList.toList();
      });
    }
  }

  void updateCard(int index, CardDetails updatedCard) {
    if (index >= 0 && index < cardDetailsList.length) {
      cardDetailsList[index] = updatedCard;
      office.update((o) {
        o?.cardDetailsList = cardDetailsList.toList();
      });
    }
  }

  /// ✅ Updated to include `createdAt`
  void updatePostingDetails({
    List<String>? availableDays,
    DateTime? startTime,
    DateTime? endTime,
    double? amount,
    String? jobTitle,
    String? location,
    String? description,
    String? details,
    String? uid,
    DateTime? createdAt, // <-- New field
  }) {
    postingDetails.update((pd) {
      if (availableDays != null) pd?.availableDays = availableDays;
      if (startTime != null) pd?.startTime = startTime;
      if (endTime != null) pd?.endTime = endTime;
      if (amount != null) pd?.amount = amount;
      if (jobTitle != null) pd?.jobTitle = jobTitle;
      if (location != null) pd?.location = location;
      if (description != null) pd?.description = description;
      if (details != null) pd?.details = details;
      if (uid != null) pd?.uid = uid;
      if (createdAt != null) pd?.createdAt = createdAt; // <-- Set it here
    });
  }

  Office getOfficeData() => office.value;

  PostingDetails getPostingDetails() => postingDetails.value;
}
