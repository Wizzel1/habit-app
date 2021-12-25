import 'package:Marbit/models/models.dart';
import 'package:Marbit/screens/screens.dart';
import 'package:Marbit/util/util.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class RewardContainer extends StatelessWidget {
  final Reward? reward;

  const RewardContainer({Key? key, this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Hero(
        tag: "all${reward!.id}",
        child: GestureDetector(
          onTap: () {
            Get.to(() => RewardDetailScreen(reward: reward));
          },
          child: Neumorphic(
            style: kInactiveNeumorphStyle.copyWith(color: kLightOrange),
            child: SizedBox(
              height: 90,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: Text(
                        reward!.name!,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: kBackGroundWhite,
                            ),
                      ),
                    ),
                    Icon(
                      reward!.isSelfRemoving!
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
      ),
    );
  }
}
