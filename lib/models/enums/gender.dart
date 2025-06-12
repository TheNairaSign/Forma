import 'package:flutter/material.dart';

enum Gender {
  male,
  female,
  preferNotToDisclose,
}

Map<Gender, String> gender = {
  Gender.male: 'Male',
  Gender.female: 'Female',
  Gender.preferNotToDisclose: 'Prefer not to disclose',
};

Map<Gender, IconData> genderIcons = {
  Gender.male : Icons.male,
  Gender.female : Icons.female,
  Gender.preferNotToDisclose : Icons.close,
};


extension GenderIcon on Gender {
  IconData get icon {
    return genderIcons[this]!;
  }

  String get name {
    return gender[this]!;
  }
}
