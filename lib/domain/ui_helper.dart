

import 'package:flutter/material.dart';

InputDecoration mFieldDecor({required String hint, required String heading, IconData ? mIcon, String? mprefixText}){
  return InputDecoration(
    hintText: hint,
     label: Text(heading),
          prefixIcon: mIcon != null ? Icon(mIcon) : null,
     prefixText: mprefixText,
     enabledBorder: OutlineInputBorder(
       borderRadius: BorderRadius.circular(21)
     ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(21)
      )
  );
}

Widget mSpacer({double mHeigt = 20.0, double mWidth = 11.0}){
  return SizedBox(
    height: mHeigt,
    width: mWidth,
  );
}