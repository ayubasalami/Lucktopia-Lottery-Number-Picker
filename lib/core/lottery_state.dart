class LotteryState {
  final List<int> selectedNumbers;
  final List<int> autoSelectedNumbers;
  final bool isShuffling;

  LotteryState({
    required this.selectedNumbers,
    required this.autoSelectedNumbers,
    required this.isShuffling,
  });

  LotteryState copyWith({
    List<int>? selectedNumbers,
    List<int>? autoSelectedNumbers,
    bool? isShuffling,
  }) {
    return LotteryState(
      selectedNumbers: selectedNumbers ?? this.selectedNumbers,
      autoSelectedNumbers: autoSelectedNumbers ?? this.autoSelectedNumbers,
      isShuffling: isShuffling ?? this.isShuffling,
    );
  }

  factory LotteryState.initial() {
    return LotteryState(
      selectedNumbers: [],
      autoSelectedNumbers: [],
      isShuffling: false,
    );
  }
}
