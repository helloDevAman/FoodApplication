import 'dart:async';
import 'dart:io';
import 'dart:collection';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/screens/checkout/widget/payment_failed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  final OrderModel orderModel;
  PaymentScreen({@required this.orderModel});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedUrl;
  double value = 0.0;
  bool _isLoading = true;
  PullToRefreshController pullToRefreshController;
  MyInAppBrowser browser;

  @override
  void initState() {
    super.initState();
    selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?customer_id=${widget.orderModel.userId}&order_id=${widget.orderModel.id}';

    _initData();
  }

  void _initData() async {
    browser = MyInAppBrowser(orderID: widget.orderModel.id.toString(), orderAmount: widget.orderModel.orderAmount);

    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

      bool swAvailable = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      bool swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController = AndroidServiceWorkerController.instance();
        await serviceWorkerController.setServiceWorkerClient(AndroidServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            print(request);
            return null;
          },
        ));
      }
    }

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.black,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          browser.webViewController.reload();
        } else if (Platform.isIOS) {
          browser.webViewController.loadUrl(urlRequest: URLRequest(url: await browser.webViewController.getUrl()));
        }
      },
    );
    browser.pullToRefreshController = pullToRefreshController;

    await browser.openUrlRequest(
      urlRequest: URLRequest(url: Uri.parse(selectedUrl)),
      options: InAppBrowserClassOptions(
        inAppWebViewGroupOptions: InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions(useShouldOverrideUrlLoading: true, useOnLoadResource: true)),
        crossPlatform: InAppBrowserOptions(hideUrlBar: true, hideToolbarTop: GetPlatform.isAndroid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBar(title: 'payment'.tr, onBackPressed: () => _exitApp()),
        body: Center(
          child: Container(
            width: Dimensions.WEB_MAX_WIDTH,
            child: Stack(
              children: [
                _isLoading ? Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                ) : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _exitApp() async {
    return Get.dialog(PaymentFailedDialog(orderID: widget.orderModel.id.toString()));
  }

}

class MyInAppBrowser extends InAppBrowser {
  final String orderID;
  final double orderAmount;
  MyInAppBrowser({@required this.orderID, @required this.orderAmount, int windowId, UnmodifiableListView<UserScript> initialUserScripts})
      : super(windowId: windowId, initialUserScripts: initialUserScripts);

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    print("\n\nBrowser Created!\n\n");
  }

  @override
  Future onLoadStart(url) async {
    print("\n\nStarted: $url\n\n");
    _redirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    print("\n\nStopped: $url\n\n");
    _redirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    print("Can't load [$url] Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    print("Progress: $progress");
  }

  @override
  void onExit() {
    if(_canRedirect) {
      Get.dialog(PaymentFailedDialog(orderID: orderID));
    }
    print("\n\nBrowser closed!\n\n");
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    print("\n\nOverride ${navigationAction.request.url}\n\n");
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(response) {
    print("Started at: " + response.startTime.toString() + "ms ---> duration: " + response.duration.toString() + "ms " + (response.url ?? '').toString());
  }

  @override
  void onConsoleMessage(consoleMessage) {
    print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
  }

  void _redirect(String url) {
    if(_canRedirect) {
      bool _isSuccess = url.contains(AppConstants.BASE_URL + '/payment-success');
      bool _isFailed = url.contains(AppConstants.BASE_URL + '/payment-fail');
      bool _isCancel = url.contains(AppConstants.BASE_URL + '/payment-cancel');
      if (_isSuccess || _isFailed || _isCancel) {
        _canRedirect = false;
        close();
      }
      if (_isSuccess) {
        Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID, 'success', orderAmount));
      } else if (_isFailed || _isCancel) {
        Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID, 'fail', orderAmount));
      }
    }
  }

}