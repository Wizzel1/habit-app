import 'dart:async';

import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:Marbit/screens/screens.dart';

class RewardDetailScreen extends StatefulWidget {
  final Reward reward;

  const RewardDetailScreen({Key key, this.reward}) : super(key: key);
  @override
  _RewardDetailScreenState createState() => _RewardDetailScreenState();
}

class _RewardDetailScreenState extends State<RewardDetailScreen>
    with TickerProviderStateMixin {
  bool _isInEditMode = false;
  TextEditingController _titleController;
  TextEditingController _descriptionController;

  AnimationController _editAnimController;
  Animation<Offset> _titleOffset;
  Animation<Offset> _descriptionOffset;

  final Completer _screenBuiltCompleter = Completer();
  final int _mainScreenAnimationDuration = 200;
  final TutorialController _tutorialController = Get.find<TutorialController>();
  final ContentController _contentController = Get.find<ContentController>();

  @override
  void initState() {
    _editAnimController = AnimationController(vsync: this);

    _titleController = TextEditingController(text: widget.reward.name);
    _descriptionController =
        TextEditingController(text: widget.reward.description);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        300.milliseconds.delay().then(
          (value) {
            _screenBuiltCompleter.complete();
            _initializeAnimations();

            (_mainScreenAnimationDuration + 100).milliseconds.delay().then(
              (value) {
                setState(() {});
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _editAnimController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _titleOffset = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0, 0), end: const Offset(0.0, offset)),
          weight: 10.0),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, offset), end: const Offset(0, 0)),
          weight: 20.0),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, 0.0), end: const Offset(0, 0)),
          weight: 70.0)
    ]).animate(
      CurvedAnimation(
        parent: _editAnimController,
        curve: const Interval(
          0.0,
          0.4,
          curve: Curves.ease,
        ),
      ),
    );

    _descriptionOffset = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0, 0), end: const Offset(0.0, offset)),
          weight: 10.0),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, offset), end: const Offset(0, 0)),
          weight: 20.0),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, 0.0), end: const Offset(0, 0)),
          weight: 70.0)
    ]).animate(
      CurvedAnimation(
        parent: _editAnimController,
        curve: const Interval(
          0.05,
          0.45,
          curve: Curves.ease,
        ),
      ),
    );
  }

  Future<void> _toggleEditingAnimation() async {
    _editAnimController.isAnimating
        ? _editAnimController.reset()
        : _editAnimController.repeat(period: const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "all${widget.reward.id}",
      child: Scaffold(
        backgroundColor: kLightOrange,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: FutureBuilder(
          future: _screenBuiltCompleter.future,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return const SizedBox.shrink();
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: AnimationConfiguration.toStaggeredList(
                    duration:
                        Duration(milliseconds: _mainScreenAnimationDuration),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      const SizedBox(height: 30),
                      _buildTitleTextField(),
                      _buildDescriptionTextField(),
                      const SizedBox(height: 30),
                      Center(
                        child: _buildEditButton(onPressed: () {
                          if (_isInEditMode) {
                            FocusScope.of(context).unfocus();
                            Get.find<ContentController>().updateReward(
                                rewardID: widget.reward.id,
                                newTitle: _titleController.text,
                                newDescription: _descriptionController.text,
                                isSelfRemoving: widget.reward.isSelfRemoving);
                          }
                          _toggleEditingAnimation();
                        }),
                      ),
                      const SizedBox(height: 30),
                      _buildChangeSelfRemovingOption(),
                      const SizedBox(height: 30),
                      AdController.getLargeBannerAd(context),
                      const SizedBox(height: 30),
                      Center(child: _buildRewardDeleteButton()),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChangeSelfRemovingOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MaterialButton(
          elevation: 0,
          color: widget.reward.isSelfRemoving ? kDeepOrange : kBackGroundWhite,
          child: Container(
            height: 50,
            width: 75,
            child: Center(
              child: Text(
                "One Time",
                style: Theme.of(context).textTheme.button.copyWith(
                    color: widget.reward.isSelfRemoving
                        ? kBackGroundWhite
                        : Theme.of(context).accentColor),
              ),
            ),
          ),
          height: 50,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            setState(() {
              widget.reward.isSelfRemoving = true;
            });
          },
        ),
        MaterialButton(
          elevation: 0,
          color: widget.reward.isSelfRemoving ? kBackGroundWhite : kDeepOrange,
          child: Container(
            height: 50,
            width: 75,
            child: Center(
              child: Text("Regular",
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: widget.reward.isSelfRemoving
                            ? Theme.of(context).accentColor
                            : kBackGroundWhite,
                      )),
            ),
          ),
          height: 50,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            setState(() {
              widget.reward.isSelfRemoving = false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTitleTextField() {
    return AnimatedBuilder(
      animation: _titleOffset,
      builder: (context, child) {
        return SlideTransition(
            position: _titleOffset,
            child: Material(
              type: MaterialType.transparency,
              child: IgnorePointer(
                ignoring: !_isInEditMode,
                child: TextField(
                  controller: _titleController,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(color: kBackGroundWhite),
                  decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: _isInEditMode
                        ? const UnderlineInputBorder(
                            borderSide: BorderSide(color: kBackGroundWhite))
                        : InputBorder.none,
                  ),
                ),
              ),
            ));
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return AnimatedBuilder(
        animation: _descriptionOffset,
        builder: (context, child) {
          return SlideTransition(
              position: _descriptionOffset,
              child: Material(
                type: MaterialType.transparency,
                child: IgnorePointer(
                  ignoring: !_isInEditMode,
                  child: TextField(
                    controller: _descriptionController,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: kBackGroundWhite, fontSize: 22),
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: _isInEditMode
                          ? const UnderlineInputBorder(
                              borderSide: BorderSide(color: kBackGroundWhite))
                          : InputBorder.none,
                    ),
                  ),
                ),
              ));
        });
  }

  MaterialButton _buildEditButton({Function onPressed}) {
    return MaterialButton(
        onPressed: () {
          onPressed();
          setState(() {
            _isInEditMode = !_isInEditMode;
          });
        },
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: kBackGroundWhite,
        child: _isInEditMode
            ? Text(
                "Save Reward",
                style: Theme.of(context).textTheme.button.copyWith(
                      fontSize: 12,
                      color: kDeepOrange,
                    ),
              )
            : Text(
                "Edit Reward",
                style: Theme.of(context).textTheme.button.copyWith(
                      fontSize: 12,
                      color: kDeepOrange,
                    ),
              ));
  }

  MaterialButton _buildRewardDeleteButton() {
    return MaterialButton(
      onPressed: () {
        Navigator.pop(context);
        Get.find<ContentController>().deleteReward(widget.reward);
      },
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: kLightRed,
      child: Text(
        "Delete Reward",
        style: Theme.of(context).textTheme.button.copyWith(
              fontSize: 12,
              color: kBackGroundWhite,
            ),
      ),
    );
  }
}