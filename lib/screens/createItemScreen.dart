import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:Marbit/controllers/controllers.dart';

import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/util.dart';

final List<String> dayNames = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];

class CreateItemScreen extends StatefulWidget {
  CreateItemScreen({Key key}) : super(key: key);

  @override
  _CreateItemScreenState createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
  PageController _pageController;
  bool _wantToCreateHabit = false;

  final int _contentFlex = 1;

  final ContentController _contentController = Get.find<ContentController>();
  final CreateItemController _createItemController =
      Get.put(CreateItemController());

  @override
  void initState() {
    if (_pageController == null) _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: [
            Positioned(
                bottom: (screenSize.height / 2) - 45,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: kBackGroundWhite,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  height: 90,
                  width: 15,
                  child: RotatedBox(
                      quarterTurns: -1,
                      child: Center(
                          child: Text(
                        "Menu",
                        style: Theme.of(context).textTheme.button,
                      ))),
                )),
            Positioned.fill(
              child: PageView(
                //TODO: disable scrolling
                //physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: _pageController,
                children: [
                  buildSelectionButtonRow(),
                  if (_wantToCreateHabit) ...[
                    buildTitleInputPage(),
                    buildDescriptionInputPage(),
                    buildCompletionGoalStepper(),
                    buildRewardSelectionPage(),
                    buildSchedulerPage()
                  ] else ...[
                    buildTitleInputPage(),
                    buildDescriptionInputPage(),
                    buildRewardIntervalPage()
                  ]
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildSelectionButtonRow() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleSection(title: "Create a..."),
          Expanded(
            flex: _contentFlex,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      elevation: 0,
                      color: kBackGroundWhite,
                      child: Container(
                        height: 50,
                        width: 100,
                        child: Center(
                          child: Text(
                            "Habit",
                            style: Theme.of(context).textTheme.button.copyWith(
                                fontSize: 20,
                                color: Theme.of(context).accentColor),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        setState(() {
                          _wantToCreateHabit = true;
                        });
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.ease);
                      },
                    ),
                    MaterialButton(
                      elevation: 0,
                      color: kBackGroundWhite,
                      child: Container(
                        height: 50,
                        width: 100,
                        child: Center(
                          child: Text(
                            "Reward",
                            style: Theme.of(context).textTheme.button.copyWith(
                                fontSize: 20,
                                color: Theme.of(context).accentColor),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        setState(() {
                          _wantToCreateHabit = false;
                        });
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.ease);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRewardIntervalPage() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleSection(title: "Frequenzy"),
          Expanded(
            flex: _contentFlex,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      elevation: 0,
                      color: _createItemController.isSelfRemovingReward
                          ? kDeepOrange
                          : kBackGroundWhite,
                      child: Container(
                        height: 50,
                        width: 75,
                        child: Center(
                          child: Text(
                            "One Time",
                            style: Theme.of(context).textTheme.button.copyWith(
                                color:
                                    _createItemController.isSelfRemovingReward
                                        ? kBackGroundWhite
                                        : Theme.of(context).accentColor),
                          ),
                        ),
                      ),
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        setState(() {
                          _createItemController.isSelfRemovingReward = true;
                        });
                      },
                    ),
                    MaterialButton(
                      elevation: 0,
                      color: _createItemController.isSelfRemovingReward
                          ? kBackGroundWhite
                          : kDeepOrange,
                      child: Container(
                        height: 50,
                        width: 75,
                        child: Center(
                          child: Text("Regular",
                              style:
                                  Theme.of(context).textTheme.button.copyWith(
                                        color: _createItemController
                                                .isSelfRemovingReward
                                            ? Theme.of(context).accentColor
                                            : kBackGroundWhite,
                                      )),
                        ),
                      ),
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        setState(() {
                          _createItemController.isSelfRemovingReward = false;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Center(
                    child: Text(
                      "If you choose 'Once' the reward will get deleted from the habitlist when it appears.",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                MaterialButton(
                  elevation: 0,
                  color: kBackGroundWhite,
                  onPressed: () async {
                    _createItemController.createReward();
                    await Get.find<NavigationController>().navigateToIndex(0);
                    _pageController.jumpToPage(0);
                  },
                  child: Text(
                    "Create",
                    style: Theme.of(context).textTheme.button,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitleInputPage() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleSection(title: "Title"),
          Expanded(
            flex: _contentFlex,
            child: Column(
              children: [
                CustomTextField(
                    controller: _createItemController.createTitleTextController,
                    title: "Type your Title here"),
                const SizedBox(height: 30),
                CenteredScrollIconButton(pageController: _pageController)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCompletionGoalStepper() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TitleSection(title: "Times per Day?"),
          Expanded(
            flex: _contentFlex,
            child: Column(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        elevation: 0,
                        onPressed: () {
                          if (_createItemController.completionGoalCount <= 1)
                            return;
                          setState(() {
                            _createItemController.completionGoalCount--;
                          });
                        },
                        color: kBackGroundWhite,
                        child: Icon(
                          Icons.remove,
                          color: Theme.of(context).accentColor,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      Text(
                        "${_createItemController.completionGoalCount}",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      MaterialButton(
                        elevation: 0,
                        onPressed: () {
                          if (_createItemController.completionGoalCount >=
                              ContentController.maxDailyCompletions) return;
                          setState(() {
                            _createItemController.completionGoalCount++;
                          });
                        },
                        color: kBackGroundWhite,
                        child: Icon(Icons.add,
                            color: Theme.of(context).accentColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                CenteredScrollIconButton(pageController: _pageController)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDescriptionInputPage() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TitleSection(title: "Description"),
          Expanded(
            flex: _contentFlex,
            child: Column(
              children: [
                CustomTextField(
                  controller: _createItemController.createDescriptionController,
                  title: "Type your Description",
                ),
                Spacer(),
                CenteredScrollIconButton(pageController: _pageController)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRewardSelectionPage() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TitleSection(title: "Rewards"),
          Expanded(
              flex: _contentFlex,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _contentController.allRewardList.length,
                itemBuilder: (context, index) {
                  Reward reward = _contentController.allRewardList[index];
                  bool isSelected = (_createItemController.selectedRewards
                      .any((element) => element.name == reward.name));
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: SelectableRewardContainer(
                      reward: _contentController.allRewardList[index],
                      isSelectedReward: isSelected,
                      onTap: () {
                        setState(() {
                          _createItemController.selectedRewards.contains(reward)
                              ? _createItemController.selectedRewards
                                  .remove(reward)
                              : _createItemController.selectedRewards
                                  .add(reward);
                        });
                      },
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  Widget buildSchedulerPage() {
    return Column(
      children: [
        const TitleSection(title: "Schedule"),
        Expanded(
          flex: _contentFlex,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    7,
                    (index) => ScheduleButton(
                        index: index,
                        onTap: (tappedIndex) {
                          tappedIndex += 1;
                          _createItemController.scheduledDays
                                  .contains(tappedIndex)
                              ? _createItemController.scheduledDays
                                  .remove(tappedIndex)
                              : _createItemController.scheduledDays
                                  .add(tappedIndex);
                        }),
                  ),
                ),
                const SizedBox(height: 30),
                MaterialButton(
                  elevation: 0,
                  color: kBackGroundWhite,
                  onPressed: () async {
                    _createItemController.createHabit();
                    await Get.find<NavigationController>().navigateToIndex(0);
                    _pageController.jumpToPage(0);
                  },
                  child: Text(
                    "Create",
                    style: Theme.of(context).textTheme.button,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CenteredScrollIconButton extends StatelessWidget {
  const CenteredScrollIconButton({
    Key key,
    @required PageController pageController,
  })  : _pageController = pageController,
        super(key: key);

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: IconButton(
        icon: Icon(
          Icons.arrow_downward_rounded,
          color: kBackGroundWhite,
          size: 40,
        ),
        onPressed: () {
          _pageController.nextPage(
              duration: Duration(milliseconds: 200), curve: Curves.ease);
        },
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final String title;
  final int titleFlex = 1;

  const TitleSection({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: titleFlex,
      child: Column(
        children: [
          const Spacer(flex: 2),
          Text(title, style: Theme.of(context).textTheme.headline2),
          const Spacer(flex: 1)
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;

  const CustomTextField({Key key, this.controller, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: Theme.of(context).accentColor),
        decoration: InputDecoration(
          filled: true,
          fillColor: kBackGroundWhite,
          hintText: title,
          hintStyle: Theme.of(context)
              .textTheme
              .subtitle2
              .copyWith(color: Theme.of(context).accentColor),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class ScheduleButton extends StatefulWidget {
  final int index;
  final Function onTap;
  const ScheduleButton({
    Key key,
    @required this.onTap,
    this.index,
  }) : super(key: key);

  @override
  _ScheduleButtonState createState() => _ScheduleButtonState();
}

class _ScheduleButtonState extends State<ScheduleButton> {
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTapped = !isTapped;
          widget.onTap(widget.index);
        });
      },
      child: Container(
        height: 60,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isTapped ? kDeepOrange : kBackGroundWhite),
        child: Center(
          child: Text(
            dayNames[widget.index],
            style: Theme.of(context).textTheme.button.copyWith(
                  fontSize: 12,
                  color: isTapped ? kBackGroundWhite : kDeepOrange,
                ),
          ),
        ),
      ),
    );
  }
}
