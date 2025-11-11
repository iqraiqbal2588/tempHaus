import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final TextDecoration decoration;
  final FontStyle fontStyle;
  final double heightBetween;
  final List<Shadow>? shadows; // Optional shadow parameter

  const CustomText({
    Key? key,
    required this.text,
    this.fontSize = 14.0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.decoration = TextDecoration.none,
    this.fontStyle = FontStyle.normal,
    this.heightBetween = 1.0,
    this.shadows, // Optional shadow parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.jost(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        decoration: decoration,
        fontStyle: fontStyle,
        height: heightBetween,
        shadows: shadows, // Apply shadow if provided
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
