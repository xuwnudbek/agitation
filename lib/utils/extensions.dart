import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;
import 'package:get/get.dart';

extension Badges on Widget {
  Widget withBadge(BuildContext context, {bool showBadge = false}) {
    return badge.Badge(
      showBadge: showBadge,
      badgeStyle: badge.BadgeStyle(
        badgeColor: Colors.transparent,
      ),
      badgeContent: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.red,
        ),
        child: SizedBox(
          width: 7,
          height: 7,
        ).marginOnly(right: 10, top: 10),
      ),
      child: this,
    );
  }
}
