import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class WalletRepo {
  final ApiClient apiClient;
  WalletRepo({@required this.apiClient});

  Future<Response> getWalletTransactionList(String offset) async {
    return await apiClient.getData('${AppConstants.WALLET_TRANSACTION_URL}?offset=$offset&limit=10');
  }

  Future<Response> getLoyaltyTransactionList(String offset) async {
    return await apiClient.getData('${AppConstants.LOYALTY_TRANSACTION_URL}?offset=$offset&limit=10');
  }

  Future<Response> pointToWallet({int point}) async {
    return await apiClient.postData(AppConstants.LOYALTY_POINT_TRANSFER_URL, {"point": point});
  }

}