import 'package:flutter/foundation.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class SellerRepo {
  final DioClient? dioClient;
  SellerRepo({required this.dioClient});

  Future<ApiResponse> getSeller(String sellerId) async {
    try {
      final response = await dioClient!.get(AppConstants.sellerUri + sellerId);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print("catchblock");
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getMoreStore() async {
    try {
      final response = await dioClient!.get(AppConstants.moreStore);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> storeFollow(int shopId) async {
    try {
      final response = await dioClient!.post(AppConstants.baseUrl +
          AppConstants.storeFollowApi +
          shopId.toString());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print("catchblock");
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getQuestionanswer() async{

    try{
      final response = await dioClient!.get(AppConstants.baseUrl+AppConstants.getquestionanswer);
      return ApiResponse.withSuccess(response);

    }catch(e){
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));

    }

  }

  Future<ApiResponse> askQuestions(String? productName, String? addedBy, String userEmail, String text)async {
    try {
      final response = await dioClient!.post(AppConstants.baseUrl+
        AppConstants.askQuestionUri,
        data: {
          "message":text,
          "product_name":productName,
          "user_email":userEmail,
          "added_by":addedBy,
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  }

