import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/chat_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class ChatTypeButton extends StatelessWidget {
  final String? text;
  final int index;
  final int? userid;
  const ChatTypeButton(
      {Key? key, required this.text, required this.index, this.userid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chatProvider, _) {
      return InkWell(
        onTap: () {
          if (!chatProvider.isLoading && index != 2) {
            Provider.of<ChatProvider>(context, listen: false)
                .setUserTypeIndex(context, index);
          } else if (index == 2) {
            Provider.of<ChatProvider>(context, listen: false)
                .getAdminChatList(userid!);
          }
        },
        child: Consumer<ChatProvider>(
          builder: (context, chat, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeExtraSmall,
                  vertical: Dimensions.paddingSizeExtraSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(text!,
                      style: chat.userTypeIndex == index
                          ? robotoBold.copyWith(
                              color: Theme.of(context).primaryColor)
                          : textRegular.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.color)),
                  (chat.userTypeIndex == index && index == 0)
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: Dimensions.paddingSizeExtraSmall),
                          child: Container(
                              color: Theme.of(context).primaryColor,
                              height: 2,
                              width: 34),
                        )
                      : (chat.userTypeIndex == index && index == 1)
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  top: Dimensions.paddingSizeExtraSmall),
                              child: Container(
                                  color: Theme.of(context).primaryColor,
                                  height: 2,
                                  width: 75),
                            )
                          : (index == 2)
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: Dimensions.paddingSizeExtraSmall),
                                  child: Container(
                                      color: Theme.of(context).primaryColor,
                                      height: 2,
                                      width: 60),
                                )
                              : const Padding(
                                  padding: EdgeInsets.only(
                                      top: Dimensions.paddingSizeExtraSmall),
                                  child: SizedBox()),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
