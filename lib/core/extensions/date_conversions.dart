extension DateConversions on DateTime {
  int daysAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);
    return difference.inDays;
  }
}
