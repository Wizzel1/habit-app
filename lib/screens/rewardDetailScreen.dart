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

  final Completer _screenBuiltCompleter = Completer();
  final int _mainScreenAnimationDuration = 200;
  final EditContentController _editContentController =
      Get.find<EditContentController>();

  @override
  void initState() {
    _editContentController.loadRewardValues(widget.reward);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        300.milliseconds.delay().then(
          (value) {
            _screenBuiltCompleter.complete();

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
                      const SizedBox(height: 30),
                      Center(
                        child: _buildEditButton(
                          onPressed: () {
                            if (_isInEditMode) {
                              FocusScope.of(context).unfocus();
                              Get.find<EditContentController>()
                                  .updateReward(widget.reward.id);
                            }
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
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 10,
            child: NeumorphPressSwitch(
              onPressed: () {
                if (!_isInEditMode) return;
                _editContentController.isSelfRemoving.value = true;
              },
              height: 50,
              style: _editContentController.isSelfRemoving.value
                  ? kActiveNeumorphStyle
                  : kInactiveNeumorphStyle,
              child: Text(
                'one_time'.tr,
                style: Theme.of(context).textTheme.button.copyWith(
                    color: _editContentController.isSelfRemoving.value
                        ? kBackGroundWhite
                        : Theme.of(context).accentColor),
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 10,
            child: NeumorphPressSwitch(
              onPressed: () {
                if (!_isInEditMode) return;
                _editContentController.isSelfRemoving.value = false;
              },
              height: 50,
              style: _editContentController.isSelfRemoving.value
                  ? kInactiveNeumorphStyle
                  : kActiveNeumorphStyle,
              child: Text(
                'regular'.tr,
                style: Theme.of(context).textTheme.button.copyWith(
                      color: _editContentController.isSelfRemoving.value
                          ? Theme.of(context).accentColor
                          : kBackGroundWhite,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleTextField() {
    return Material(
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
    );
  }

  Widget _buildEditButton({Function onPressed}) {
    return CustomNeumorphButton(
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
    return NeumorphPressSwitch(
      onPressed: () {
        Get.back();
        Get.find<ContentController>().deleteReward(widget.reward);
      },
      style: kInactiveNeumorphStyle.copyWith(color: kLightRed),
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
