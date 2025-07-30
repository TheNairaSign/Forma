import 'package:flutter/material.dart';
import 'package:workout_tracker/views/pages/profile/help_support_page.dart';
import 'package:workout_tracker/views/pages/profile/privacy_page.dart';
import 'package:workout_tracker/views/pages/profile/widgets/settings/edit_profile_page.dart';
import 'package:workout_tracker/views/pages/profile/widgets/settings/edit_data_page.dart';

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
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => EditProfilePage()));
        }
        )
      );
      settingsList.add(SettingsModel(
        leadingIcon: Icons.notifications_outlined,
        title: 'Edit Data',
        trailingIcon: Icons.chevron_right,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => EditDataPage()));
        },
      ));
      settingsList.add(SettingsModel(
        leadingIcon: Icons.privacy_tip_outlined,
        title: 'Privacy',
        trailingIcon: Icons.chevron_right,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => PrivacyPolicyPage())),
      ));
      settingsList.add(SettingsModel(
        leadingIcon: Icons.help_outline,
        title: 'Help & Support',
        trailingIcon: Icons.chevron_right,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => HelpSupportPage())),
      ));
    return settingsList;
  } 
}
