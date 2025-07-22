import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CustomColorAdapter extends TypeAdapter<Color> {
  @override
  final typeId = 7;

  @override
  Color read(BinaryReader reader) {
    return Color(reader.readInt());
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeInt(obj.value);
  }
}
