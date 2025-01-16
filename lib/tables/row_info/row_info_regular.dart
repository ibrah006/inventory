class RowInfo {
  RowInfo({required this.rowCells, this.selected = false});

  List<String> rowCells;

  bool selected;

  static double computeSummation(
      {required Iterable<RowInfo> rows, required int columnIndex}) {
    double total = 0;
    for (RowInfo rowInfo in rows) {
      total += double.parse(rowInfo.rowCells[columnIndex]);
    }

    return total;
  }
}
