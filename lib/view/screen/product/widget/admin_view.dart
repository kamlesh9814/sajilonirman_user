import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_image.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/not_logged_in_bottom_sheet.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/rating_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/admin_inbox_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/chat_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/adminvisitStoreDetail.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/shop/shop_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdminView extends StatefulWidget {
  // final String sellerId;
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  @override
  void initState() {
    // Provider.of<SellerProvider>(context, listen: false)
    //     .initSeller(widget.sellerId, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sellerIconSize = 50;
    // Provider.of<SellerProvider>(context, listen: false)
    //     .initSeller(widget.sellerId, context);
    return Container(
      margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,
          Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, 0),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: sellerIconSize,
                  height: sellerIconSize,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sellerIconSize),
                      border: Border.all(
                          width: .5, color: Theme.of(context).hintColor)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(sellerIconSize),
                      child: Image.asset("assets/images/appicon.png"))),
              const SizedBox(
                width: Dimensions.paddingSizeSmall,
              ),
              Expanded(
                child: Column(children: [
                  Row(children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("Sajilo Nirman",
                              style: titilliumSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeExtraLarge,
                              )),
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>AdminInboxScreen()));
                        },
                        // if (!Provider.of<AuthProvider>(context,
                        //         listen: false)
                        //     .isLoggedIn()) {
                        //   showModalBottomSheet(
                        //       context: context,
                        //       builder: (_) =>
                        //           const NotLoggedInBottomSheet());
                        // } else if (seller.sellerModel != null) {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (_) => ChatScreen(
                        //                 id: seller.sellerModel!
                        //                     .seller!.id,
                        //                 name: seller.sellerModel!
                        //                     .seller!.shop!.name,
                        //               )));
                        // }

                        child: Container(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeExtraSmall)),
                            child: Image.asset(Images.chatImage,
                                height: Dimensions.iconSizeDefault))),
                  ]),
                  const SizedBox(
                    height: Dimensions.paddingSizeExtraSmall,
                  ),
                ]),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeDefault,
                horizontal: Dimensions.paddingSizeLarge),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const AdminVisitStoreDetailPage()));
              },
              // WidgetsBinding.instance.addPersistentFrameCallback((_){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => TopSellerProductScreen(
              //             sellerId:
              //                 seller.sellerModel?.seller?.id,
              //             temporaryClose: seller.sellerModel
              //                 ?.seller?.shop?.temporaryClose,
              //             vacationStatus: seller.sellerModel
              //                 ?.seller?.shop?.vacationStatus,
              //             vacationEndDate: seller.sellerModel
              //                 ?.seller?.shop?.vacationEndDate,
              //             vacationStartDate: seller.sellerModel
              //                 ?.seller?.shop?.vacationStartDate,
              //             name: seller
              //                 .sellerModel?.seller?.shop?.name,
              //             banner: seller
              //                 .sellerModel?.seller?.shop?.banner,
              //             image: seller.sellerModel?.seller?.shop
              //                 ?.image))),

              // }),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                    color: ColorResources.visitShop(context),
                    borderRadius: BorderRadius.circular(
                        Dimensions.paddingSizeExtraSmall)),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraSmall),
                        child: SizedBox(
                            width: 20,
                            child: Image.asset(Images.storeIcon,
                                color: Theme.of(context).primaryColor))),
                    Text(
                      getTranslated('visit_store', context)!,
                      style: titleRegular.copyWith(
                          color:
                              Provider.of<ThemeProvider>(context, listen: false)
                                      .darkTheme
                                  ? Theme.of(context).hintColor
                                  : Theme.of(context).primaryColor),
                    ),
                  ],
                )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
