import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:get/get.dart';

class AdController extends GetxController {
  static BannerAd getAdaptiveBannerAd(BuildContext context) {
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
        child: Center(child: const Text("loading")),
      ),
      error: Container(
        width: double.infinity,
        height: 60,
        child: Center(child: const Text('error')),
      ),
      unitId: MobileAds.bannerAdTestUnitId,
      size: BannerSize.ADAPTIVE,
    );
  }

  static BannerAd getLargeBannerAd(BuildContext context) {
    return BannerAd(
      builder: (context, child) {
        return Container(
          color: Theme.of(context).backgroundColor,
          child: child,
        );
      },
      loading: Container(
          width: 320, height: 100, child: Center(child: const Text('loading'))),
      error: Container(
          width: 320, height: 100, child: Center(child: const Text('error'))),
      unitId: MobileAds.bannerAdTestUnitId,
      size: BannerSize.LARGE_BANNER,
    );
  }
}
