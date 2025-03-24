import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OverviewItem extends StatefulWidget {
  final String value;
  final String label;

  const OverviewItem({
    Key? key,
    required this.value,
    required this.label,
  }) : super(key: key);

  @override
  State<OverviewItem> createState() => _OverviewItemState();
}

class _OverviewItemState extends State<OverviewItem> {
  bool _isAnimationDone = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 135,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: _isAnimationDone
                ? Text(
              widget.value,
              style: const TextStyle(
                fontSize: 16.5,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
                : AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  widget.value,
                  speed: const Duration(milliseconds: 70),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              isRepeatingAnimation: false,
              totalRepeatCount: 1,
              onFinished: () {
                setState(() {
                  _isAnimationDone = true;
                });
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}





Widget buildActionCard(IconData icon, String label, Color color, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

class ShopItem extends StatefulWidget {
  final String value;
  final String label;

  const ShopItem({
    Key? key,
    required this.value,
    required this.label,
  }) : super(key: key);

  @override
  State<OverviewItem> createState() => _OverviewItemState();
}

class _ShopItemState extends State<ShopItem> {
  bool _isAnimationDone = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: _isAnimationDone
                ? Text(
              widget.value,
              style: const TextStyle(
                fontSize: 16.5,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
                : AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  widget.value,
                  speed: const Duration(milliseconds: 70),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              isRepeatingAnimation: false,
              totalRepeatCount: 1,
              onFinished: () {
                setState(() {
                  _isAnimationDone = true;
                });
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

