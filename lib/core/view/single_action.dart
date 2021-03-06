import 'package:simpati/core/resources/res_color.dart';
import 'package:simpati/core/resources/res_text_style.dart';
import 'package:flutter/material.dart';

class SingleAction extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;

  const SingleAction(
    this.text,
    this.icon,
    this.onPressed, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(Object context) {
    return RaisedButton.icon(
      elevation: 2,
      onPressed: onPressed,
      color: ResColor.darkBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 32,
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: ResTextStyle.whiteTextButton16),
    );
  }
}
