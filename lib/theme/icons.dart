import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChallengeIcons {
  ChallengeIcons._();

  static const IconData search = Icons.search;
  static const IconData energy = Icons.bolt;
  static const IconData energyOutlined = Icons.bolt_outlined;
  static const IconData critic = Icons.info_outlined;
  static const IconData asset = Symbols.deployed_code;
  static final SvgPicture component = SvgPicture.asset("assets/component.svg");
  static final SvgPicture company = SvgPicture.asset(
    "assets/company.svg",
    width: 24,
    height: 24,
  );
  static const IconData location = Icons.location_on_outlined;
  static const IconData back = Icons.arrow_back_ios;

  static final SvgPicture logo = SvgPicture.asset("assets/logo_tractian.svg");
}
