import 'package:flutter/material.dart';

import 'app_text.dart';

class RequiredLabel extends StatelessWidget {
  final String label;
  final bool required;

  RequiredLabel(this.label, this.required);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        AppText(
          label,
          '',

//          color: AppColors.blue,
        ),
        required
            ? Row(
                children: <Widget>[
                  SizedBox(width: 6),
                  AppText("","*",),
                ],
              )
            : Container(),
      ],
    );
  }
}
