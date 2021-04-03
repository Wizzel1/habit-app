import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/util.dart';

class RewardPopupScreen extends StatefulWidget {
  final List<Reward> rewardList;
  //TODO: get habit and calculate habitlevel if needed

  const RewardPopupScreen({Key key, @required this.rewardList})
      : super(key: key);
  @override
  _RewardPopupScreenState createState() => _RewardPopupScreenState();
}

class _RewardPopupScreenState extends State<RewardPopupScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  AnimationController _animController;
  Animation<double> _scaleAnimation;
  List<Reward> _shuffeledRewardList = [];

  final double rewardPercentage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    _scaleAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.elasticInOut);

    for (Reward reward in widget.rewardList) {
      _shuffeledRewardList.add(reward);
    }

    _addPercentageBasedEmptyRewards();

    _shuffeledRewardList.shuffle();

    _animController.forward();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animateRewardList();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addPercentageBasedEmptyRewards() {
    double totalRewards = _shuffeledRewardList.length / rewardPercentage;
    double badRewards = totalRewards - _shuffeledRewardList.length;

    for (var i = 0; i < badRewards; i++) {
      Reward _empty = Reward(name: "Keep going!", isSelfRemoving: false);
      _shuffeledRewardList.add(_empty);
    }
  }

  void animateRewardList() {
    Timer(
      Duration(seconds: 1),
      () {
        Future.forEach(_shuffeledRewardList, (reward) async {
          double offset = (_shuffeledRewardList.indexOf(reward) + 1) * 100.0;
          await _scrollController.animateTo(offset,
              duration: Duration(milliseconds: 200), curve: Curves.ease);
        });
      },
    );
  }

  void checkForOneTimeReward() {
    if (_shuffeledRewardList.isEmpty) return;
    if (_shuffeledRewardList.last.isSelfRemoving) {
      Reward selfRemovingReward = widget.rewardList
          .singleWhere((element) => element.id == _shuffeledRewardList.last.id);
      widget.rewardList.remove(selfRemovingReward);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kBackGroundWhite),
              height: 200,
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
                          builder: (context, index) => Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 10.0),
                            child: Container(
                              height: 70,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: kLightOrange,
                                borderRadius: BorderRadius.circular(20),
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
                    const Spacer(),
                    Container(
                      height: 60,
                      width: 60,
                      child: MaterialButton(
                        padding: const EdgeInsets.all(0),
                        elevation: 0,
                        color: Colors.green[400],
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          checkForOneTimeReward();
                          Navigator.of(context).pop();
                        },
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
