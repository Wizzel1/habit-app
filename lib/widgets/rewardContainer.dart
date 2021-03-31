import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RewardContainer extends StatelessWidget {
  final Reward reward;

  const RewardContainer({Key key, this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "all${reward.id}",
      child: GestureDetector(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => HabitDetailScreen(
          //       habit: habit,
          //       alterHeroTag: true,
          //     ),
          //   ),
          // );
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: kLightOrange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    type: MaterialType.transparency,
                    child: Text(
                      reward.name,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: kBackGroundWhite, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(
                    reward.isOneTime
                        ? FontAwesomeIcons.ban
                        : FontAwesomeIcons.redoAlt,
                    color: kBackGroundWhite,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
