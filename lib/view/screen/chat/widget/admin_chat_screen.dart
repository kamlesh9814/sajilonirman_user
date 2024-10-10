import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/message_body.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/chat_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_image.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/paginated_list_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/chat_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/message_bubble.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' as foundation;

class AdminChatScreen extends StatefulWidget {
  // final int? id;
  // final String? name;
  // final bool isDelivery;
  final String? image;
  final int? userid;
  // final String? phone;
  const AdminChatScreen({Key? key, this.image, this.userid}) : super(key: key);

  @override
  State<AdminChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<AdminChatScreen> {
  final TextEditingController _controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool emojiPicker = false;

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false)
        .getAdminChatList(widget.userid!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ChatProvider>(context, listen: false)
        .getAdminChatList(widget.userid!);

    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<ChatProvider>(context, listen: false)
            .getAdminChatList(widget.userid!);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          titleSpacing: 0,
          elevation: 1,
          leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(CupertinoIcons.back,
                  color: Theme.of(context).textTheme.bodyLarge?.color)),
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            width: .5,
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(.125))),
                    height: 40,
                    width: 40,
                    child: CustomImage(image: widget.image ?? '')),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall),
                child: Text(
                  "Sajilo Nirman",
                  style: textRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
              ),
            ],
          ),
          // actions: widget.isDelivery? [InkWell(
          //   onTap: ()=> _launchUrl("tel:${widget.phone}"),
          //   child: Padding(
          //     padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          //     child: Container(
          //       decoration: BoxDecoration(
          //         color: Theme.of(context).primaryColor.withOpacity(.125),
          //         borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
          //         height: 35, width: 35,child: Padding(
          //           padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          //           child: Image.asset(Images.callIcon, color: Theme.of(context).primaryColor),
          //         )),
          //   ),
          // )]:[],
        ),
        body: Consumer<ChatProvider>(
            builder: (context, adminchatProvider, child) {
          return Column(children: [
            adminchatProvider.adminchatlists.isNotEmpty
                ? Expanded(
                    child: SingleChildScrollView(
                    controller: scrollController,
                    reverse: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      child: ListView.builder(
                        itemCount: adminchatProvider.adminchatlists.length,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 233, 230, 230),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text(
                                      adminchatProvider
                                          .adminchatlists[index].message
                                          .toString(),
                                      style: textMedium.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color!
                                              .withOpacity(0.5)),
                                      textDirection: TextDirection.ltr,
                                    ),
                                  ),
                                ],
                              ),
                              adminchatProvider
                                          .adminchatlists[index].newMessage ==
                                      null
                                  ? const SizedBox.shrink()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              border: Border.all(
                                                  color: Colors.blue)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: CustomImage(
                                              fit: BoxFit.cover,
                                              width: 40,
                                              height: 40,
                                              image: widget.image!,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 245, 226, 209),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text(
                                            adminchatProvider
                                                .adminchatlists[index]
                                                .newMessage
                                                .toString(),
                                            style: textMedium.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color!
                                                    .withOpacity(0.5)),
                                            textDirection: TextDirection.ltr,
                                          ),
                                        ),
                                      ],
                                    ),

                              // ListView.builder(
                              //     shrinkWrap: true,
                              //     physics: const NeverScrollableScrollPhysics(),
                              //     padding: EdgeInsets.zero,
                              //     itemCount:
                              //         adminchatProvider.adminchatlists.length,
                              //     itemBuilder: (context, subIndex) {
                              //       return MessageBubble(
                              //           message: adminchatProvider
                              //               .messageList[index][subIndex]);
                              //     })
                            ],
                          );
                        },
                      ),
                    ),
                  ))
                : const Expanded(
                    child: NoInternetOrDataScreen(isNoInternet: false)),

            // Bottom TextField

            Padding(
              padding: const EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault,
                  0,
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeDefault),
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: CustomTextField(
                            inputAction: TextInputAction.send,
                            showLabelText: false,
                            prefixIcon: Images.emoji,
                            // suffixIcon: Images.attachment,
                            onTap: () {
                              setState(() {
                                emojiPicker = false;
                              });
                            },
                            prefixOnTap: () {
                              setState(() {
                                emojiPicker = !emojiPicker;
                                FocusManager.instance.primaryFocus?.unfocus();
                              });
                            },
                            suffixOnTap: () {
                              // chatProvider.pickMultipleImage(false);
                            },
                            controller: _controller,
                            labelText: getTranslated('send_a_message', context),
                            hintText:
                                getTranslated('send_a_message', context))),
                    // chatProvider.isSendButtonActive
                    //     ? const Padding(
                    //         padding: EdgeInsets.only(
                    //             left: Dimensions.paddingSizeSmall),
                    //         child: Center(child: CircularProgressIndicator()),
                    //       )
                    //     :
                    InkWell(
                      onTap: () {
                        if (_controller.text.isEmpty) {
                        } else {
                          adminchatProvider
                              .sendMessagetoAdmin(
                                  widget.userid, _controller.text, 1, context)
                              .then((value) {
                            _controller.clear();
                            setState(() {});
                          });
                        }
                      },
                      child: adminchatProvider.adminmessagesendLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator()),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: Dimensions.paddingSizeSmall),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.paddingSizeSmall),
                                    border: Border.all(
                                        width: 2,
                                        color: Theme.of(context).hintColor)),
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      Dimensions.paddingSizeExtraExtraSmall,
                                      Dimensions.paddingSizeExtraExtraSmall,
                                      Dimensions.paddingSizeExtraExtraSmall,
                                      8),
                                  child: Image.asset(Images.send,
                                      color: Provider.of<ThemeProvider>(context)
                                              .darkTheme
                                          ? Colors.white
                                          : null),
                                )),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            if (emojiPicker)
              SizedBox(
                height: 250,
                child: EmojiPicker(
                  onBackspacePressed: () {
                    // Do something when the user taps the backspace button (optional)
                    // Set it to null to hide the Backspace-Button
                  },
                  textEditingController:
                      _controller, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                  config: Config(
                    columns: 7,
                    emojiSizeMax: 32 *
                        (foundation.defaultTargetPlatform == TargetPlatform.iOS
                            ? 1.30
                            : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    initCategory: Category.RECENT,
                    bgColor: const Color(0xFFF2F2F2),
                    indicatorColor: Colors.blue,
                    iconColor: Colors.grey,
                    iconColorSelected: Colors.blue,
                    backspaceColor: Colors.blue,
                    skinToneDialogBgColor: Colors.white,
                    skinToneIndicatorColor: Colors.grey,
                    enableSkinTones: true,
                    recentTabBehavior: RecentTabBehavior.RECENT,
                    recentsLimit: 28,
                    noRecents: const Text(
                      'No Recents',
                      style: TextStyle(fontSize: 20, color: Colors.black26),
                      textAlign: TextAlign.center,
                    ), // Needs to be const Widget
                    loadingIndicator:
                        const SizedBox.shrink(), // Needs to be const Widget
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    categoryIcons: const CategoryIcons(),
                    buttonMode: ButtonMode.MATERIAL,
                  ),
                ),
              ),
          ]);
        }),
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}
