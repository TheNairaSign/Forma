import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/edit_profile_provider.dart';
class TextFieldModel {
  final String hintText, labelText;
  final bool showSuffix, obscureText, enabled;
  final Widget? prefixIcon, suffixIcon;
  final TextEditingController controller;
  final Function(String)? onChanged;

  const TextFieldModel({
    required this.hintText,
    required this.showSuffix,
    required this.controller,
    required this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    required this.labelText,
    this.enabled = true,
  });
  
  static const iconColor =  Color(0xffa5cbaa);

  /*
  static List<TextFieldModel> getSignUpTextFields(BuildContext context) {
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    List<TextFieldModel> signUpTextFields = [];

    signUpTextFields.add(
      TextFieldModel(
        hintText: 'Enter your first name',
        showSuffix: false,
        prefixIcon: const Icon(Icons.email, color: iconColor),
        controller: signUpProvider.firstnameController,
        obscureText: false,
      ),
    );
    signUpTextFields.add(
      TextFieldModel(
        hintText: 'Enter your last name',
        showSuffix: false,
        prefixIcon: const Icon(Icons.email, color: iconColor),
        controller: signUpProvider.lastnameController,
        obscureText: false,
      ),
    );
    signUpTextFields.add(
      TextFieldModel(
        hintText: 'Enter your email',
        showSuffix: false,
        prefixIcon: const Icon(Icons.email, color: iconColor),
        controller: signUpProvider.emailController,
        obscureText: false,
      ),
    );

    signUpTextFields.add(
      TextFieldModel(
        hintText: 'Enter your password',
        showSuffix: true,
        prefixIcon: const Icon(Icons.lock, color: iconColor),
        controller: signUpProvider.passwordController,
        obscureText: true
      ),
    );

    signUpTextFields.add(
      TextFieldModel(
        hintText: 'Confirm Password',
        showSuffix: true,
        prefixIcon: const Icon(Icons.lock, color: iconColor),
        controller: signUpProvider.confirmPasswordController,
        obscureText: true
      ),
    );

    return signUpTextFields;
  }

  static List<TextFieldModel> getLoginTextFields(BuildContext context) {
    List<TextFieldModel> signUpTextFields = [];
    final loginProvider = context.read<LoginProvider>();

    signUpTextFields.add(
      TextFieldModel(
        hintText: 'Enter your username',
        showSuffix: false,
        prefixIcon: const Icon(Icons.email, color: iconColor),
        controller: loginProvider.emailController,
        obscureText: false,
      ),
    );

    signUpTextFields.add(
      TextFieldModel(
        hintText: 'Enter your password',
        showSuffix: true,
        prefixIcon: const Icon(Icons.lock, color: iconColor),
        controller: loginProvider.passwordController,
        obscureText: true
      ),
    );
    return signUpTextFields;
  }
  */

  static List<TextFieldModel> editProfileTextFields(BuildContext context, WidgetRef ref) {
    List<TextFieldModel> editProfileFields = [];
    final editProfileControllers = ref.read(editProfileProvider.notifier);

    editProfileFields.add(
      TextFieldModel(
        hintText: 'Enter your name',
        showSuffix: false,
        prefixIcon: const Icon(Icons.person_outline, color: iconColor),
        controller: editProfileControllers.nameController,
        obscureText: false,
        labelText: 'Name',
      ),
    );

    editProfileFields.add(
      TextFieldModel(
        hintText: 'A brief bio of yourself',
        showSuffix: true,
        prefixIcon: const Icon(Icons.info_outline, color: iconColor),
        controller: editProfileControllers.bioController,
        obscureText: true,
        labelText: 'Bio',
      ),
    );
    editProfileFields.add(
      TextFieldModel(
        hintText: 'Enter your Location',
        showSuffix: true,
        prefixIcon: const Icon(Icons.location_on_outlined, color: iconColor),
        controller: editProfileControllers.locationController,
        obscureText: true,
        labelText: 'Location',
      ),
    );
    return editProfileFields;
  }
}