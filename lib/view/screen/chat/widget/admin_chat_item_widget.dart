import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/admin_chat_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/chat_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/provider/chat_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_image.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/chat_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/admin_chat_screen.dart';
import 'package:provider/provider.dart';

class AdminChatItemWidget extends StatefulWidget {
  final AdminChatViewModel? chat;
  final bool? isLast;
  final int? userid;
  const AdminChatItemWidget({Key? key, this.chat, this.isLast, this.userid})
      : super(key: key);

  @override
  State<AdminChatItemWidget> createState() => _AdminChatItemWidgetState();
}

class _AdminChatItemWidgetState extends State<AdminChatItemWidget> {
  String? baseUrl = '', image = '', call = '', name = '';
  int? id;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLast!) {
      return Container();
    }
    return Column(
      children: [
        ListTile(
            leading: Stack(
              children: [
                Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.25),
                            width: .5),
                        borderRadius: BorderRadius.circular(100)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CustomImage(
                            image: '$baseUrl/$image',
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover))),
              ],
            ),
            title: const Text("Sajilo Nirman", style: titilliumSemiBold),
            subtitle: Text(
                widget.chat!.newMessage != null
                    ? widget.chat!.newMessage ?? ''
                    : widget.chat!.message ?? '',
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall)),
            trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                      DateConverter.customTime(
                          DateTime.parse(widget.chat!.createdAt!)),
                      style: titilliumRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).hintColor)),
                  // CircleAvatar(
                  //   radius: 12,
                  //   backgroundColor: Theme.of(context).primaryColor,
                  //   child: Text('${widget.chat!.newMessage}',
                  //       style: textRegular.copyWith(
                  //           color: Colors.white,
                  //           fontSize: Dimensions.fontSizeSmall)),
                  // ),
                ]),
            onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => AdminChatScreen(image: '$baseUrl/$image',userid:widget.userid)));
            }),
        const Divider(height: 1, color: ColorResources.chatIconColor),
      ],
    );
  }
}
