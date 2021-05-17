import 'package:Marbit/util/private.dart';
import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:get/get.dart';

class AdController extends GetxController {
  static final bool hasPurchasedAdFree = false;

  InterstitialAd interstitialAd;
  int _interstitialCounter = 0;
  final int _interstitialInterval = 4;

  Future<void> initializeInterstitialAd() async {
    interstitialAd =
        InterstitialAd(unitId: PrivateConstants.releaseInterstitialAdID);
    await interstitialAd.load();
  }

  static Widget getAdaptiveBannerAd(BuildContext context) {
    if (hasPurchasedAdFree) return const SizedBox.shrink();

    return BannerAd(
      builder: (context, child) {
        return Container(
          color: Theme.of(context).backgroundColor,
          child: child,
        );
      },
      loading: Container(
        width: double.infinity,
        height: 60,
        child: Center(child: Text("loading".tr)),
      ),
      error: Container(
        width: double.infinity,
        height: 60,
        child: Center(child: Text('error'.tr)),
      ),
      unitId: PrivateConstants.releaseListViewBannerID,
      size: BannerSize.ADAPTIVE,
    );
  }

  static Widget getLargeBannerAd(BuildContext context) {
    if (hasPurchasedAdFree) return const SizedBox.shrink();
    return BannerAd(
      builder: (context, child) {
        return Container(
          color: Theme.of(context).backgroundColor,
          child: child,
        );
      },
      loading: Container(
          width: 320, height: 100, child: Center(child: Text("loading".tr))),
      error: Container(
          width: 320, height: 100, child: Center(child: Text('error'.tr))),
      unitId: PrivateConstants.releaseDetailScreenBannerID,
      size: BannerSize.LARGE_BANNER,
    );
  }

  Future<void> showInterstitialAd() async {
    if (hasPurchasedAdFree) return;

    _interstitialCounter++;
    if (_interstitialCounter < _interstitialInterval) return;

    // Load only if not loaded
    if (!interstitialAd.isAvailable) await interstitialAd.load();
    if (interstitialAd.isAvailable) {
      await interstitialAd.show();
      _interstitialCounter = 0;

      /// You can also load a new ad here, because the `show()` will
      /// only complete when the ad gets closed
      interstitialAd.load();
    }
  }
}
