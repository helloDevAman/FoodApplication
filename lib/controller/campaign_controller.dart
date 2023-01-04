import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/response/basic_campaign_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/repository/campaign_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignController extends GetxController implements GetxService {
  final CampaignRepo campaignRepo;
  CampaignController({@required this.campaignRepo});

  List<BasicCampaignModel> _basicCampaignList;
  BasicCampaignModel _campaign;
  List<Product> _itemCampaignList;

  List<BasicCampaignModel> get basicCampaignList => _basicCampaignList;
  BasicCampaignModel get campaign => _campaign;
  List<Product> get itemCampaignList => _itemCampaignList;

  Future<void> getBasicCampaignList(bool reload) async {
    if(_basicCampaignList == null || reload) {
      Response response = await campaignRepo.getBasicCampaignList();
      if (response.statusCode == 200) {
        _basicCampaignList = [];
        response.body.forEach((campaign) => _basicCampaignList.add(BasicCampaignModel.fromJson(campaign)));
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  Future<void> getBasicCampaignDetails(int campaignID) async {
    _campaign = null;
    Response response = await campaignRepo.getCampaignDetails(campaignID.toString());
    if (response.statusCode == 200) {
      _campaign = BasicCampaignModel.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getItemCampaignList(bool reload) async {
    if(_itemCampaignList == null || reload) {
      Response response = await campaignRepo.getItemCampaignList();
      if (response.statusCode == 200) {
        _itemCampaignList = [];
        response.body.forEach((campaign) => _itemCampaignList.add(Product.fromJson(campaign)));
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

}