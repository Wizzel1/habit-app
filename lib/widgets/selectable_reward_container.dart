import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SelectableRewardContainer extends StatefulWidget {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool? isSelectedReward;
  final Reward? reward;

  const SelectableRewardContainer({
    Key? key,
    this.onTap,
    this.isSelectedReward,
    this.reward,
    this.onLongPress,
  }) : super(key: key);

  @override
  _SelectableRewardContainerState createState() =>
      _SelectableRewardContainerState();
}

class _SelectableRewardContainerState extends State<SelectableRewardContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: widget.isSelectedReward! ? kDeepOrange : kBackGroundWhite,
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    type: MaterialType.transparency,
                    child: Text(
                      widget.reward!.name!,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: widget.isSelectedReward!
                                ? kBackGroundWhite
                                : kDeepOrange,
                          ),
                    ),
                  ),
                ],
              ),
              Icon(
                widget.reward!.isSelfRemoving!
                    ? FontAwesomeIcons.ban
                    : FontAwesomeIcons.redoAlt,
                color: widget.isSelectedReward! ? kBackGroundWhite : kDeepOrange,
              )
            ],
          ),
        ),
      ),
    );
  }
}
