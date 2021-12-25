import 'package:Marbit/util/private.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:native_admob_flutter/native_admob_flutter.dart';

class AdController extends GetxController {
  static const bool hasPurchasedAdFree = false;

  late InterstitialAd interstitialAd;
  int _interstitialCounter = 0;
  final int _interstitialInterval = 4;

  Future<void> initializeInterstitialAd() async {
    // interstitialAd =
    //     InterstitialAd(unitId: PrivateConstants.releaseInterstitialAdID);
    // await interstitialAd.load();
  }

  static Widget getBannerAdBuilder(BuildContext context) {
    if (hasPurchasedAdFree) return const SizedBox.shrink();
    final size = MediaQuery.of(context).size;
    final BannerAd myBanner = BannerAd(
      adUnitId: PrivateConstants.releaseListViewBannerID,
      size: AdSize.getInlineAdaptiveBannerAdSize(size.width.toInt() - 20, 50),
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );

    return FutureBuilder(
        future: myBanner.load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return AdWidget(ad: myBanner);
          }
        });
  }

  static Widget getLargeBannerAd(BuildContext context) {
    if (hasPurchasedAdFree) return const SizedBox.shrink();

    final BannerAd myBanner = BannerAd(
      adUnitId: PrivateConstants.releaseDetailScreenBannerID,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );

    return RepaintBoundary(
      child: FutureBuilder(
          future: myBanner.load(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return AdWidget(ad: myBanner);
            }
          }),
    );

    // if (hasPurchasedAdFree) return const SizedBox.shrink();

    // return RepaintBoundary(
    //   child: BannerAd(
    //     builder: (context, child) {
    //       return Container(
    //         color: Theme.of(context).backgroundColor,
    //         child: child,
    //       );
    //     },
    //     loading: SizedBox(
    //         width: 320, height: 100, child: Center(child: Text("loading".tr))),
    //     error: const SizedBox.shrink(),
    //     unitId: PrivateConstants.releaseDetailScreenBannerID,
    //     size: BannerSize.LARGE_BANNER,
    //   ),
    // );
  }

  Future<void> showInterstitialAd() async {
    // if (hasPurchasedAdFree) return;

    // _interstitialCounter++;
    // if (_interstitialCounter < _interstitialInterval) return;

    // // Load only if not loaded
    // if (!interstitialAd.isAvailable) await interstitialAd.load();
    // if (interstitialAd.isAvailable) {
    //   await interstitialAd.show();
    //   _interstitialCounter = 0;

    //   /// You can also load a new ad here, because the `show()` will
    //   /// only complete when the ad gets closed
    //   interstitialAd.load();
    // }
  }
}
