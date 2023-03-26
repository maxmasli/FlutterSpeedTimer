import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({Key? key, required this.initColor}) : super(key: key);

  final Color initColor;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color? currentColor;

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
          pickerColor: widget.initColor,
          onColorChanged: onColorChanged,
        ),
      ),
      actions: [
        OkButtonWidget(
            onTap: () => Navigator.of(context).pop(currentColor))
      ],
    );
  }
}

class OkButtonWidget extends StatelessWidget {
  const OkButtonWidget({Key? key, required this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(100))),
        child: Text(
          "OK",
          style:
              TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
        ),
      ),
    );
  }
}
