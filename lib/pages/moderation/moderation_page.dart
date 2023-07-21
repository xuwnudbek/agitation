import 'package:agitation/pages/moderation/provider/moderation_provider.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ModerationPage extends StatelessWidget {
  ModerationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ModerationProvider>(
      builder: (context, moderationProvider, child) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "assets/images/${moderationProvider.isLoading ? "check" : moderationProvider.isModerated ?? false ? "check" : "cross"}.svg",
                  width: 100,
                ),
                Text(
                  "${moderationProvider.isLoading ? "check_moderation" : moderationProvider.isModerated ?? false ? "moderated" : "not_moderated"}"
                      .tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () async {
                    await moderationProvider.checkModerationStatus();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: SizedBox.square(
                      dimension: 100,
                      child: Center(
                        child: moderationProvider.isLoading ? LoadingIndicator(color: HexToColor.fontBorderColor) : Text("refresh".tr),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
