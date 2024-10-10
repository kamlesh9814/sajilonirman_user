import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/user_info_model.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/shimmer/product_details_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/admin_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/promise_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/review_section.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/seller_view.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/bottom_cart_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_image_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_specification_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_title_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/related_product_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/youtube_video_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/shop/widget/shop_product_view_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../../provider/auth_provider.dart';
import '../../../provider/cart_provider.dart';
import '../../../provider/splash_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/images.dart';
import '../../basewidget/not_logged_in_bottom_sheet.dart';
import '../cart/cart_screen.dart';
import '../compare/controller/compare_controller.dart';
import 'widget/favourite_button.dart';

class ProductDetails extends StatefulWidget {
  final int? productId;
  final String? slug;
  final bool isFromWishList;
  const ProductDetails(
      {Key? key,
      required this.productId,
      required this.slug,
      this.isFromWishList = false})
      : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  _loadData(BuildContext context) async {
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getProductDetails(context, widget.slug.toString());
    Provider.of<SellerProvider>(context, listen: false).getQuestionAnswerList();
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .removePrevReview();
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .initProduct(widget.productId, widget.slug, context);
    Provider.of<ProductProvider>(context, listen: false)
        .removePrevRelatedProduct();
    Provider.of<ProductProvider>(context, listen: false)
        .initRelatedProductList(widget.productId.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getCount(widget.productId.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getSharableLink(widget.slug.toString(), context);
  }

  List<TextEditingController> _questioncontrollers = [];

  @override
  void initState() {
    _questioncontrollers.add(TextEditingController(text: ''));

    _loadData(context);
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _questioncontrollers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool isReview = false;
  bool isQA = false;
  bool isSpecification = true;
  TextEditingController questionasked = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Provider.of<SellerProvider>(context, listen: false).getQuestionAnswerList();
    UserInfoModel userUserInfoModel =
        Provider.of<ProfileProvider>(context, listen: false).userInfoModel!;
    String? email = userUserInfoModel.email ?? '';

    ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Details",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CartScreen())),
              icon: Stack(clipBehavior: Clip.none, children: [
                Image.asset(
                  Images.cartArrowDownImage,
                  height: Dimensions.iconSizeDefault,
                  width: Dimensions.iconSizeDefault,
                  color: Colors.white,
                  // ColorResources.getPrimary(context)
                ),
                Positioned(
                  top: -4,
                  right: -4,
                  child:
                      Consumer<CartProvider>(builder: (context, cart, child) {
                    return CircleAvatar(
                      radius: 7,
                      backgroundColor: ColorResources.red,
                      child: Text(cart.cartList.length.toString(),
                          style: titilliumSemiBold.copyWith(
                            color: ColorResources.white,
                            fontSize: Dimensions.fontSizeExtraSmall,
                          )),
                    );
                  }),
                ),
              ]),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(context),
        child: Consumer<ProductDetailsProvider>(
          builder: (context, details, child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: !details.isDetails
                  ? Column(
                      children: [
                        ProductImageView(
                            productModel: details.productDetailsModel),
                        // favourite and rating
                        /////////

                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ProductTitleView(
                                      productModel: details.productDetailsModel,
                                      averageRatting: details
                                                  .productDetailsModel
                                                  ?.averageReview !=
                                              null
                                          ? details.productDetailsModel!
                                              .averageReview
                                          : "0"),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeDefault),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          isSpecification = true;
                                          isReview = false;
                                          isQA = false;
                                        });
                                      },
                                      child: Column(children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeDefault,
                                              vertical:
                                                  Dimensions.paddingSizeSmall),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(Dimensions
                                                      .paddingSizeExtraSmall),
                                              color: !isReview && !isQA
                                                  ? Provider.of<ThemeProvider>(
                                                              context,
                                                              listen: false)
                                                          .darkTheme
                                                      ? Theme.of(context)
                                                          .hintColor
                                                          .withOpacity(.25)
                                                      : Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(.05)
                                                  : Colors.transparent),
                                          child: Text(
                                            '${getTranslated('specification', context)}',
                                            style: textRegular.copyWith(
                                                color:
                                                    Provider.of<ThemeProvider>(
                                                                context,
                                                                listen: false)
                                                            .darkTheme
                                                        ? Theme.of(context)
                                                            .hintColor
                                                        : Theme.of(context)
                                                            .primaryColor),
                                          ),
                                        ),
                                        if (!isReview && !isQA)
                                          Container(
                                            width: 60,
                                            height: 3,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )
                                      ])),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeDefault),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isReview = true;
                                        isQA = false;
                                        isSpecification = false;
                                      });
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Column(children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeDefault,
                                                vertical: Dimensions
                                                    .paddingSizeSmall),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(Dimensions
                                                        .paddingSizeExtraSmall),
                                                color: isReview
                                                    ? Provider.of<ThemeProvider>(
                                                                context,
                                                                listen: false)
                                                            .darkTheme
                                                        ? Theme.of(context)
                                                            .hintColor
                                                            .withOpacity(.25)
                                                        : Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(.05)
                                                    : Colors.transparent),
                                            child: Text(
                                              '${getTranslated('reviews', context)}',
                                              style: textRegular.copyWith(
                                                  color:
                                                      Provider.of<ThemeProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .darkTheme
                                                          ? Theme.of(context)
                                                              .hintColor
                                                          : Theme.of(context)
                                                              .primaryColor),
                                            ),
                                          ),
                                          if (isReview)
                                            Container(
                                                width: 60,
                                                height: 3,
                                                color: Theme.of(context)
                                                    .primaryColor)
                                        ]),
                                        Positioned(
                                          top: -10,
                                          right: -10,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Center(
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .paddingSizeDefault),
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: Dimensions
                                                            .paddingSizeExtraSmall,
                                                        horizontal: Dimensions
                                                            .paddingSizeSmall),
                                                    child: Text(
                                                      '${details.reviewList != null ? details.reviewList!.length : 0}',
                                                      style: textRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeLarge),

                                  //QA
                                  // details.productDetailsModel!.addedBy ==
                                  //         "seller"
                                  //     ?
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          isSpecification = false;
                                          isReview = false;
                                          isQA = true;
                                        });
                                      },
                                      child: Column(children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeDefault,
                                              vertical:
                                                  Dimensions.paddingSizeSmall),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(Dimensions
                                                      .paddingSizeExtraSmall),
                                              color: !isReview &&
                                                      !isSpecification
                                                  ? Provider.of<ThemeProvider>(
                                                              context,
                                                              listen: false)
                                                          .darkTheme
                                                      ? Theme.of(context)
                                                          .hintColor
                                                          .withOpacity(.25)
                                                      : Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(.05)
                                                  : Colors.transparent),
                                          child: Text(
                                            "Q & A",
                                            // '${getTranslated('specification', context)}',
                                            style: textRegular.copyWith(
                                                color:
                                                    Provider.of<ThemeProvider>(
                                                                context,
                                                                listen: false)
                                                            .darkTheme
                                                        ? Theme.of(context)
                                                            .hintColor
                                                        : Theme.of(context)
                                                            .primaryColor),
                                          ),
                                        ),
                                        if (isQA)
                                          Container(
                                            width: 60,
                                            height: 3,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )
                                      ]))
                                  // : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                            ///////
                            // details.productDetailsModel!.addedBy == 'admin'
                            //     ? const Text("admin product")
                            //     : const Text("seller product"),

                            isReview
                                ? ReviewSection(details: details)
                                : isSpecification
                                    ? Column(
                                        children: [
                                          (details.productDetailsModel
                                                          ?.details !=
                                                      null &&
                                                  details.productDetailsModel!
                                                      .details!.isNotEmpty)
                                              ? Container(
                                                  height: 250,
                                                  margin: const EdgeInsets.only(
                                                      top: Dimensions
                                                          .paddingSizeSmall),
                                                  padding: const EdgeInsets.all(
                                                      Dimensions
                                                          .paddingSizeSmall),
                                                  child: ProductSpecification(
                                                      productSpecification: details
                                                              .productDetailsModel!
                                                              .details ??
                                                          ''),
                                                )
                                              : const SizedBox(),
                                          details.productDetailsModel
                                                      ?.videoUrl !=
                                                  null
                                              ? YoutubeVideoWidget(
                                                  url: details
                                                      .productDetailsModel!
                                                      .videoUrl)
                                              : const SizedBox(),
                                          (details.productDetailsModel !=
                                                      null &&
                                                  details.productDetailsModel!
                                                          .addedBy ==
                                                      'seller')
                                              ?

                                              // (details.productDetailsModel != null)
                                              SellerView(
                                                  // sellerphonenumber:
                                                  isFollowing: details
                                                      .productDetailsModel!
                                                      .isFollowing,
                                                  followCount: details
                                                      .productDetailsModel!
                                                      .followCounts,
                                                  slug: widget.slug,
                                                  sellerId: details
                                                      .productDetailsModel!
                                                      .userId
                                                      .toString())
                                              : (details.productDetailsModel !=
                                                          null &&
                                                      details.productDetailsModel!
                                                              .addedBy ==
                                                          'admin')
                                                  ? const AdminView()
                                                  : const SizedBox.shrink(),
                                          // Text("jfidh"),
                                          Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: Dimensions
                                                          .paddingSizeDefault),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .cardColor),
                                              child: const PromiseScreen()),
                                          (details.productDetailsModel !=
                                                      null &&
                                                  details.productDetailsModel!
                                                          .addedBy ==
                                                      'seller')
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: Dimensions
                                                          .paddingSizeDefault),
                                                  child: TitleRow(
                                                      title: getTranslated(
                                                          'more_from_the_shop',
                                                          context),
                                                      isDetailsPage: true),
                                                )
                                              : const SizedBox(),
                                          details.productDetailsModel!
                                                      .addedBy ==
                                                  'seller'
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeDefault),
                                                  child: ShopProductViewList(
                                                      scrollController:
                                                          scrollController,
                                                      sellerId: details
                                                          .productDetailsModel!
                                                          .userId!))
                                              : const SizedBox(),
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    vertical: Dimensions
                                                        .paddingSizeExtraSmall),
                                                child: TitleRow(
                                                    title: getTranslated(
                                                        'related_products',
                                                        context),
                                                    isDetailsPage: true),
                                              ),
                                              const SizedBox(height: 5),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeDefault),
                                                child: RelatedProductView(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    :

                                    ///forQA
                                    Consumer<SellerProvider>(
                                        builder: (context, value, child) {
                                          return value
                                                  .questionanswerList.isNotEmpty
                                              ? Container(
                                                  alignment: Alignment.topLeft,
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 10, 0, 30),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                          "Questions & Answers",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16)),

                                                      // Text(details
                                                      //         .productDetailsModel!
                                                      //         .name ??
                                                      //     ''),
                                                      const SizedBox(
                                                          height: 20),

                                                      ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemCount: value
                                                              .questionanswerList
                                                              .length,
                                                          itemBuilder:
                                                              ((context,
                                                                  index) {
                                                            return value
                                                                        .questionanswerList[
                                                                            index]
                                                                        .replyMessage ==
                                                                    null
                                                                ? const SizedBox
                                                                    .shrink()
                                                                : Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Card(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Text("Q.${index + 1}", style: TextStyle(fontWeight: FontWeight.bold)),
                                                                                const SizedBox(width: 8),
                                                                                Text(value.questionanswerList[index].message ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 6),
                                                                            value.questionanswerList[index].replyMessage == null
                                                                                ? const SizedBox.shrink()
                                                                                : Row(
                                                                                    children: [
                                                                                      const Text("Ans."),
                                                                                      const SizedBox(width: 8),
                                                                                      Text(value.questionanswerList[index].replyMessage ?? ''),
                                                                                    ],
                                                                                  ),
                                                                            // const SizedBox(
                                                                            //     height:
                                                                            //         20),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                          }))
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox.shrink();
                                        },
                                      ),
                            ////////////////
                            ///Ask Questions
                            Container(
                                margin: const EdgeInsets.all(14.0),
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Ask Question/s",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        Row(
                                          children: [
                                            InkWell(
                                                onTap: _addQuestion,
                                                child: CircleAvatar(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    radius: 12,
                                                    child: const Icon(Icons.add,
                                                        size: 16,
                                                        color: Colors.white))),
                                            const SizedBox(width: 10),
                                            InkWell(
                                                onTap: _removeQuestion,
                                                child: const CircleAvatar(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 249, 148, 33),
                                                    radius: 12,
                                                    child: Icon(Icons.remove,
                                                        size: 16,
                                                        color: Colors.white)))
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _questioncontrollers.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20.0),
                                            child: CustomTextField(
                                                controller:
                                                    _questioncontrollers[index],
                                                labelText: "Q.${index + 1}"),
                                          );
                                        }),
                                    const SizedBox(height: 20),
                                    CustomButton(
                                        buttonText: Provider.of<SellerProvider>(
                                          context,
                                        ).isLoading
                                            ? "Processing"
                                            : "Submit",
                                        onTap: () async {
                                          List<String> questions =
                                              _questioncontrollers
                                                  .map((controller) =>
                                                      controller.text)
                                                  .toList();
                                          String questionsString = questions
                                              .where((question) =>
                                                  question.isNotEmpty)
                                              .join(',');
                                          print("Questions.............");
                                          print(questionsString);
                                          bool isAnyQuestion = questions.any(
                                              (question) => question.isEmpty);
                                          String? productName =
                                              details.productDetailsModel!.name;
                                          String? addedBy = details
                                              .productDetailsModel!.addedBy;
                                          print("productName   $productName");
                                          print("addedBy   $addedBy");

                                          String? userEmail = email;

                                          if (isAnyQuestion) {
                                            showCustomSnackBar(
                                                "Question field is empty",
                                                context);
                                          } else {
                                            await Provider.of<SellerProvider>(
                                                    context,
                                                    listen: false)
                                                .askQuestion(
                                                    productName,
                                                    addedBy,
                                                    userEmail,
                                                    questionsString,
                                                    context);
                                            // _questioncontrollers.clear();
                                          }
                                        })
                                  ],
                                ))

                            ////////
                          ],
                        ),
                      ],
                    )
                  : const ProductDetailsShimmer(),
            );
          },
        ),
      ),
      bottomNavigationBar:
          Consumer<ProductDetailsProvider>(builder: (context, details, child) {
        return !details.isDetails
            ? BottomCartView(product: details.productDetailsModel)
            : const SizedBox();
      }),
    );
  }

  void _addQuestion() {
    setState(() {
      _questioncontrollers.add(TextEditingController());
    });
  }

  void _removeQuestion() {
    if (_questioncontrollers.length > 1) {
      setState(() {
        _questioncontrollers.removeLast();
      });
    }
  }
}
