import 'package:flutter/material.dart';

class SearchPosField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const SearchPosField({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  State<SearchPosField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchPosField> {
  // late FocusNode _searchFocusNode;

  @override
  void initState() {
    // super.initState();
    // _searchFocusNode = FocusNode();
    // _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    // _searchFocusNode.dispose();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        // focusNode: _searchFocusNode,
        controller: widget.controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Escanea el SKU o Código de Barras [F1]',
          suffixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onSubmitted: (value) {
          widget.onSubmitted(value);
          widget.controller.clear();
          // _searchFocusNode.requestFocus(); // Vuelve a enfocar el campo
        },
      ),
    );
  }
}
