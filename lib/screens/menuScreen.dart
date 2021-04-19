import 'package:Marbit/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_funding_choices/flutter_funding_choices.dart';
import 'package:get/get.dart';

class MenuScreen extends StatelessWidget {
  final NavigationController navigationController =
      Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: () {
                navigationController.navigateToIndex(0);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                child: Text(
                  'today_habits_menutitle'.tr,
                  style: Theme.of(context).textTheme.button,
                ),
              )),
          InkWell(
              onTap: () {
                navigationController.navigateToIndex(1);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                child: Text(
                  'create_new_menutitle'.tr,
                  style: Theme.of(context).textTheme.button,
                ),
              )),
          InkWell(
              onTap: () {
                navigationController.navigateToIndex(2);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                child: Text(
                  'my_content_menutitle'.tr,
                  style: Theme.of(context).textTheme.button,
                ),
              )),
          InkWell(
              onTap: () async {
                ConsentInformation consentInfo =
                    await FlutterFundingChoices.requestConsentInformation();
                //TODO add IOS consent
                if (consentInfo.isConsentFormAvailable &&
                    consentInfo.consentStatus == ConsentStatus.OBTAINED) {
                  await FlutterFundingChoices.showConsentForm();
                  // You can check the result by calling `FlutterFundingChoices.requestConsentInformation()` again !
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                child: Text(
                  'my_content_menutitle'.tr,
                  style: Theme.of(context).textTheme.button,
                ),
              )),
        ],
      ),
    );
  }
}
