import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DropdownButtonUI extends StatelessWidget {
  const DropdownButtonUI(
      {super.key,
      required this.choices,
      required this.currentValue,
      required this.onChanged});

  final List<String> choices;
  final String currentValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            elevation: 0,
            icon: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                child: Text(
                  "↓",
                  style: Theme.of(context).textTheme.labelMedium,
                )),
            items: choices.map<DropdownMenuItem<String>>((dynamic value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Text(value,
                      style: Theme.of(context).textTheme.labelMedium),
                ),
              );
            }).toList(),
            value: currentValue,
            onChanged: (value) {
              onChanged(value!);
            }),
      ),
    );
  }
}
