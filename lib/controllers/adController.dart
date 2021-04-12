import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:get/get.dart';

class AdController extends GetxController {
  static final bool hasPurchasedAdFree = true;

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
      unitId: MobileAds.bannerAdTestUnitId,
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
      unitId: MobileAds.bannerAdTestUnitId,
      size: BannerSize.LARGE_BANNER,
    );
  }
}
