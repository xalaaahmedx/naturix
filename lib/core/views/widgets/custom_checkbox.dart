import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:naturix/core/views/widgets/space.dart';

import '../../../../core/config/app_theme.dart';

class CustomCheckBox extends StatefulWidget {
  String? label;
  bool value;
  ValueChanged<bool?> onChanged;

  CustomCheckBox(
      {Key? key, required this.value, required this.onChanged, this.label = ''})
      : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: const BorderSide(color: AppTheme.neutral400, width: 1.25),
          activeColor: AppTheme.neutral900,
          value: widget.value,
          onChanged: (value) {
            setState(() {
              widget.value = value!;
            });
            widget.onChanged.call(value);
            widget.onChanged;
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
        ),
        Space(
          width: 2.w,
        ),
        Text(widget.label!)
      ],
    );
  }
}
