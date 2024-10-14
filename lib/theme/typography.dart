import 'package:flutter/material.dart';

class ChallengeTypography {
  ChallengeTypography._();

  static TextStyle mediumSM({required Color color}) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle mediumLG({required Color color}) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle regularSM({required Color color}) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle regularLG({required Color color}) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }
}
