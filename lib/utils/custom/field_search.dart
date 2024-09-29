import 'package:flutter/material.dart';

class UrlInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isTextNotEmpty;
  final bool isTextEmptyError;

  const UrlInputField({
    required this.controller,
    required this.focusNode,
    required this.isTextNotEmpty,
    required this.isTextEmptyError,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: "Enter url Download",
              prefixIcon: isTextNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        controller.clear();
                      },
                    )
                  : null,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(
                  width: 2,
                  color: isTextNotEmpty
                      ? isTextEmptyError
                          ? Colors.red
                          : Colors.green
                      : Colors.grey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(
                  width: 2,
                  color: isTextEmptyError ? Colors.red : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/**
 * 
 * button
 */
class SubmitButton extends StatelessWidget {
  final bool isTextNotEmpty;
  final VoidCallback onPressed;

  const SubmitButton({
    required this.isTextNotEmpty,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isTextNotEmpty ? Colors.green : Colors.grey,
      height: 65,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          "Dwonload",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
