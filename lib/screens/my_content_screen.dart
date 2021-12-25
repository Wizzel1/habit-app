import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/util.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MyContentScreen extends StatefulWidget {
  const MyContentScreen({Key? key}) : super(key: key);

  @override
  _MyContentScreenState createState() => _MyContentScreenState();
}

class _MyContentScreenState extends State<MyContentScreen>
    with SingleTickerProviderStateMixin {
  PageController? _pageController;
  final Duration _pageTransitionDuration = const Duration(milliseconds: 200);
  final Curve _pageTransitionCurve = Curves.ease;
  final int _pageTransitionDelta = 4;
  final double _pageTransitionOffset = 35;

  @override
  void initState() {
    _pageController = PageController(initialPage: 1);
    super.initState();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                children: [
                  _buildRewardList(context),
                  _buildHabitList(context),
                ],
              ),
            ),
            Positioned(
                bottom: (screenSize.height / 2) - 45,
                right: 0,
                child: const DrawerExtension(
                  color: kLightOrange,
                )),
          ],
        ),
      ),
    );
  }

  Column _buildHabitList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            flex: 2,
            child: Center(
              child: Column(
                children: [
                  const Icon(FontAwesomeIcons.angleUp, color: kDeepOrange),
                  Text(
                    'scroll_to_show_rewards'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: kDeepOrange),
                  ),
                ],
              ),
            )),
        Expanded(
          flex: 20,
          child: GetBuilder(
            id: "allHabitList",
            builder: (ContentController contentController) {
              return AnimationLimiter(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification) {
                      final offset = notification.metrics.pixels;
                      final delta = notification.dragDetails?.delta.dy;
                      if (delta == null) return true;
                      final bool reachedOffsetThreshold =
                          offset < -_pageTransitionOffset;
                      final bool reachedDeltaThreshold =
                          delta > _pageTransitionDelta;

                      if (reachedOffsetThreshold && reachedDeltaThreshold) {
                        _pageController!.animateToPage(0,
                            duration: _pageTransitionDuration,
                            curve: _pageTransitionCurve);
                      }
                    }
                    return false;
                  },
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: contentController.allHabitList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Habit tappedHabit =
                          contentController.allHabitList[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: AllHabitContainer(habit: tappedHabit),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      if (index % 4 == 0) {
                        return AdController.getBannerAdBuilder(context);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Column _buildRewardList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 20,
          child: GetBuilder(
            id: "allRewardList",
            builder: (ContentController controller) {
              return AnimationLimiter(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification) {
                      final offset = notification.metrics.pixels;
                      final delta = notification.dragDetails?.delta.dy;
                      if (delta == null) return true;
                      final bool reachedOffsetTreshhold =
                          offset < -_pageTransitionOffset;
                      final bool reachedDeltaTreshhold =
                          delta < -_pageTransitionDelta;

                      if (reachedOffsetTreshhold && reachedDeltaTreshhold) {
                        _pageController!.animateToPage(1,
                            duration: _pageTransitionDuration,
                            curve: _pageTransitionCurve);
                      }
                    }
                    return false;
                  },
                  child: ListView.separated(
                    reverse: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.allRewardList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Reward tappedReward =
                          controller.allRewardList[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: -50.0,
                          child: FadeInAnimation(
                            child: RewardContainer(
                              reward: tappedReward,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      if (index % 4 == 0) {
                        return AdController.getBannerAdBuilder(context);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Column(
              children: [
                Text(
                  'scroll_to_show_habits'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: kDeepOrange),
                ),
                const Icon(FontAwesomeIcons.angleDown, color: kDeepOrange),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
