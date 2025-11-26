import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final String? hintText;
  final VoidCallback? onDelete;

  const CustomTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.only(left: 16, right: 8),
      child: Row(
        children: [
          Flexible(
            flex: 6,
            child: TextField(
              controller: controller,
              onTap: onTap,
              onChanged: onChanged,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
          Flexible(
            flex: 1,
            child: 
            IconButton(onPressed: onDelete, icon: Icon(Icons.clear)),
          ),
        ],
      ),
    );
  }
}
