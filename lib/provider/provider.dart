import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucktopia/view-models/lottery-view-model.dart';

import '../core/lottery_state.dart';

final lotteryViewModelProvider =
    StateNotifierProvider<LotteryViewModel, LotteryState>(
  (ref) {
    return LotteryViewModel();
  },
);
