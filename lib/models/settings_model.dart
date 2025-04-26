import 'package:flutter/material.dart';
import 'package:workout_tracker/views/pages/profile/sub_pages/edit_profile_page.dart';

class SettingsModel {
  final IconData leadingIcon;
  final IconData? trailingIcon;
  final String title;
  final bool isLogout;
  final VoidCallback onTap;

  SettingsModel({
    required this.leadingIcon,
    required this.trailingIcon,
    required this.title,
    this.isLogout = false,
    required this.onTap,
  });

  static List<SettingsModel> getSettingsModel(BuildContext context) {
    List<SettingsModel> settingsList = [];
      settingsList.add(SettingsModel(
        leadingIcon: Icons.person_outline,
        title: 'Edit Profile',
        trailingIcon: Icons.chevron_right,
        onTap: () {
          debugPrint('Edit Profile page');
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => EditProfilePage()));
        }
        )
      );
      settingsList.add(SettingsModel(
        leadingIcon: Icons.notifications_outlined,
        title: 'Notifications',
        trailingIcon: Icons.chevron_right,
        onTap: () {},
      ));
      settingsList.add(SettingsModel(
        leadingIcon: Icons.privacy_tip_outlined,
        title: 'Privacy',
        trailingIcon: Icons.chevron_right,
        onTap: () {},
      ));
      settingsList.add(SettingsModel(
        leadingIcon: Icons.help_outline,
        title: 'Help & Support',
        trailingIcon: Icons.chevron_right,
        onTap: () {},
      ));
      settingsList.add(SettingsModel(
        leadingIcon: Icons.logout,
        title: 'Logout',
        trailingIcon: null,
        isLogout: true,
        onTap: () {},
      ));
    return settingsList;
  } 
}
