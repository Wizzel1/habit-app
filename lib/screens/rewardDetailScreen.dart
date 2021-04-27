import 'dart:async';
import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/constants.dart';
import 'package:Marbit/widgets/widgets.dart';
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

  AnimationController _editAnimController;
  Animation<Offset> _titleOffset;
  Animation<Offset> _descriptionOffset;

  final Completer _screenBuiltCompleter = Completer();
  final int _mainScreenAnimationDuration = 200;
  final TutorialController _tutorialController = Get.find<TutorialController>();
  final EditContentController _editContentController =
      Get.find<EditContentController>();

  @override
  void initState() {
    _editAnimController = AnimationController(vsync: this);
    _editContentController.loadRewardValues(widget.reward);

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
                        child: _buildEditButton(
                          onPressed: () {
                            if (_isInEditMode) {
                              FocusScope.of(context).unfocus();
                              Get.find<EditContentController>()
                                  .updateReward(widget.reward.id);
                            }
                            _toggleEditingAnimation();
                          },
                        ),
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
        Expanded(
          flex: 10,
          child: BouncingButton(
            onPressed: () {
              if (!_isInEditMode) return;
              setState(() {
                _editContentController.isSelfRemoving = true;
              });
            },
            height: 50,
            color: _editContentController.isSelfRemoving
                ? kDeepOrange
                : kBackGroundWhite,
            child: Text(
              'one_time'.tr,
              style: Theme.of(context).textTheme.button.copyWith(
                  color: _editContentController.isSelfRemoving
                      ? kBackGroundWhite
                      : Theme.of(context).accentColor),
            ),
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 10,
          child: BouncingButton(
            onPressed: () {
              if (!_isInEditMode) return;
              setState(() {
                _editContentController.isSelfRemoving = false;
              });
            },
            height: 50,
            color: _editContentController.isSelfRemoving
                ? kBackGroundWhite
                : kDeepOrange,
            child: Text(
              'regular'.tr,
              style: Theme.of(context).textTheme.button.copyWith(
                    color: _editContentController.isSelfRemoving
                        ? Theme.of(context).accentColor
                        : kBackGroundWhite,
                  ),
            ),
          ),
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
                  controller: _editContentController.titleController,
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
                    controller: _editContentController.descriptionController,
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

  Widget _buildEditButton({Function onPressed}) {
    return BouncingButton(
      onPressed: () {
        onPressed();
        setState(() {
          _isInEditMode = !_isInEditMode;
        });
      },
      child: _isInEditMode
          ? Text(
              'save_reward'.tr,
              style: Theme.of(context).textTheme.button.copyWith(
                    fontSize: 12,
                    color: kDeepOrange,
                  ),
            )
          : Text(
              'edit_reward'.tr,
              style: Theme.of(context).textTheme.button.copyWith(
                    fontSize: 12,
                    color: kDeepOrange,
                  ),
            ),
    );
  }

  Widget _buildRewardDeleteButton() {
    return BouncingButton(
      onPressed: () {
        Get.back();
        Get.find<ContentController>().deleteReward(widget.reward);
      },
      color: kLightRed,
      child: Text(
        'delete_reward'.tr,
        style: Theme.of(context).textTheme.button.copyWith(
              fontSize: 12,
              color: kBackGroundWhite,
            ),
      ),
    );
  }
}
