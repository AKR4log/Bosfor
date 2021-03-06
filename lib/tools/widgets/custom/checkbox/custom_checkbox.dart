import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final bool disabled;
  final double size;
  final ValueChanged<bool> onChanged;

  const AppCheckbox({
    Key key,
    this.size = 24,
    this.value = false,
    this.disabled = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backColor = disabled ? Colors.black12 : Colors.black26;
    final checkColor = disabled ? Colors.black54 : Colors.black;

    return Theme(
      data: Theme.of(context).copyWith(
        disabledColor: Colors.transparent,
        unselectedWidgetColor: Colors.transparent,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Container(
          decoration: BoxDecoration(
            color: backColor,
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.hardEdge,
          child: Transform.scale(
            scale: size / Checkbox.width,
            child: Checkbox(
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              activeColor: Colors.transparent,
              checkColor: checkColor,
              value: value,
              onChanged: disabled
                  ? null
                  : (value) {
                      onChanged(value);
                    },
            ),
          ),
        ),
      ),
    );
  }
}
