import 'dart:ui';

import 'package:hive/hive.dart';

/// An adapter to be able to store Color with Hive
class ColorAdapter extends TypeAdapter<Color> {
  @override
  final typeId = 9;

  @override
  Color read(BinaryReader reader) => Color(reader.readUint32());

  @override
  void write(BinaryWriter writer, Color obj) => writer.writeUint32(obj.value);
}
