import 'package:agitation/pages/main_page/provider/main_page_provider.dart';
import 'package:agitation/utils/widget/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:provider/provider.dart';

import '../../utils/hex_to_color.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainProvider>(
      create: (context) => MainProvider(),
      child: Consumer<MainProvider>(builder: (context, provider, child) {
        
        return Scaffold(
          backgroundColor: HexToColor.mainColor,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(),
                  SvgPicture.asset("assets/images/agitation_icon.svg"),
                  // SizedBox(height: 200,),
                  Text(
                    "Agitation",
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "ORZU GRAND",
                    style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 20),
                  LoadingIndicator(
                    color: Colors.white,
                    size: 20,
                  )
                ],
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "v${provider.versionText}",
                    style: TextStyle(fontSize: 12, color: Colors.white38, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
