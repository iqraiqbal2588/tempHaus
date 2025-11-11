import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Models/professional_user_model.dart';

class AvailabilityController extends GetxController {
  var availability = Availability().obs; // Observable Availability Object

  void updateCalendarDate(DateTime value) {
    availability.update((a) {
      a?.calendarDate = value;
    });
  }

  void updateStartDate(DateTime value) {
    availability.update((a) {
      a?.startTime = value;
    });
  }

  void updateEndDate(DateTime value) {
    availability.update((a) {
      a?.endTime = value;
    });
  }

  void updateHourlyWage(double value) {
    availability.update((a) {
      a?.hourlyWage = value;
    });
  }

  void updatePreferredHourlyWage(String value) {
    availability.update((a) {
      a?.preferredHourlyWage = double.tryParse(value);
    });
  }


  void updateUid(String value) {
    availability.update((a) {
      a?.uid = value;
    });
  }

  // Get full availability data
  Availability getAvailabilityData() {
    return availability.value;
  }
}
