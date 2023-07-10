import 'package:agitation/pages/moderation/provider/moderation_provider.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/circlar_progress_indicator.dart';
import 'package:agitation/utils/widget/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ModerationPage extends StatelessWidget {
  const ModerationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ModerationProvider>(
        create: (context) => ModerationProvider(),
        builder: (context, snapshot) {
          return Consumer<ModerationProvider>(builder: (ctx, provider, _) {
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        "assets/images/cross.svg",
                        width: 100,
                      ),
                      Text(
                        "not_moderated".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 7),
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          provider.checkModerationStatus();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: SizedBox.square(
                            dimension: 100,
                            child: Center(
                              child: provider.isLoading ? LoadingIndicator(color: HexToColor.fontBorderColor) : Text("refresh".tr),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
