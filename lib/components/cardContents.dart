import 'package:flutter/material.dart';

class CardContents extends StatelessWidget {
  final String value;
  final String label;

  Color? colour;
  CardContents({
    super.key,
    required this.label,
    this.colour, required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
      ],
    );
  }
}
