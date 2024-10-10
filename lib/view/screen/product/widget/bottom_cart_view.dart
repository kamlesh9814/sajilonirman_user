import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/admin_inbox_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/adminvisitStoreDetail.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/response/cart_model.dart';
import '../../../../data/model/response/product_model.dart';
import '../../../../helper/price_converter.dart';
import '../../../../provider/product_details_provider.dart';
import '../../../../provider/seller_provider.dart';
import '../../chat/inbox_screen.dart';
import '../../shop/shop_screen.dart';
import 'admin_view.dart';

class BottomCartView extends StatefulWidget {
  final ProductDetailsModel? product;
  const BottomCartView({Key? key, required this.product}) : super(key: key);

  @override
  State<BottomCartView> createState() => _BottomCartViewState();
}

class _BottomCartViewState extends State<BottomCartView> {
  bool vacationIsOn = false;
  bool temporaryClose = false;

  @override
  void initState() {
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .initData(widget.product!, widget.product!.minimumOrderQty, context);
    Provider.of<SellerProvider>(context, listen: false)
        .initSeller(widget.product!.userId!.toString(), context);

    super.initState();

    if (widget.product != null &&
        widget.product!.seller != null &&
        widget.product!.seller!.shop!.vacationEndDate != null) {
      DateTime vacationDate =
          DateTime.parse(widget.product!.seller!.shop!.vacationEndDate!);
      DateTime vacationStartDate =
          DateTime.parse(widget.product!.seller!.shop!.vacationStartDate!);
      final today = DateTime.now();
      final difference = vacationDate.difference(today).inDays;
      final startDate = vacationStartDate.difference(today).inDays;

      if (difference >= 0 &&
          widget.product!.seller!.shop!.vacationStatus == 1 &&
          startDate <= 0) {
        vacationIsOn = true;
      } else {
        vacationIsOn = false;
      }
    }

    if (widget.product != null &&
        widget.product!.seller != null &&
        widget.product!.seller!.shop!.temporaryClose == 1) {
      temporaryClose = true;
    } else {
      temporaryClose = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<SellerProvider>(context, listen: false)
        .initSeller(widget.product!.userId!.toString(), context);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).hintColor,
              blurRadius: .5,
              spreadRadius: .1)
        ],
      ),
      child: Row(children: [
        // Expanded(
        //     flex: 3,
        //     child: Padding(
        //       padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        //       child: Stack(children: [
        //         GestureDetector(
        //             onTap: () {
        //               Navigator.of(context).push(MaterialPageRoute(
        //                   builder: (context) => const CartScreen()));
        //             },
        //             child: Image.asset(Images.cartArrowDownImage,
        //                 color: ColorResources.getPrimary(context))),
        //         Positioned(
        //           top: 0,
        //           right: 10,
        //           child:
        //               Consumer<CartProvider>(builder: (context, cart, child) {
        //             return Container(
        //               height: 17,
        //               width: 17,
        //               alignment: Alignment.center,
        //               decoration: BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 color: ColorResources.getPrimary(context),
        //               ),
        //               child: Text(
        //                 cart.cartList.length.toString(),
        //                 style: titilliumSemiBold.copyWith(
        //                     fontSize: Dimensions.fontSizeExtraSmall,
        //                     color: Theme.of(context).highlightColor),
        //               ),
        //             );
        //           }),
        //         )
        //       ]),
        //     )),
        //shop button

        widget.product!.addedBy == "admin"
            ? Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraSmall),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AdminVisitStoreDetailPage()));
                  },
                  child: Column(
                    children: [
                      SizedBox(
                          width: 30,
                          child: Image.asset(Images.storeIcon,
                              color: Theme.of(context).primaryColor)),
                      const Text("Shop",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ))
            : widget.product!.addedBy == "seller"
                ? Consumer<SellerProvider>(builder: (context, seller, child) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraSmall),
                        child: InkWell(
                          onTap: () {
                            seller.sellerModel != null
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TopSellerProductScreen(
                                            sellerId:
                                                seller.sellerModel?.seller?.id,
                                            temporaryClose: seller.sellerModel
                                                ?.seller?.shop?.temporaryClose,
                                            vacationStatus: seller.sellerModel
                                                ?.seller?.shop?.vacationStatus,
                                            vacationEndDate: seller.sellerModel
                                                ?.seller?.shop?.vacationEndDate,
                                            vacationStartDate: seller
                                                .sellerModel
                                                ?.seller
                                                ?.shop
                                                ?.vacationStartDate,
                                            name: seller.sellerModel?.seller
                                                ?.shop?.name,
                                            banner: seller.sellerModel?.seller
                                                ?.shop?.banner,
                                            image: seller.sellerModel?.seller
                                                ?.shop?.image)))
                                : null;
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                  width: 30,
                                  child: Image.asset(Images.storeIcon,
                                      color: Theme.of(context).primaryColor)),
                              const Text("Shop",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ));
                  })
                : const SizedBox.shrink(),
        //shop button end

        //chat....

        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeExtraSmall),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => widget.product!.addedBy == "admin"
                        ? const AdminInboxScreen()
                        : const InboxScreen(),
                  ),
                );
              },
              child: Column(
                children: [
                  SizedBox(
                      height: 32,
                      width: 30,
                      child: Image.asset(Images.chatImage,
                          height: Dimensions.iconSizeDefault,
                          color: Theme.of(context).primaryColor)),
                  const Text("Chat",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            )),

        //chat button end

        //buy now
        Consumer<ProductDetailsProvider>(builder: (ctx, details, child) {
          String? colorWiseSelectedImage = '';

          if (widget.product != null &&
              widget.product!.colorImage != null &&
              widget.product!.colorImage!.isNotEmpty) {
            for (int i = 0; i < widget.product!.colorImage!.length; i++) {
              if (widget.product!.colorImage![i].color ==
                  '${widget.product!.colors?[details.variantIndex ?? 0].code?.substring(1, 7)}') {
                colorWiseSelectedImage =
                    widget.product!.colorImage![i].imageName;
              }
            }
          }

          Variation? variation;
          String? variantName = (widget.product!.colors != null &&
                  widget.product!.colors!.isNotEmpty)
              ? widget.product!.colors![details.variantIndex!].name
              : null;
          List<String> variationList = [];
          for (int index = 0;
              index < widget.product!.choiceOptions!.length;
              index++) {
            variationList.add(widget.product!.choiceOptions![index]
                .options![details.variationIndex![index]]
                .trim());
          }
          String variationType = '';
          if (variantName != null) {
            variationType = variantName;
            for (var variation in variationList) {
              variationType = '$variationType-$variation';
            }
          } else {
            bool isFirst = true;
            for (var variation in variationList) {
              if (isFirst) {
                variationType = '$variationType$variation';
                isFirst = false;
              } else {
                variationType = '$variationType-$variation';
              }
            }
          }

          double? price = widget.product!.unitPrice;
          int? stock = widget.product!.currentStock;
          variationType = variationType.replaceAll(' ', '');
          for (Variation variation in widget.product!.variation!) {
            if (variation.type == variationType) {
              price = variation.price;
              variation = variation;
              stock = variation.qty;
              break;
            }
          }

          double priceWithDiscount = PriceConverter.convertWithDiscount(context,
              price, widget.product!.discount, widget.product!.discountType)!;
          double priceWithQuantity = priceWithDiscount * details.quantity!;

          double total = 0, avg = 0;
          for (var review in widget.product!.reviews!) {
            total += review.rating!;
          }
          avg = total / widget.product!.reviews!.length;
          String ratting = widget.product!.reviews != null &&
                  widget.product!.reviews!.isNotEmpty
              ? avg.toString()
              : "0";

          CartModelBody cart = CartModelBody(
            productId: widget.product!.id,
            variant: (widget.product!.colors != null &&
                    widget.product!.colors!.isNotEmpty)
                ? widget.product!.colors![details.variantIndex!].name
                : '',
            color: (widget.product!.colors != null &&
                    widget.product!.colors!.isNotEmpty)
                ? widget.product!.colors![details.variantIndex!].code
                : '',
            variation: variation,
            quantity: details.quantity,
          );
          return Expanded(
              flex: 5,
              child: InkWell(
                onTap: () {
                  stock! < widget.product!.minimumOrderQty! &&
                          widget.product!.productType == "physical"
                      ? null
                      : stock >= widget.product!.minimumOrderQty! ||
                              widget.product!.productType == "digital"
                          ? Provider.of<CartProvider>(context, listen: false)
                              .addToCartAPI(
                              cart,
                              context,
                              widget.product!.choiceOptions!,
                              details.variationIndex,
                            )
                              .then((value) {
                              if (value.response!.statusCode == 200) {
                                _navigateToNextScreen(context);
                              }
                            })
                          : const SizedBox.shrink();
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffFE961C)),
                  child: Text(
                    getTranslated('buy_now', context)!,
                    style: titilliumSemiBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color:
                            Provider.of<ThemeProvider>(context, listen: false)
                                    .darkTheme
                                ? Theme.of(context).hintColor
                                : Theme.of(context).highlightColor),
                  ),
                ),
              ));

          //buy now end
        }),

        Expanded(
            flex: 5,
            child: InkWell(
              onTap: () {
                if (vacationIsOn || temporaryClose) {
                  showCustomSnackBar(
                      getTranslated('this_shop_is_close_now', context), context,
                      isToaster: true);
                } else {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0),
                      builder: (con) => CartBottomSheet(
                            product: widget.product,
                            callback: () {
                              showCustomSnackBar(
                                  getTranslated('added_to_cart', context),
                                  context,
                                  isError: false);
                            },
                          ));
                }
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  getTranslated('add_to_cart', context)!,
                  style: titilliumSemiBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Provider.of<ThemeProvider>(context, listen: false)
                              .darkTheme
                          ? Theme.of(context).hintColor
                          : Theme.of(context).highlightColor),
                ),
              ),
            )),
      ]),
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const CartScreen()));
  }
}
