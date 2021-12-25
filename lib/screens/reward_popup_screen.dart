import 'dart:async';
import 'dart:math';

import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/util.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class RewardPopupScreen extends StatefulWidget {
  final Habit habit;
  final bool isTutorial;

  const RewardPopupScreen({Key key, @required this.habit, this.isTutorial})
      : super(key: key);
  @override
  _RewardPopupScreenState createState() => _RewardPopupScreenState();
}

class _RewardPopupScreenState extends State<RewardPopupScreen>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  AnimationController _popupAnimController;
  AnimationController _finalRewardAnimController;
  Animation<double> _popupScaleAnimation;
  Animation<double> _popupSequence;
  List<Animation<Offset>> _slideUpAnimations = [];
  List<Animation<double>> _fadeInAnimations = [];
  final List<Reward> _shuffeledRewardList = [];
  List<Reward> _rewardList = [];

  final double _rewardPercentage = 1.0;
  final ContentController _contentController = Get.find<ContentController>();

  @override
  void initState() {
    _scrollController = ScrollController();
    _initializeAnimations();
    _cloneRewardsIntoShuffeledRewardList();
    //_addPercentageBasedEmptyRewards();
    _shuffeledRewardList.shuffle();
    _evaluateRewardVariable(_shuffeledRewardList.last);
    _popupAnimController.forward();

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animateRewardList();
    });
  }

  @override
  void dispose() {
    _popupAnimController.dispose();
    _finalRewardAnimController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _popupAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _finalRewardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _popupScaleAnimation = CurvedAnimation(
        parent: _popupAnimController, curve: Curves.elasticInOut);

    _popupSequence = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.2), weight: 1.0),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 1.0),
    ]).animate(
      CurvedAnimation(
          parent: _finalRewardAnimController,
          curve: const Interval(
            0.15,
            0.55,
            curve: Curves.ease,
          )),
    );

    _slideUpAnimations = [
      Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(
        CurvedAnimation(
            parent: _finalRewardAnimController,
            curve: const Interval(
              0.5,
              0.75,
              curve: Curves.ease,
            )),
      ),
      Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(
        CurvedAnimation(
            parent: _finalRewardAnimController,
            curve: const Interval(
              0.75,
              1,
              curve: Curves.ease,
            )),
      ),
    ];

    _fadeInAnimations = [
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _finalRewardAnimController,
            curve: const Interval(
              0.5,
              0.75,
              curve: Curves.ease,
            )),
      ),
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _finalRewardAnimController,
            curve: const Interval(
              0.75,
              1,
              curve: Curves.ease,
            )),
      ),
    ];
  }

  void _cloneRewardsIntoShuffeledRewardList() {
    _rewardList = widget.isTutorial
        ? _contentController
            .getTutorialRewardListByID(widget.habit.rewardIDReferences)
        : _contentController.getRewardListByID(widget.habit.rewardIDReferences);

    if (_rewardList.isEmpty) {
      final Reward _empty =
          Reward(name: 'motivational_message'.tr, isSelfRemoving: false);
      _shuffeledRewardList.add(_empty);
      return;
    }

    for (final Reward reward in _rewardList) {
      final Reward _rewardCopy = Reward(
          name: reward.name,
          id: reward.id,
          isSelfRemoving: reward.isSelfRemoving);
      _shuffeledRewardList.add(_rewardCopy);
    }
  }

  void _evaluateRewardVariable(Reward reward) {
    final RegExp _regExp = RegExp(regexPattern);
    if (!_regExp.hasMatch(reward.name)) return;

    final RegExpMatch _match = _regExp.firstMatch(reward.name);
    final String _result = _match.group(0);
    _result.trim();
    final List<String> _stringNumbers = _result.split("-");
    final List<int> _numbers = _stringNumbers.map((e) => int.parse(e)).toList();
    _numbers.sort();
    final Random _random = Random();
    int next(int min, int max) => min + _random.nextInt(max - min);

    final int _value = next(_numbers[0], _numbers[1]);

    final String _tempNewTitle =
        _shuffeledRewardList.last.name.replaceAll(_regExp, " $_value");

    _shuffeledRewardList.last.name = _tempNewTitle;
  }


  void _animateRewardList() {
    Timer(
      const Duration(seconds: 1),
      () async {
        await Future.forEach(_shuffeledRewardList, (Reward reward) async {
          final double _offset =
              (_shuffeledRewardList.indexOf(reward) + 1) * 100.0;

          await _scrollController.animateTo(_offset,
              duration: const Duration(milliseconds: 200), curve: Curves.ease);
        });

        await _finalRewardAnimController.forward();
      },
    );
  }

  void _checkIfRewardIsRemoving() {
    if (_shuffeledRewardList.isEmpty) return;
    if (!_shuffeledRewardList.last.isSelfRemoving) return;

    final Reward selfRemovingReward = _rewardList
        .singleWhere((element) => element.id == _shuffeledRewardList.last.id);
    widget.habit.rewardIDReferences.remove(selfRemovingReward.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundWhite.withOpacity(0.8),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: ScaleTransition(
            scale: _popupScaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: const Offset(3, 3),
                        blurRadius: 3)
                  ],
                  color: kBackGroundWhite),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 100,
                      child: ListWheelScrollView.useDelegate(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemExtent: 100,
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: _shuffeledRewardList.length,
                          builder: (context, index) => index ==
                                  (_shuffeledRewardList.length - 1)
                              ? ScaleTransition(
                                  scale: _popupSequence,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                    child: Neumorphic(
                                      style: kInactiveNeumorphStyle.copyWith(
                                          color: kDeepOrange),
                                      child: Container(
                                        height: 70,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: kLightOrange,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10),
                                          child: Center(
                                            child: Text(
                                              _shuffeledRewardList[index].name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(
                                                      color: kBackGroundWhite,
                                                      fontSize: 20),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Neumorphic(
                                    style: kInactiveNeumorphStyle.copyWith(
                                        color: kDeepOrange),
                                    child: Container(
                                      height: 70,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: kLightOrange,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 10),
                                        child: Center(
                                          child: Text(
                                            _shuffeledRewardList[index].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .button
                                                .copyWith(
                                                    color: kBackGroundWhite,
                                                    fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SlideTransition(
                      position: _slideUpAnimations[0],
                      child: FadeTransition(
                        opacity: _fadeInAnimations[0],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'streak_message'.trParams({
                              'streak':
                                  '${widget.isTutorial ? 1 : widget.habit.streak}'
                            }),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: kDeepOrange),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SlideTransition(
                      position: _slideUpAnimations[1],
                      child: FadeTransition(
                        opacity: _fadeInAnimations[1],
                        child: CustomNeumorphButton(
                          onPressed: () async {
                            _checkIfRewardIsRemoving();
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                            Get.back();
                          },
                          height: 56,
                          width: 56,
                          color: Colors.green[400],
                          child: const Icon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
