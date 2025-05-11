import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/lottery_state.dart';

class LotteryViewModel extends StateNotifier<LotteryState> {
  late ConfettiController _confettiController;

  LotteryViewModel() : super(LotteryState.initial()) {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  ConfettiController get confettiController => _confettiController;

  void onNumberTapped(
      int number, BuildContext context, VoidCallback showBottomSheet) {
    if (state.isShuffling) return;

    state = state.copyWith(
      autoSelectedNumbers: [],
    );

    final selected = List<int>.from(state.selectedNumbers);

    final wasFiveBeforeTap = selected.length == 5;

    if (selected.contains(number)) {
      selected.remove(number);
    } else if (selected.length < 6) {
      selected.add(number);
    }

    state = state.copyWith(selectedNumbers: selected);

    if (wasFiveBeforeTap && selected.length == 6) {
      _triggerConfetti();
      showBottomSheet();
    }
  }

  void startAutoSelectAnimation(
      BuildContext context, VoidCallback showBottomSheet) {
    if (state.isShuffling) return;

    state = state.copyWith(
      isShuffling: true,
      autoSelectedNumbers: [],
      selectedNumbers: [],
    );

    final random = Random();
    int tickCount = 0;
    Timer? timer;

    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (t) {
        tickCount++;

        final autoNumbers = List.generate(
          random.nextInt(6) + 1,
          (_) => random.nextInt(50) + 1,
        ).toSet().toList();

        state = state.copyWith(autoSelectedNumbers: autoNumbers);

        if (tickCount >= 15) {
          t.cancel();
          final newNumbers = <int>{};
          while (newNumbers.length < 6) {
            newNumbers.add(random.nextInt(50) + 1);
          }

          state = state.copyWith(
            autoSelectedNumbers: newNumbers.toList(),
            isShuffling: false,
          );

          _triggerConfetti();
          showBottomSheet();
        }
      },
    );
  }

  void clearNumbers() {
    state = state.copyWith(
      selectedNumbers: [],
      autoSelectedNumbers: [],
    );
    _confettiController.stop();
  }

  void _triggerConfetti() {
    _confettiController.play();
  }
}
