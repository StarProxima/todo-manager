import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvgIcons extends StatelessWidget {
  const AppSvgIcons(this.icon, {Key? key, this.color}) : super(key: key);
  final AppSvgIcon icon;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/${icon.name}.svg',
      color: color,
    );
  }
}

enum AppSvgIcon {
  important,
  low,
}
