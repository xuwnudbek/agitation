import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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

extension ErrorBot on http.Response {
  void sendErrorToBot() async {
    if (this.statusCode > 299) {
      await http.post(
        Uri.parse("https://api.telegram.org/bot6405122016:AAHasH6NJbMRHg1JEKoP0EP6x2IYG-tT9uE/sendMessage"),
        body: {
          "chat_id": "5422334594",
          "text": "<b>Agitation</b>: ${this.statusCode}\n\n${this.body}\n\n <b>Datetime: </b> ${DateTime.now()}",
          "parse_mode": "HTML",
        },
      );
    }
  }
}

extension ErrorBot2 on http.StreamedResponse {
  void sendErrorToBot2() async {
    if (this.statusCode > 299) {
      await http.post(
        Uri.parse("https://api.telegram.org/bot6405122016:AAHasH6NJbMRHg1JEKoP0EP6x2IYG-tT9uE/sendMessage"),
        body: {
          "chat_id": "5422334594",
          "text": "<b>Agitation</b>: ${this.statusCode}\n\n${this.stream.bytesToString()}\n\n <b>Datetime: </b> ${DateTime.now()}",
          "parse_mode": "HTML",
        },
      );
    }
  }
}
