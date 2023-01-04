import 'package:efood_multivendor/data/model/response/language_model.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext context}) {
    return AppConstants.languages;
  }
}
