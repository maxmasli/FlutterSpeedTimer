import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/widgets/color_picker_dialog.dart';
import 'package:speedtimer_flutter/theme/bloc/theme_bloc.dart';

class SetThemeDialog extends StatelessWidget {
  const SetThemeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ThemeBloc>();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ThemeTileWidget(
            text: "Primary color:",
            color: Theme.of(context).colorScheme.primary,
            onTap: () async {
              final newColor = await showDialog(
                  context: context,
                  builder: (_) {
                    return ColorPickerDialog(
                      initColor: Theme.of(context).colorScheme.primary,
                    );
                  });
              if (newColor != null) {
                bloc.add(ThemeSetPrimaryColorEvent(newColor));
              }
            },
          ),
          ThemeTileWidget(
              text: "Secondary color:",
              color: Theme.of(context).colorScheme.secondary,
              onTap: () async {
                final newColor = await showDialog(
                    context: context,
                    builder: (_) {
                      return ColorPickerDialog(
                        initColor: Theme.of(context).colorScheme.secondary,
                      );
                    });
                if (newColor != null) {
                  bloc.add(ThemeSetSecondaryColorEvent(newColor));
                }
              },
          ),
          ThemeTileWidget(
            text: "Text color:",
            color: Theme.of(context).textTheme.bodyMedium!.color!,
            onTap: () async {
              final newColor = await showDialog(
                  context: context,
                  builder: (_) {
                    return ColorPickerDialog(
                      initColor: Theme.of(context).textTheme.bodyMedium!.color!,
                    );
                  });
              if (newColor != null) {
                bloc.add(ThemeSetTextColorEvent(newColor));
              }
            },
          ),
        ],
      ),
    );
  }
}

class ThemeTileWidget extends StatelessWidget {
  const ThemeTileWidget(
      {Key? key, required this.text, required this.color, required this.onTap})
      : super(key: key);

  final String text;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium!
                    .color,
              ),
            ),
            ColoredCircleWidget(
              color: color,
            )
          ],
        ),
      ),
    );
  }
}

class ColoredCircleWidget extends StatelessWidget {
  const ColoredCircleWidget({Key? key, required this.color}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          color: color,
          border: Border.all(color: Colors.black, width: 2)),
    );
  }
}
