import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final String labelText;

  const SearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.labelText,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: widget.controller,
        autofocus: true,
        focusNode: FocusNode(), // <- Usa el focusNode dinámico
        decoration: InputDecoration(
          labelText: widget.labelText, // <- Usa el label dinámico
          suffixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onSubmitted: (value) {
          widget.onSubmitted(value);

          widget.controller.clear();
        },
      ),
    );
  }
}
