import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/admin_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/admin_inbox_screen.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/adminproductmodel.dart';
import '../../../provider/product_provider.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';

class AdminVisitStoreDetailPage extends StatefulWidget {
  const AdminVisitStoreDetailPage({super.key});

  @override
  State<AdminVisitStoreDetailPage> createState() =>
      _AdminVisitStoreDetailPageState();
}

class _AdminVisitStoreDetailPageState extends State<AdminVisitStoreDetailPage> {
  Future<void> _loadData() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .getadminProductList();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).getadminProductList();
    double sellerIconSize = 50;

    return Scaffold(
        appBar: const CustomAppBar(title: "Sajilo Nirman"),
        body: Consumer<ProductProvider>(
          builder: (context, adminProduct, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ////Container
                  Container(
                    margin:
                        const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                    padding: const EdgeInsets.fromLTRB(
                        Dimensions.paddingSizeSmall,
                        Dimensions.paddingSizeDefault,
                        Dimensions.paddingSizeSmall,
                        0),
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
                                    borderRadius:
                                        BorderRadius.circular(sellerIconSize),
                                    border: Border.all(
                                        width: .5,
                                        color: Theme.of(context).hintColor)),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(sellerIconSize),
                                    child: Image.asset(
                                        "assets/images/appicon.png"))),
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
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text("Sajilo Nirman",
                                            style: titilliumSemiBold.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeExtraLarge,
                                            )),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AdminInboxScreen()));

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
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(
                                              Dimensions.paddingSizeExtraSmall),
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).canvasColor,
                                              borderRadius: BorderRadius
                                                  .circular(Dimensions
                                                      .paddingSizeExtraSmall)),
                                          child: Image.asset(Images.chatImage,
                                              height:
                                                  Dimensions.iconSizeDefault))),
                                ]),
                                const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall,
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ///////////////

                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Products",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),

                  GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 0.6),
                      itemCount: adminProduct.adminProductList!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) {
                        return AdminProductWidget(
                            productModel:
                                adminProduct.adminProductList![index]);
                      })),
                ],
              ),
            );
          },
        ));
  }
}
