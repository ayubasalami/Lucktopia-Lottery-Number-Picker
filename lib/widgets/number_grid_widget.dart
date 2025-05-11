import 'package:flutter/material.dart';

import '../responsive/size_config.dart';
import 'animate_number_bubble.dart';

class NumberGridWidget extends StatefulWidget {
  final void Function()? startAutoSelectAnimation;
  final void Function(int number)? onNumberTapped;
  final List<int> selectedNumbers;
  final List<int> autoSelectedNumbers;
  final bool isShuffling;

  const NumberGridWidget({
    super.key,
    required this.startAutoSelectAnimation,
    required this.onNumberTapped,
    required this.selectedNumbers,
    required this.autoSelectedNumbers,
    required this.isShuffling,
  });

  @override
  State<NumberGridWidget> createState() => _NumberGridWidgetState();
}

class _NumberGridWidgetState extends State<NumberGridWidget> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Column(
      children: [
        if (widget.autoSelectedNumbers.isNotEmpty && !widget.isShuffling)
          Wrap(
            spacing: SizeConfig.blockWidth * 2,
            children: widget.autoSelectedNumbers.map((number) {
              return AnimatedNumberBubble(number: number);
            }).toList(),
          ),
        SizedBox(height: SizeConfig.blockHeight * 2),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: SizeConfig.blockWidth * 2,
            mainAxisSpacing: SizeConfig.blockWidth * 2,
            childAspectRatio: 1,
          ),
          itemCount: 50,
          itemBuilder: (context, index) {
            final number = index + 1;
            final isSelected = widget.selectedNumbers.contains(number);
            final isAutoSelected = widget.autoSelectedNumbers.contains(number);
            final isHighlighted =
                widget.isShuffling ? isAutoSelected : isSelected;

            return GestureDetector(
              onTap: () => widget.onNumberTapped!(number),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                width: SizeConfig.blockWidth * 14,
                height: SizeConfig.blockWidth * 14,
                decoration: BoxDecoration(
                  color: isHighlighted ? Colors.blueAccent : Colors.grey[200],
                  borderRadius:
                      BorderRadius.circular(SizeConfig.blockWidth * 2),
                  boxShadow: [
                    if (isHighlighted)
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, SizeConfig.blockHeight * 0.5),
                        blurRadius: SizeConfig.blockWidth * 1.5,
                      ),
                  ],
                ),
                child: Text(
                  '$number',
                  style: TextStyle(
                    fontSize: SizeConfig.blockWidth * 4,
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
