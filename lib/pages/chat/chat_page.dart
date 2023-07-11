import 'package:agitation/models/message.dart';
import 'package:agitation/pages/chat/provider/chat_provider.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/circlar_progress_indicator.dart';
import 'package:agitation/utils/widget/loading_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatProvider>(
        create: (_) => ChatProvider(),
        builder: (context, snapshot) {
          return Consumer<ChatProvider>(builder: (ctx, provider, _) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: HexToColor.fontBorderColor,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.support_agent_rounded, size: 30),
                    SizedBox(width: 5),
                    Text("Super Admin"),
                  ],
                ),
                centerTitle: true,
              ),
              floatingActionButton: _buildBottomForm(provider),
              floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
              body: Container(
                alignment: provider.isMsgUploading ? Alignment.center : Alignment.topCenter,
                padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 75),
                child: provider.isMsgUploading
                    ? CPIndicator()
                    : SingleChildScrollView(
                        reverse: true,
                        dragStartBehavior: DragStartBehavior.start,
                        controller: ScrollController(
                          initialScrollOffset: -10000,
                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: provider.messages.map((e) {
                            return _buildMsgCard(e);
                          }).toList(),
                        ),
                      ),
              ),
            );
          });
        });
  }

  Widget _buildMsgCard(Message msg) {
    return Align(
      alignment: msg.isAdmin == 1 ? Alignment.topLeft : Alignment.topRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: Get.width * .8),
        decoration: BoxDecoration(
          color: msg.isAdmin == 1 ? Colors.blue : HexToColor.fontBorderColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(msg.isAdmin == 1 ? 0 : 10),
            bottomRight: Radius.circular(msg.isAdmin == 1 ? 10 : 0),
          ),
        ),
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(7),
        child: Text(
          "${msg.text.trim()}",
          textAlign: msg.isAdmin == 1 ? TextAlign.start : TextAlign.end,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildBottomForm(ChatProvider provider) {
    return Container(
      width: Get.width - 30,
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
      decoration: BoxDecoration(
        color: HexToColor.fontBorderColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: TextFormField(
              controller: provider.msgController,
              style: TextStyle(color: Colors.white, fontSize: 16),
              autofocus: true,
              decoration: InputDecoration(
                hintText: "type_message".tr,
                hintStyle: TextStyle(color: Colors.white.withOpacity(.8)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
              ),
            ),
          ),
          provider.isLoading
              ? Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LoadingIndicator(color: Colors.white, size: 20),
                )
              : IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.white,
                  onPressed: () {
                    provider.addMsg();
                  },
                ),
        ],
      ),
    );
  }
}
