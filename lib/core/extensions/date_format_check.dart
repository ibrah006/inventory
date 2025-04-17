import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

extension ConvertDatabaseDateString on String {
  String formatDateFromDatabaseString() {
    final parsedDate = DateTime.parse(this);
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter
        .format(parsedDate.toLocal()); // Convert to local time if needed
  }
}

extension StringIsValidDate on String {
  bool isValidDate({bool showDebugPrint = false}) {
    if (showDebugPrint) {
      debugPrint("(debug) (extension) String.isValidDate field value: $this");
    }

    // Basic regex to check DD/MM/YYYY format
    final regex = RegExp(r"^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[0-2])\/\d{4}$");

    if (!regex.hasMatch(this)) {
      if (showDebugPrint) {
        debugPrint(
            "(debug) (extension) String.isValidDate, regex.hasMatch == false -> returns false out of he function");
      }
      return false; // If the format doesn't match
    }

    // Extract day, month, and year
    List<String> parts = this.split('/');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);

    // Check for valid days per month (accounting for leap years)
    if (!_isValidDay(day, month, year)) {
      if (showDebugPrint) {
        debugPrint(
            "(debug) (extension) String.isValidDate, _isValidDay(...) == false");
      }
      return false;
    }

    return true;
  }
}

// Helper function to check if the day is valid for the given month and year
bool _isValidDay(int day, int month, int year) {
  // Days in months (not accounting for leap years)
  Map<int, int> daysInMonth = {
    1: 31,
    2: 28,
    3: 31,
    4: 30,
    5: 31,
    6: 30,
    7: 31,
    8: 31,
    9: 30,
    10: 31,
    11: 30,
    12: 31
  };

  // Adjust for leap year in February
  if (_isLeapYear(year)) {
    daysInMonth[2] = 29; // February has 29 days in a leap year
  }

  // Check if the day is valid for the month
  return day > 0 && day <= daysInMonth[month]!;
}

// Helper function to check if a year is a leap year
bool _isLeapYear(int year) {
  // Leap year rule: divisible by 4, but not by 100 unless also divisible by 400
  return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
}

// extension ListReverse<T> on List<T> {
//   void swicth÷() {
//     T? next;
//     for (int i = 1; i < this.length; i++) {
//       next = this[i];
//       this[i] = this[i - 1];
//     }
//   }
// }
