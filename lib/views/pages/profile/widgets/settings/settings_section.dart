import 'package:flutter/material.dart';
import 'package:workout_tracker/models/settings_model.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/pages/profile/widgets/settings/settings_item.dart';

class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  List<SettingsModel> settingsModel = [];

  @override
  void initState() {
    super.initState();
    settingsModel = SettingsModel.getSettingsModel(context);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: List.generate(settingsModel.length, (index) {
            final settingModel = settingsModel[index];
            return Container(
              height: 60,
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: settingModel.isLogout ? Color(0xfffef2f2) : Colors.white,
                boxShadow: GlobalColors.boxShadow(context),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Center(
                child: SettingsItem(
                  onTap: settingModel.onTap,
                  leadingIcon: settingModel.leadingIcon,
                  title: settingModel.title,
                  trailingIcon: settingModel.trailingIcon,
                  isLogout: settingModel.isLogout,
                ),
              ),
            );
          })
        ),
      ],
    );
  }
}