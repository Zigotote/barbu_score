import 'package:barbu_score/commons/models/domino_points_props.dart';
import 'package:flutter/material.dart';

import '../commons/models/contract_info.dart';
import '../commons/utils/storage.dart';
import '../commons/widgets/default_page.dart';

class MySettings extends StatelessWidget {
  const MySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      title: "Paramètres",
      hasLeading: true,
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Thème"),
              ElevatedButton(onPressed: () {}, child: const Text('Sombre')),
              ElevatedButton(onPressed: () {}, child: const Text('Clair'))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Score barbu"),
              Expanded(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  initialValue:
                      MyStorage().getPoints(ContractsInfo.barbu).toString(),
                  onChanged: (value) => MyStorage()
                      .savePoints(ContractsInfo.barbu, int.parse(value)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Points par dame"),
              Expanded(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  initialValue:
                      MyStorage().getPoints(ContractsInfo.noQueens).toString(),
                  onChanged: (value) => MyStorage()
                      .savePoints(ContractsInfo.noQueens, int.parse(value)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Points réussite"),
              Expanded(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  initialValue: MyStorage().getDominoPoints().points.toString(),
                  onChanged: (value) => MyStorage().saveDominoPoints(
                    DominoPointsProps(
                      isFix: false,
                      points: value
                          .replaceFirst("[", "")
                          .replaceFirst("]", "")
                          .split(",")
                          .map((e) => int.parse(e))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
