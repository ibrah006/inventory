extension ListReplaceFirstWhere<T> on List<T> {
  // Replace the first element that satisfies the condition
  void replaceFirstWhere(bool Function(T) test, T Function(T) replace) {
    for (int i = 0; i < this.length; i++) {
      if (test(this[i])) {
        this[i] = replace(this[i]);
        break; // Exit after replacing the first element
      }
    }
  }
}

extension StringAddSpaceBetweenCaps on String {
  String addSpacesBetweenCaps() {
    // Use a regular expression to find uppercase letters that are preceded by lowercase letters
    // and insert a space before them.
    return this.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    });
  }
}

extension StringIsValidDate on String {
  bool isValidDate() {
    // Basic regex to check DD/MM/YYYY format
    final regex = RegExp(r"^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[0-2])\/\d{4}$");

    if (!regex.hasMatch(this)) {
      return false; // If the format doesn't match
    }

    // Extract day, month, and year
    List<String> parts = this.split('/');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);

    // Check for valid days per month (accounting for leap years)
    if (!_isValidDay(day, month, year)) {
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
