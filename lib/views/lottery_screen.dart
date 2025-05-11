import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../provider/provider.dart';
import '../responsive/size_config.dart';
import '../widgets/number_grid_widget.dart';

class LotteryScreen extends ConsumerStatefulWidget {
  const LotteryScreen({super.key});

  @override
  ConsumerState<LotteryScreen> createState() => _LotteryScreenState();
}

class _LotteryScreenState extends ConsumerState<LotteryScreen> {
  _showBottomSheet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: AppColors().background,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Container(
            height: height * 0.25,
            decoration: BoxDecoration(
              color: AppColors().background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(width * 0.08),
                topRight: Radius.circular(width * 0.08),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: height * 0.02),
                Center(
                  child: Image.asset(
                    'assets/success.png',
                    height: height * 0.1,
                  ),
                ),
                SizedBox(height: height * 0.03),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: height * 0.055,
                    width: width * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(width * 0.06),
                    ),
                    child: Center(
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                          fontSize: width * 0.045,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final state = ref.watch(lotteryViewModelProvider);
    final viewModel = ref.read(lotteryViewModelProvider.notifier);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (!state.isShuffling) {
            viewModel.startAutoSelectAnimation(
                context, () => _showBottomSheet(context));
          }
        },
        backgroundColor: state.isShuffling
            ? Colors.grey
            : state.autoSelectedNumbers.isEmpty && state.selectedNumbers.isEmpty
                ? AppColors().mainColor
                : Colors.grey,
        icon: Icon(
          Icons.auto_awesome,
          size: SizeConfig.screenWidth * 0.05,
          color: Colors.white,
        ),
        label: Text(
          'Auto Pick',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.screenWidth * 0.04,
          ),
        ),
      ),
      backgroundColor: AppColors().background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors().background,
        title: const Text('Lucktopia Lottery'),
        actions: (state.selectedNumbers.isNotEmpty ||
                    state.autoSelectedNumbers.isNotEmpty) &&
                !state.isShuffling
            ? [
                TextButton(
                  onPressed: () {
                    viewModel.clearNumbers();
                  },
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]
            : [],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  NumberGridWidget(
                    startAutoSelectAnimation: () =>
                        viewModel.startAutoSelectAnimation(
                            context, () => _showBottomSheet(context)),
                    onNumberTapped: (number) => viewModel.onNumberTapped(
                        number, context, () => _showBottomSheet(context)),
                    selectedNumbers: state.selectedNumbers,
                    isShuffling: state.isShuffling,
                    autoSelectedNumbers: state.autoSelectedNumbers,
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: viewModel.confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
              createParticlePath: (size) {
                return Path()
                  ..lineTo(size.width / 2, size.height)
                  ..lineTo(size.width, 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}
