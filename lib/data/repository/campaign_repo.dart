import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class CampaignRepo {
  final ApiClient apiClient;
  CampaignRepo({@required this.apiClient});

  Future<Response> getBasicCampaignList() async {
    return await apiClient.getData(AppConstants.BASIC_CAMPAIGN_URI);
  }

  Future<Response> getCampaignDetails(String campaignID) async {
    return await apiClient.getData('${AppConstants.BASIC_CAMPAIGN_DETAILS_URI}$campaignID');
  }

  Future<Response> getItemCampaignList() async {
    return await apiClient.getData(AppConstants.ITEM_CAMPAIGN_URI);
  }

}