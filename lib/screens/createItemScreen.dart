import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:Marbit/controllers/controllers.dart';

import 'package:Marbit/util/util.dart';

final List<String> dayNames = [
  'Mo'.tr,
  'Tu'.tr,
  'We'.tr,
  'Th'.tr,
  'Fr'.tr,
  'Sa'.tr,
  'Su'.tr
];

class CreateItemScreen extends StatefulWidget {
  CreateItemScreen({Key key}) : super(key: key);

  @override
  _CreateItemScreenState createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
  PageController _pageController;
  bool _wantToCreateHabit = false;
  CreateItemController _createItemController;

  final int _contentFlex = 1;
  final ContentController _contentController = Get.find<ContentController>();

  @override
  void initState() {
    _createItemController = Get.put(CreateItemController());
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    Get.delete<CreateItemController>();
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
                child: DrawerExtension(
                  color: kBackGroundWhite,
                )),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
            ),
          ],
        ));
  }

  Widget buildSelectionButtonRow() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleSection(title: 'createItemScreen_create_title'.tr),
          Expanded(
            flex: _contentFlex,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 10,
                      child: MaterialButton(
                        height: 60,
                        elevation: 0,
                        color: kBackGroundWhite,
                        child: Center(
                          child: Text(
                            'habit'.tr,
                            style: Theme.of(context).textTheme.button.copyWith(
                                fontSize: 18,
                                color: Theme.of(context).accentColor),
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
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 10,
                      child: MaterialButton(
                        height: 60,
                        elevation: 0,
                        color: kBackGroundWhite,
                        child: Center(
                          child: Text(
                            'reward'.tr,
                            style: Theme.of(context).textTheme.button.copyWith(
                                fontSize: 18,
                                color: Theme.of(context).accentColor),
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
                      ),
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
          TitleSection(title: 'frequenzy'.tr),
          Expanded(
            flex: _contentFlex,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 10,
                      child: MaterialButton(
                        elevation: 0,
                        color: _createItemController.isSelfRemovingReward
                            ? kDeepOrange
                            : kBackGroundWhite,
                        child: Center(
                          child: Text(
                            'one_time'.tr,
                            style: Theme.of(context).textTheme.button.copyWith(
                                color:
                                    _createItemController.isSelfRemovingReward
                                        ? kBackGroundWhite
                                        : Theme.of(context).accentColor),
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
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 10,
                      child: MaterialButton(
                        elevation: 0,
                        color: _createItemController.isSelfRemovingReward
                            ? kBackGroundWhite
                            : kDeepOrange,
                        child: Center(
                          child: Text('regular'.tr,
                              style:
                                  Theme.of(context).textTheme.button.copyWith(
                                        color: _createItemController
                                                .isSelfRemovingReward
                                            ? Theme.of(context).accentColor
                                            : kBackGroundWhite,
                                      )),
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
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    'frequenzy_explanation'.tr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                const SizedBox(height: 30),
                MaterialButton(
                  elevation: 0,
                  color: kBackGroundWhite,
                  onPressed: () async {
                    _createItemController.createAndSaveReward();
                    await Get.find<NavigationController>().navigateToIndex(0);
                    _pageController.jumpToPage(0);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: Text(
                      'create_Button_title'.tr,
                      style: Theme.of(context).textTheme.button,
                    ),
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
          TitleSection(title: 'title'.tr),
          Expanded(
            flex: _contentFlex,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomTextField(
                    controller: _createItemController.createTitleTextController,
                    title: 'title_textfield_hint'.tr),
                const SizedBox(height: 10),
                _wantToCreateHabit
                    ? const SizedBox.shrink()
                    : Center(
                        child: Text(
                          'number_range_hint'.tr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.caption,
                        ),
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
                              'warning'.tr, 'title_missing_warning'.tr);
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
          TitleSection(title: 'times_per_day'.tr),
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
          TitleSection(title: 'description'.tr),
          Expanded(
            flex: _contentFlex,
            child: Column(
              children: [
                CustomTextField(
                  controller: _createItemController.createDescriptionController,
                  title: 'description_textfield_hint'.tr,
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
          TitleSection(title: 'rewards'.tr),
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
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                        'warning'.tr, 'reward_missing_warning'.tr);
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
        TitleSection(title: 'schedule'.tr),
        Expanded(
          flex: _contentFlex,
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
              const SizedBox(height: 80),
              MaterialButton(
                elevation: 0,
                color: kBackGroundWhite,
                onPressed: () async {
                  if (_createItemController.scheduledDays.isEmpty) {
                    SnackBars.showWarningSnackBar(
                        'warning'.tr, 'missing_schedule_warning'.tr);
                  } else {
                    _createItemController.createAndSaveHabit();
                    await Get.find<NavigationController>().navigateToIndex(0);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  child: Text(
                    'create_Button_title'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: kDeepOrange),
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ],
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
          Text(
            title,
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
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
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .headline6
          .copyWith(color: Theme.of(context).accentColor),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(6, 24, 6, 16),
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
