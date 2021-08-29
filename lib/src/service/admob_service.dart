import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:getx_map/src/screen/widget/loading_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';

var useTestId = true;

class AdmobBannerService {
  static AdmobBannerService get to => AdmobBannerService();

  static String get addID {
    if (Platform.isAndroid) {
      return "";
    } else if (Platform.isIOS) {
      return "ca-app-pub-9593268307163426~6137541784";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId1 {
    if (useTestId) {
      /// Test
      return Platform.isAndroid
          ? "ca-app-pub-3940256099942544/6300978111"
          : "ca-app-pub-3940256099942544/2934735716";
    } else {
      if (Platform.isAndroid) {
        return "";
      } else if (Platform.isIOS) {
        return FlutterConfig.get("BANNER_IOS");
      } else {
        throw new UnsupportedError("Unsupported platform");
      }
    }
  }

  Widget get myBannerAd {
    var bannerAd = BannerAd(
      adUnitId: bannerAdUnitId1,
      size: AdSize.banner,
      listener: bannerAdlistner,
      request: AdRequest(),
    )..load();

    return Container(
      color: Colors.yellow[50],
      margin: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      width: bannerAd.size.width.toDouble(),
      height: bannerAd.size.height.toDouble(),
      child: AdWidget(ad: bannerAd),
    );
  }

  BannerAdListener get bannerAdlistner {
    return BannerAdListener(
      onAdLoaded: (ad) => print("Banner Load"),
      onAdOpened: (ad) => print("Banner open"),
      onAdImpression: (Ad ad) => print('Ad impression.'),
      onAdClosed: (ad) => print("Bannar close"),
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        print("Banner failed");
        ad.dispose();
      },
    );
  }
}

class AdmobInterstialService extends GetxController {
  static AdmobInterstialService get to => Get.find();

  InterstitialAd? myInterstitialAd;
  int numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  AdmobInterstialService() {
    _createInterstitialAd();
  }

  static String get interstitialAdUnitId {
    if (useTestId) {
      /// Test
      return Platform.isAndroid
          ? "ca-app-pub-3940256099942544/1033173712"
          : "ca-app-pub-3940256099942544/4411468910";
    } else {
      if (Platform.isAndroid) {
        return "";
      } else if (Platform.isIOS) {
        return FlutterConfig.get("INSTESTIAL_IOS");
      } else {
        throw new UnsupportedError("Unsupported platform");
      }
    }
  }

  Future<void> showInterstitialAd(
      {bool useList = false, Function()? onDismissAd}) async {
    if (myInterstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }

    _addFullScreenContentCallback(onDismissAd);
    if (!useList) await _showLoadingAdDialog();
    myInterstitialAd!.show();
    myInterstitialAd = null;
  }

  void _createInterstitialAd() {
    var _ = InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          myInterstitialAd = ad;
          numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
          numInterstitialLoadAttempts += 1;
          myInterstitialAd = null;
          if (numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  Future<void> _showLoadingAdDialog() async {
    Get.defaultDialog(
        title: "",
        content: Column(
          children: [LoadingCellWidget(), Text("Loading....")],
        ));

    await Future.delayed(Duration(seconds: 1));
    if (Get.isDialogOpen!) Get.back();
  }

  void _addFullScreenContentCallback(Function()? onDismissAd) {
    myInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {},
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        if (onDismissAd != null) onDismissAd();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();

        _createInterstitialAd();
      },
      onAdImpression: (InterstitialAd ad) {},
    );
  }
}
