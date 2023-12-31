import 'package:agitation/pages/home/view/create_order/create_order_page.dart';
import 'package:agitation/pages/home/view/finished_order/finished_order_page.dart';
import 'package:agitation/pages/home/view/order/order_page.dart';
import 'package:agitation/pages/home/view/profile/profile_page.dart';
import 'package:agitation/pages/moderation/moderation_page.dart';
import 'package:agitation/pages/moderation/provider/moderation_provider.dart';
import 'package:flutter/material.dart';
import 'package:agitation/pages/home/provider/home_provider.dart';

import 'package:agitation/utils/widget/main_button_navigation_bar/main_button_navigation_bar.dart';
import 'package:provider/provider.dart';

import 'package:move_to_background/move_to_background.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> selectedPage = [
      OrderPage(),
      FinishedOrderPage(),
      CreateOrderPage(),
      ProfilePage(),
    ];

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ModerationProvider()),
      ],
      builder: (context, child) {
        return Consumer<HomeProvider>(builder: (context, provider, child) {
          return Consumer<ModerationProvider>(builder: (ctx, moderationProvider, _) {
            return moderationProvider.isModerated ?? false
                ? Scaffold(
                    body: selectedPage[provider.indexItem],
                    bottomNavigationBar: MainButtonNavigationBar(
                      onSelected: (value) => provider.onTab(value),
                    ),
                  )
                : ModerationPage();
          });
        });
      },
    );
  }
}
