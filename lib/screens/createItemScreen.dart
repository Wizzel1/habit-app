import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                child: DrawerExtension()),
            Positioned.fill(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
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
                Center(
                  child: PageScrollIconButton(
                    scrollToNextPage: false,
                    pageController: _pageController,
                    onPressedButton: (scrollAction) {
                      scrollAction();
                    },
                  ),
                )
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
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomTextField(
                    controller: _createItemController.createTitleTextController,
                    title: "Type your Title here"),
                const SizedBox(height: 10),
                _wantToCreateHabit
                    ? const SizedBox.shrink()
                    : Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              child: MinMaxTextField(
                                  controller:
                                      _createItemController.minTextController,
                                  title: "min"),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "-",
                              style: TextStyle(
                                  color: kBackGroundWhite, fontSize: 30),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 100,
                              child: MinMaxTextField(
                                  controller:
                                      _createItemController.maxTextController,
                                  title: "max"),
                            ),
                          ],
                        ),
                      ),
                _wantToCreateHabit
                    ? const SizedBox.shrink()
                    : MaterialButton(
                        elevation: 0,
                        color: kBackGroundWhite,
                        onPressed: () {
                          if (int.parse(_createItemController
                                  .minTextController.text) >
                              int.parse(_createItemController
                                  .maxTextController.text)) {
                            SnackBars.showErrorSnackBar("Invalid Range",
                                "Please make sure 'Min' is not greater than 'Max'");
                            return;
                          }

                          _createItemController.createTitleTextController.text =
                              _createItemController
                                      .createTitleTextController.text +
                                  _createItemController.minTextController.text +
                                  "-" +
                                  _createItemController.maxTextController.text +
                                  " ";
                        },
                        child: Text(
                          "Add Variable",
                          style: Theme.of(context).textTheme.button,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PageScrollIconButton(
                      scrollToNextPage: false,
                      pageController: _pageController,
                      onPressedButton: (scrollFunction) {
                        scrollFunction();
                      },
                    ),
                    PageScrollIconButton(
                      scrollToNextPage: true,
                      pageController: _pageController,
                      onPressedButton: (scrollFunction) {
                        if (_createItemController
                            .createTitleTextController.text.isEmpty) {
                          SnackBars.showWarningSnackBar(
                              "Warning", "Please select chose a Title");
                        } else {
                          scrollFunction();
                        }
                      },
                    )
                  ],
                )
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PageScrollIconButton(
                      scrollToNextPage: false,
                      pageController: _pageController,
                      onPressedButton: (scrollFunction) {
                        scrollFunction();
                      },
                    ),
                    PageScrollIconButton(
                      scrollToNextPage: true,
                      pageController: _pageController,
                      onPressedButton: (scrollFunction) {
                        scrollFunction();
                      },
                    )
                  ],
                )
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PageScrollIconButton(
                      scrollToNextPage: false,
                      pageController: _pageController,
                      onPressedButton: (scrollFunction) {
                        scrollFunction();
                      },
                    ),
                    PageScrollIconButton(
                      scrollToNextPage: true,
                      pageController: _pageController,
                      onPressedButton: (scrollFunction) {
                        scrollFunction();
                      },
                    )
                  ],
                )
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
                  String rewardReference =
                      _contentController.allRewardList[index].id;
                  bool isSelected = (_createItemController
                      .selectedRewardReferences
                      .any((element) => element == rewardReference));
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: SelectableRewardContainer(
                      reward: _contentController.allRewardList[index],
                      isSelectedReward: isSelected,
                      onTap: () {
                        setState(() {
                          _createItemController.selectedRewardReferences
                                  .contains(rewardReference)
                              ? _createItemController.selectedRewardReferences
                                  .remove(rewardReference)
                              : _createItemController.selectedRewardReferences
                                  .add(rewardReference);
                        });
                      },
                    ),
                  );
                },
              )),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PageScrollIconButton(
                scrollToNextPage: false,
                pageController: _pageController,
                onPressedButton: (scrollFunction) {
                  scrollFunction();
                },
              ),
              PageScrollIconButton(
                scrollToNextPage: true,
                pageController: _pageController,
                onPressedButton: (scrollFunction) {
                  if (_createItemController.selectedRewardReferences.isEmpty) {
                    SnackBars.showWarningSnackBar(
                        "Warning", "Please select at least one Reward");
                  } else {
                    scrollFunction();
                  }
                },
              )
            ],
          )
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
                          int weekDayIndex = tappedIndex += 1;

                          _createItemController.scheduledDays
                                  .contains(weekDayIndex)
                              ? _createItemController.scheduledDays
                                  .remove(weekDayIndex)
                              : _createItemController.scheduledDays
                                  .add(weekDayIndex);
                        }),
                  ),
                ),
                const SizedBox(height: 30),
                MaterialButton(
                  elevation: 0,
                  color: kBackGroundWhite,
                  onPressed: () async {
                    if (_createItemController.scheduledDays.isEmpty) {
                      SnackBars.showWarningSnackBar(
                          "Warning", "Please select at least one Day");
                    } else {
                      _createItemController.createHabit();
                      await Get.find<NavigationController>().navigateToIndex(0);
                      _pageController.jumpToPage(0);
                    }
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

class PageScrollIconButton extends StatelessWidget {
  final PageController pageController;
  final Function(Function) onPressedButton;
  final bool scrollToNextPage;

  const PageScrollIconButton(
      {Key key,
      @required this.pageController,
      @required this.onPressedButton,
      @required this.scrollToNextPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        scrollToNextPage
            ? FontAwesomeIcons.arrowDown
            : FontAwesomeIcons.arrowUp,
        color: kBackGroundWhite,
        size: 40,
      ),
      onPressed: () {
        Function scrollToNext = () {
          pageController.nextPage(
              duration: const Duration(milliseconds: 200), curve: Curves.ease);
        };

        Function scrollToPrevious = () {
          pageController.previousPage(
              duration: const Duration(milliseconds: 200), curve: Curves.ease);
        };

        onPressedButton(scrollToNextPage ? scrollToNext : scrollToPrevious);
      },
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
          Text(title, style: Theme.of(context).textTheme.headline3),
          const Spacer(flex: 1)
        ],
      ),
    );
  }
}

class MinMaxTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;

  const MinMaxTextField({Key key, this.controller, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      controller: controller,
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .subtitle2
          .copyWith(fontSize: 20, color: Theme.of(context).accentColor),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        filled: true,
        fillColor: kBackGroundWhite,
        hintText: title,
        hintStyle: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(fontSize: 20, color: Theme.of(context).accentColor),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;

  const CustomTextField({
    Key key,
    this.controller,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(color: Theme.of(context).accentColor),
        decoration: InputDecoration(
          filled: true,
          fillColor: kBackGroundWhite,
          hintText: title,
          hintStyle: Theme.of(context)
              .textTheme
              .headline6
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
