class Cell {
  final int answer;
  final int? currentValue;
  final bool isGiven;

  Cell({required this.answer, this.currentValue, required this.isGiven});

  Cell copyWith({int? currentValue}) {
    return Cell(
      answer: this.answer,
      currentValue: currentValue ?? this.currentValue,
      isGiven: this.isGiven,
    );
  }
}
