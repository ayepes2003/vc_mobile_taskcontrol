import 'package:flutter/material.dart';

class SideMenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final int stepNumber;
  final Color selectedColor;
  final Color selectedTextColor;

  const SideMenuButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.stepNumber,
    required this.selectedColor,
    required this.selectedTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color:
            isSelected
                ? selectedColor.withOpacity(0.13)
                : Colors.white, // <-- Fondo blanco igual que el content
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? selectedColor : Colors.transparent,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? selectedColor : Colors.black54,
                  size: 24,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? selectedColor : Colors.black87,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      isSelected
                          ? selectedColor
                          : Colors.white, // <-- Fondo igual que el content
                  child: Text(
                    stepNumber.toString(),
                    style: TextStyle(
                      color: isSelected ? selectedTextColor : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
