import 'dart:async';
import 'dart:math';
import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/util.dart';
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
  List<Reward> _shuffeledRewardList = [];
  List<Reward> _rewardList = [];

  final double _rewardPercentage = 0.5;
  final ContentController _contentController = Get.find<ContentController>();

  @override
  void initState() {
    _scrollController = ScrollController();
    _initializeAnimations();
    _cloneRewardsIntoShuffeledRewardList();
    _addPercentageBasedEmptyRewards();
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
          curve: Interval(
            0.15,
            0.55,
            curve: Curves.ease,
          )),
    );

    _slideUpAnimations = [
      Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(
        CurvedAnimation(
            parent: _finalRewardAnimController,
            curve: Interval(
              0.5,
              0.75,
              curve: Curves.ease,
            )),
      ),
      Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(
        CurvedAnimation(
            parent: _finalRewardAnimController,
            curve: Interval(
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
            curve: Interval(
              0.5,
              0.75,
              curve: Curves.ease,
            )),
      ),
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _finalRewardAnimController,
            curve: Interval(
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

    for (Reward reward in _rewardList) {
      Reward _rewardCopy = Reward(
          name: reward.name,
          description: reward.description,
          id: reward.id,
          isSelfRemoving: reward.isSelfRemoving);
      _shuffeledRewardList.add(_rewardCopy);
    }
  }

  void _evaluateRewardVariable(Reward reward) {
    RegExp regExp = RegExp(r"\b[0-9 0-9]+[-]+[0-9 0-9]\b");

    if (regExp.hasMatch(reward.name)) {
      RegExpMatch match = regExp.firstMatch(reward.name);
      String result = match.group(0);
      result.trim();
      List<String> stringNumbers = result.split("-");
      List<int> numbers = stringNumbers.map((e) => int.parse(e)).toList();

      Random _random = Random();
      int next(int min, int max) => min + _random.nextInt(max - min);

      int value = next(numbers[0], numbers[1]);

      String newTitle = _shuffeledRewardList.last.name
          .replaceAll(regExp, " " + value.toString());

      _shuffeledRewardList.last.name = newTitle;
    }
  }

  void _addPercentageBasedEmptyRewards() {
    double totalRewards = _shuffeledRewardList.length /
        (widget.isTutorial ? 1.0 : _rewardPercentage);
    double badRewards = totalRewards - _shuffeledRewardList.length;

    for (var i = 0; i < badRewards; i++) {
      //TODO translate
      Reward _empty = Reward(name: "Keep going!", isSelfRemoving: false);
      _shuffeledRewardList.add(_empty);
    }
  }

  void _animateRewardList() {
    Timer(
      Duration(seconds: 1),
      () async {
        await Future.forEach(_shuffeledRewardList, (reward) async {
          double _offset = (_shuffeledRewardList.indexOf(reward) + 1) * 100.0;

          await _scrollController.animateTo(_offset,
              duration: Duration(milliseconds: 200), curve: Curves.ease);
        });

        await _finalRewardAnimController.forward();
      },
    );
  }

  void _checkIfRewardIsRemoving() {
    if (_shuffeledRewardList.isEmpty) return;
    if (!_shuffeledRewardList.last.isSelfRemoving) return;

    Reward selfRemovingReward = _rewardList
        .singleWhere((element) => element.id == _shuffeledRewardList.last.id);
    widget.habit.rewardIDReferences.remove(selfRemovingReward.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundWhite.withOpacity(0.5),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: ScaleTransition(
            scale: _popupScaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kBackGroundWhite),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 100,
                      child: ListWheelScrollView.useDelegate(
                        physics: NeverScrollableScrollPhysics(),
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
                                    child: Container(
                                      height: 70,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: kLightOrange,
                                        borderRadius: BorderRadius.circular(10),
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
                                )
                              : Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  child: Container(
                                    height: 70,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: kLightOrange,
                                      borderRadius: BorderRadius.circular(10),
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
                    const SizedBox(height: 30),
                    SlideTransition(
                      position: _slideUpAnimations[0],
                      child: FadeTransition(
                        opacity: _fadeInAnimations[0],
                        child: Text(
                          'streak_message'
                              .trParams({'streak': '${widget.habit.streak}'}),
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: kDeepOrange),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SlideTransition(
                      position: _slideUpAnimations[1],
                      child: FadeTransition(
                        opacity: _fadeInAnimations[1],
                        child: NeumorphPressSwitch(
                          onPressed: () async {
                            _checkIfRewardIsRemoving();
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                            Get.back();
                          },
                          height: 56,
                          width: 56,
                          color: Colors.green[400],
                          child: Icon(
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
