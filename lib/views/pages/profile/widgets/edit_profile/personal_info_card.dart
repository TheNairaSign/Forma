import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/text_field_model.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/widgets/custom_text_field.dart';

class PersonalInfoCard extends ConsumerStatefulWidget {
  const PersonalInfoCard({super.key});

  @override
  ConsumerState<PersonalInfoCard> createState() => _PersonalInfoCardState();
}

class _PersonalInfoCardState extends ConsumerState<PersonalInfoCard> {
  List<TextFieldModel> editProfileFields = [];

  @override
  void initState() {
    super.initState();
    editProfileFields = TextFieldModel.editProfileTextFields(context, ref);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xffeeeef0),
        borderRadius: BorderRadius.circular(20),
        boxShadow: GlobalColors.boxShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(editProfileFields.length, (index) {
          final editProfileField = editProfileFields[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(editProfileField.labelText, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: GlobalColors.primaryBlue)),
                const SizedBox(height: 8),
                CustomTextField( fillColor: Colors.white, controller: editProfileField.controller, hintText: editProfileField.hintText),
              ],
            ),
          );
        }),
      ),
    );
  }
}