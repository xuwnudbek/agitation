import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:agitation/pages/verification/provider/verification_provider.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/number_panel.dart';
import 'package:provider/provider.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VerificationProvider>(
      create: (context) => VerificationProvider(),
      child: Consumer<VerificationProvider>(builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
              child: provider.isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: HexToColor.mainColor),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(),
                        const SizedBox(height: 20),
                        SvgPicture.asset("assets/images/logo.svg"),
                        const SizedBox(height: 10),
                        Spacer(),
                        Column(
                          children: [
                            Text(
                              "Введите код из смс",
                              style: TextStyle(
                                color: HexToColor.mainColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Отправили на номер:",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InputField(
                                  active: provider.input[0]['active'],
                                  text: provider.input[0]['number'],
                                ),
                                InputField(
                                  active: provider.input[1]['active'],
                                  text: provider.input[1]['number'],
                                ),
                                InputField(
                                  active: provider.input[2]['active'],
                                  text: provider.input[2]['number'],
                                ),
                                InputField(
                                  active: provider.input[3]['active'],
                                  text: provider.input[3]['number'],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Отправить повторно через:   00 : ${provider.getTimer()}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        NumberPanel(
                          onPressed: (value) {
                            if (value != "*" && value != '-') {
                              provider.onPressedNumber(value);
                            } else if (value == '-') {
                              provider.onPressedBackspace();
                            }
                          },
                        )
                      ],
                    )),
        );
      }),
    );
  }
}

class InputField extends StatelessWidget {
  InputField({
    super.key,
    required this.active,
    required this.text,
  });
  bool active;
  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 40,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(border: Border.all(color: HexToColor.mainColor), borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: text != ""
            ? Text(
                text,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            : Visibility(
                visible: active,
                child: Container(
                  width: 2,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.black),
                ),
              ),
      ),
    );
  }
}
