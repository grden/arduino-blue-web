import 'package:flutter/material.dart';

import '../utils/models/soldier_model.dart';
import '../utils/themes/color_manager.dart';
import '../utils/themes/text_manager.dart';
import '../utils/widgets/sizedbox_widget.dart';

class SoldierTile extends StatelessWidget {
  const SoldierTile({super.key, required this.soldier});

  final Soldier soldier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Stack(children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/default_profile.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              if (checkForAlert(soldier))
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  left: 0,
                  child: Icon(Icons.error, color: ColorManager.error, size: 28),
                ),
            ]),
            const Width(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${soldier.name} 훈련병', style: TextManager.main17),
                Text('심박수: ${soldier.bpm.toString()} bpm',
                    style: TextManager.second17),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool checkForAlert(Soldier soldier) {
    if (soldier.temp > 37 || (soldier.bpm > 190 || soldier.bpm < 40)) {
      return true;
    } else {
      return false;
    }
  }
}
