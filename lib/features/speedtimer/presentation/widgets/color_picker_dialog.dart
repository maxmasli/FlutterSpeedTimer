import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatelessWidget {
  ColorPickerDialog({Key? key, required this.initColor})
      : currentColor = initColor,
        super(key: key);

  final Color initColor;
  Color currentColor;

  void onColorChanged(Color newColor) {
    currentColor = newColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 20,
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: initColor,
          onColorChanged: onColorChanged,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(currentColor);
          },
          child: const Text("OK"),
        )
      ],
    );
  }
}
