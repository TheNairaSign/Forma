import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({super.key, required this.leadingIcon, required this.title, this.trailingIcon, this.isLogout = false, required this.onTap});
  final IconData leadingIcon;
  final String title;
  final IconData? trailingIcon;
  final bool isLogout;
  final VoidCallback onTap; 

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: isLogout
          ? Colors.red
          : Colors.black,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: isLogout
            ? Colors.red
            : Colors.black,
        ),
      ),
      trailing: trailingIcon != null
        ? Icon(trailingIcon, color: Colors.black)
        : null,
      onTap: onTap,
    );
  }
}