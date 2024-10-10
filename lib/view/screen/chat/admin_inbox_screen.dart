import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/chat_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/admin_chat_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/chat_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/chat_type_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/inbox_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/search_inbox_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../provider/profile_provider.dart';

class AdminInboxScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const AdminInboxScreen({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  State<AdminInboxScreen> createState() => _AdminInboxScreenState();
}

class _AdminInboxScreenState extends State<AdminInboxScreen> {
  TextEditingController searchController = TextEditingController();

  late bool isGuestMode;
  String contactNumber = "9866311452";
  bool isAdmin = false;
  int? userId;
  int? index = 0;

  @override
  void initState() {
    isGuestMode =
        !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (!isGuestMode) {
      Provider.of<ChatProvider>(context, listen: false)
          .getChatList(context, 1, reload: false);
      userId = Provider.of<ProfileProvider>(context, listen: false)
          .userInfoModel!
          .id;
      Provider.of<ChatProvider>(context, listen: false)
          .getAdminChatList(userId!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("userIs is " + userId.toString());
    if (userId != null) {
      Provider.of<ChatProvider>(context, listen: false)
          .getAdminChatList(userId!);
    }

    return WillPopScope(
        onWillPop: () async {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const DashBoardScreen()));
          }

          return true;
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: getTranslated('inbox', context),
            isBackButtonExist: widget.isBackButtonExist,
            onBackPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const DashBoardScreen()));
              }
            },
          ),
          body: Column(children: [
            const SizedBox(height: 40),
            Expanded(
              child: isGuestMode
                  ? const NotLoggedInWidget()
                  : RefreshIndicator(onRefresh: () async {
                      searchController.clear();
                      await Provider.of<ChatProvider>(context, listen: false)
                          .getAdminChatList(userId!);
                    }, child:
                      //  isAdmin
                      // ?
                      Consumer<ChatProvider>(
                      builder: (context, adminchatProvider, child) {
                        return adminchatProvider.adminchatlists.isNotEmpty
                            ? ListView.builder(
                                itemCount:
                                    adminchatProvider.adminchatlists.length,
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (context, index) {
                                  bool isLast = index ==
                                      adminchatProvider.adminchatlists.length -
                                          1;
                                  // int? unseenmessagecount = 0;
                                  //  unseenmessagecount  = unseenmessagecount+adminchatProvider.adminchatlists[index].seenByCustomer;
                                  return AdminChatItemWidget(
                                      chat: adminchatProvider
                                          .adminchatlists[index],
                                      isLast: isLast,
                                      userid: userId);
                                },
                              )
                            : const NoInternetOrDataScreen(
                                isNoInternet: false,
                                message: 'no_conversion',
                                icon: Images.noInbox,
                              );
                      },
                    )),
            )

            ///
          ]),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 226, 209, 209),
                            offset: Offset(1, 3),
                            blurRadius: 3,
                            spreadRadius: 1)
                      ]),
                  child: const Text(
                    "Whatsapp Support",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(height: 6),
              FloatingActionButton(
                backgroundColor: Colors.green,
                tooltip: "Whatsapp support",
                onPressed: _openWhatsApp,
                child: const Icon(Icons.call, color: Colors.white),
              ),
            ],
          ),
        ));
  }

  void _openWhatsApp() async {
    final Uri whatsappUrl = Uri.parse('whatsapp://send?phone=$contactNumber');
    //  Uri.parse('https://wa.me/$contactNumber');
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }
}
