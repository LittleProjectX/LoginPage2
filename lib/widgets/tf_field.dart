import 'package:flutter/material.dart';

class TfField extends StatelessWidget {
  final String title;
  final TextEditingController itemController;
  const TfField({super.key, required this.title, required this.itemController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      autocorrect: false,
      decoration: InputDecoration(
        label: Text(
          title,
          style: const TextStyle(color: Color(0xff9A031E)),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xff9A031E))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xff9A031E))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xff9A031E))),
      ),
      cursorColor: const Color(0xff9A031E),
      controller: itemController,
    );
  }
}
