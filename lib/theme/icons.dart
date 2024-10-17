import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tractian_mobile_challenge/theme/colors.dart';

class ChallengeIcons {
  ChallengeIcons._();

  static SvgPicture company({Color? color, double? width, double? height}) {
    return SvgPicture.asset(
      "assets/company.svg",
      width: width,
      height: height,
      colorFilter:
          ColorFilter.mode(color ?? ChallengeColors.white, BlendMode.srcIn),
    );
  }

  static SvgPicture asset({Color? color, double? width, double? height}) {
    return SvgPicture.asset(
      "assets/asset.svg",
      width: width,
      height: height,
      colorFilter:
          ColorFilter.mode(color ?? ChallengeColors.white, BlendMode.srcIn),
    );
  }

  static SvgPicture component({Color? color, double? width, double? height}) {
    return SvgPicture.asset(
      "assets/component.svg",
      width: width,
      height: height,
      colorFilter:
          ColorFilter.mode(color ?? ChallengeColors.white, BlendMode.srcIn),
    );
  }

  static SvgPicture location({Color? color, double? width, double? height}) {
    return SvgPicture.asset(
      "assets/location.svg",
      width: width,
      height: height,
      colorFilter:
          ColorFilter.mode(color ?? ChallengeColors.white, BlendMode.srcIn),
    );
  }

  static SvgPicture energy({Color? color, double? width, double? height}) {
    return SvgPicture.asset(
      "assets/energy.svg",
      width: width,
      height: height,
      colorFilter:
          ColorFilter.mode(color ?? ChallengeColors.white, BlendMode.srcIn),
    );
  }

  static SvgPicture energyFilled(
      {Color? color, double? width, double? height}) {
    return SvgPicture.asset(
      "assets/energy_filled.svg",
      width: width,
      height: height,
      colorFilter:
          ColorFilter.mode(color ?? ChallengeColors.white, BlendMode.srcIn),
    );
  }

  static SvgPicture critical({Color? color, double? width, double? height}) {
    return SvgPicture.asset(
      "assets/critical.svg",
      width: width,
      height: height,
      colorFilter:
          ColorFilter.mode(color ?? ChallengeColors.white, BlendMode.srcIn),
    );
  }

  static const IconData back = Icons.arrow_back_ios;
  static const IconData noWifi = Icons.wifi_off_sharp;

  static final SvgPicture logo = SvgPicture.asset("assets/logo_tractian.svg");
}
