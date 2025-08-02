import 'package:flutter/material.dart';

class CustomFlushbarWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final double height; // Customizable height
  final VoidCallback? onDismissed; // Callback for explicit dismiss action

  const CustomFlushbarWidget({
    super.key,
    required this.message,
    this.icon,
    this.backgroundColor = Colors.black87,
    this.textColor = Colors.white,
    required this.height,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    // Estimate max lines based on height, assuming a line height of ~20px
    // This is a rough estimation and might need adjustment based on font size and padding.
    int maxLines = (height - 16.0) ~/ 20.0; // 16.0 for vertical padding
    if (maxLines < 1) maxLines = 1;

    return Material(
      color: Colors.transparent, // Let the container handle the background
      child: Container(
        height: height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        // Vertical padding handled by centering
        decoration: BoxDecoration(
          color: backgroundColor,
          // Example: Add rounded corners or shadow
          // borderRadius: BorderRadius.circular(8.0),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.15),
          //     spreadRadius: 1,
          //     blurRadius: 8,
          //     offset: Offset(0, 2),
          //   ),
          // ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          // Center items vertically
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor,
                  size: (height * 0.5).clamp(16.0, 30.0)),
              // Icon size relative to height
              const SizedBox(width: 12.0),
            ],
            Expanded(
              child: Text(
                message,
                textAlign: TextAlign.center, // Center text horizontally
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor,
                  fontSize: (height * 0.25).clamp(12.0, 18.0), // Font size relative to height
                ),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // if (onDismissed != null) // Optional close button
            //   IconButton(
            //     icon: Icon(Icons.close, color: textColor,
            //         size: (height * 0.35).clamp(16.0, 24.0)),
            //     padding: EdgeInsets.zero,
            //     constraints: const BoxConstraints(),
            //     // To remove extra padding from IconButton
            //     onPressed: onDismissed,
            //   ),
          ],
        ),
      ),
    );
  }
}