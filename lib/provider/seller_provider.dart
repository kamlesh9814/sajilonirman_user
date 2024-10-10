import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/question_answer_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/auth_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/seller_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/model/more_store_model.dart';

import '../data/model/response/store_follow_model.dart';

class SellerProvider extends ChangeNotifier {
  final SellerRepo? sellerRepo;
  SellerProvider({required this.sellerRepo});

  bool isLoading = false;

  List<SellerModel> _orderSellerList = [];
  SellerModel? _sellerModel;

  List<SellerModel> get orderSellerList => _orderSellerList;
  SellerModel? get sellerModel => _sellerModel;

   initSeller(String sellerId, BuildContext context) async {
    print("sellerid" + sellerId.toString());
    _orderSellerList = [];
    ApiResponse apiResponse = await sellerRepo!.getSeller(sellerId);
    if (apiResponse.response != null) {
      print("Response: " + apiResponse.response!.data.toString());
      print("Status Code: " + apiResponse.response!.statusCode.toString());
    } else {
      print("Response is null.");
    }
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _orderSellerList = [];
      _orderSellerList.add(SellerModel.fromJson(apiResponse.response!.data));
      _sellerModel = SellerModel.fromJson(apiResponse.response!.data);
      log("Phone number is");
      log(_sellerModel!.seller!.phone!);
    }
    else {
      print("apiresponsenot200");
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  storeFollow(int? shopid, BuildContext context) async {
    try {
      ApiResponse apiResponse = await sellerRepo!.storeFollow(shopid!);
      if (apiResponse.response!.statusCode == 200) {
        log(apiResponse.response!.data.toString());

        // Assuming apiResponse.response!.data is already a Map<String, dynamic>
        Map<String, dynamic> jsonDecodeResponse = apiResponse.response!.data;

        StoreFollowModel storeFollowResponse =
            StoreFollowModel.fromJson(jsonDecodeResponse);

        if (storeFollowResponse != null) {
          showCustomSnackBarSuccess(storeFollowResponse.message, context);
        }
      } else {
        // Handle non-200 responses here
        showCustomSnackBar(
            "Failed to follow. Status code: ${apiResponse.response!.statusCode}",
            context);
      }
    } catch (e) {
      // Handle exceptions here
      showCustomSnackBar("An error occurred: $e", context);
    }
  }

  int shopMenuIndex = 0;
  void setMenuItemIndex(int index, {bool notify = true}) {
    debugPrint('===================index is ===> ${index.toString()}');
    shopMenuIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  List<MoreStoreModel> moreStoreList = [];
  Future<ApiResponse> getMoreStore() async {
    moreStoreList = [];
    isLoading = true;
    ApiResponse apiResponse = await sellerRepo!.getMoreStore();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      apiResponse.response?.data.forEach(
          (store) => moreStoreList.add(MoreStoreModel.fromJson(store)));
    } else {
      isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  List<QuestionAnswerListModel> questionanswerList = [];

  getQuestionAnswerList() async {
    try {
      ApiResponse apiResponse = await sellerRepo!.getQuestionanswer();
      if (apiResponse.response!.statusCode == 200 &&
          apiResponse.response!.data['data'] != null) {
        questionanswerList.clear();
        log("gjrhri..........................");
        apiResponse.response!.data['data'].forEach((questions) =>
            questionanswerList
                .add(QuestionAnswerListModel.fromJson(questions)));
      } else {
        log("response is not 200");
      }
    } catch (e) {
      print(e);
    }
  }

  askQuestion(String? productName, String? addedBy, String userEmail,
      String text, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      ApiResponse apiResponse =
          await sellerRepo!.askQuestions(productName, addedBy, userEmail, text);
      if (apiResponse.response!.statusCode == 200) {
      showCustomSnackBarSuccess(
            apiResponse.response!.data['message'], context);
      } else {
        showCustomSnackBar(apiResponse.response!.statusMessage, context);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
